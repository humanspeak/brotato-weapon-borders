extends "res://ui/menus/run/weapon_selection.gd"

const WBData = preload("res://mods-unpacked/Humanspeak-WeaponBorders/weapon_borders_data.gd")


# The base class (re)builds each player's grid here, including when co-op
# players join, so recolor right after it runs.
func _set_base_ui_player_count(count: int, is_coop_run: bool, initialize: bool = false) -> void:
	._set_base_ui_player_count(count, is_coop_run, initialize)
	_wb_apply_borders()


func _wb_apply_borders() -> void:
	var data = WBData.load_data()
	for inventory in _get_inventories():
		for element in inventory.get_children():
			if not element is InventoryElement or element.is_random or element.is_special:
				continue
			if element.item == null or not "my_id" in element.item:
				continue
			var best = WBData.get_best(data, RunData.current_zone, element.item.my_id)
			# Only override the look; never touch element.item.tier, because the
			# picked element.item becomes the actual weapon in the run.
			element.update_background_color(WBData.danger_to_tier(best))


func _on_selections_completed() -> void:
	var players := []
	for player_index in _player_weapons.size():
		var picks := []
		for picked in _player_weapons[player_index]:
			if picked != null and "my_id" in picked:
				picks.push_back(picked.my_id)
		players.push_back(picks)
	WBData.set_current_run(RunData.current_zone, players)
	._on_selections_completed()
