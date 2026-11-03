extends "res://ui/menus/run/weapon_selection.gd"

const WBData = preload("res://mods-unpacked/Humanspeak-WeaponBorders/weapon_borders_data.gd")
const WB_MOD_ID := "Humanspeak-WeaponBorders"


# The base class (re)builds each player's grid here, including when co-op
# players join, so recolor right after it runs.
func _set_base_ui_player_count(count: int, is_coop_run: bool, initialize: bool = false) -> void:
	._set_base_ui_player_count(count, is_coop_run, initialize)
	_wb_apply_borders()


func _wb_apply_borders() -> void:
	var data = WBData.load_data()
	var zone = RunData.current_zone
	for inventory in _get_inventories():
		for element in inventory.get_children():
			if not element is InventoryElement or element.is_random or element.is_special:
				continue
			if not element.item is ItemParentData:
				continue
			var my_id: String = element.item.my_id
			_wb_paint(element, WBData.danger_to_tier(WBData.get_best(data, zone, my_id)))


func _on_selections_completed() -> void:
	var players := []
	for player_index in _player_weapons.size():
		var picks := []
		for picked in _player_weapons[player_index]:
			if picked is ItemParentData:
				picks.push_back(picked.my_id)
		players.push_back(picks)
	ModLoaderLog.info("Starting picks for zone %s: %s" % [str(RunData.current_zone), to_json(players)], WB_MOD_ID)
	WBData.set_current_run(RunData.current_zone, players)
	._on_selections_completed()


# Same as InventoryElement.update_background_color(), but with an explicit tier.
# (That function treats -1 as "use the item's tier", and -1 is also Tier.DANGER_0.)
# Only the look changes; element.item.tier is never touched, because the picked
# element.item becomes the actual weapon in the run.
func _wb_paint(element: InventoryElement, tier: int) -> void:
	var stylebox = element.get_stylebox("normal").duplicate()
	ItemService.change_inventory_element_stylebox_from_tier(stylebox, tier, 0.25, element._frame_panel)
	var m: Color = element.background_modulate
	stylebox.bg_color = lerp(stylebox.bg_color, Color(m.r, m.g, m.b), m.a)
	stylebox.bg_color.a = element.background_transparency
	element.add_stylebox_override("normal", stylebox)
