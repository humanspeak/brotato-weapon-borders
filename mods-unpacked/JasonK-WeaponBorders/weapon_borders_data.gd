extends Reference
# Persistent storage for the mod, kept separate from the game's own save.
#
# {
#   "best":        { "<zone>": { "<starting element my_id>": <highest danger won> } },
#   "current_run": { "zone": <zone>, "players": [ ["<my_id>", ...], ... ] }
# }

const MOD_ID := "JasonK-WeaponBorders"
const SAVE_PATH := "user://mod_weapon_borders.json"


static func _load() -> Dictionary:
	var f := File.new()
	if not f.file_exists(SAVE_PATH) or f.open(SAVE_PATH, File.READ) != OK:
		return {"best": {}, "current_run": {}}
	var parsed = parse_json(f.get_as_text())
	f.close()
	if not parsed is Dictionary:
		ModLoaderLog.error("Save file is corrupt, starting fresh", MOD_ID)
		return {"best": {}, "current_run": {}}
	if not parsed.has("best") or not parsed.best is Dictionary:
		parsed.best = {}
	if not parsed.has("current_run") or not parsed.current_run is Dictionary:
		parsed.current_run = {}
	return parsed


static func _save(data: Dictionary) -> void:
	var f := File.new()
	if f.open(SAVE_PATH, File.WRITE) != OK:
		ModLoaderLog.error("Could not write " + SAVE_PATH, MOD_ID)
		return
	f.store_string(to_json(data))
	f.close()


# Highest danger beaten (0-5) starting with this element in this zone, or -1.
static func get_best(data: Dictionary, zone: int, my_id: String) -> int:
	var zone_best = data.best.get(str(zone), {})
	return int(zone_best.get(my_id, -1))


static func load_data() -> Dictionary:
	return _load()


# Called when starting weapons are confirmed. players = [[my_id, ...], ...]
static func set_current_run(zone: int, players: Array) -> void:
	var data := _load()
	data.current_run = {"zone": zone, "players": players}
	_save(data)


# Credit every player's starting picks with the given danger. Safe to call
# more than once for the same run (only ever raises the stored value).
static func record_win(danger: int) -> void:
	var data := _load()
	var run: Dictionary = data.current_run
	if run.empty() or not run.has("players"):
		ModLoaderLog.info("Run won but no starting weapons were recorded for it (run started before the mod was installed?)", MOD_ID)
		return
	var zone_key := str(int(run.get("zone", 0)))
	if not data.best.has(zone_key):
		data.best[zone_key] = {}
	var zone_best: Dictionary = data.best[zone_key]
	var changed := false
	for picks in run.players:
		for my_id in picks:
			if danger > int(zone_best.get(my_id, -1)):
				zone_best[my_id] = danger
				changed = true
				ModLoaderLog.info("New best for %s in zone %s: danger %d" % [my_id, zone_key, danger], MOD_ID)
	if changed:
		_save(data)


# Same mapping the game uses for character borders.
static func danger_to_tier(danger: int) -> int:
	if danger < 0:
		return Tier.COMMON
	if danger == 0:
		return Tier.DANGER_0
	return danger
