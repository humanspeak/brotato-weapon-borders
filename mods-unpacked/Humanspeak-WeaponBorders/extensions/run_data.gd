extends "res://singletons/run_data.gd"

const WBData = preload("res://mods-unpacked/Humanspeak-WeaponBorders/weapon_borders_data.gd")


# Normal wins: surviving wave 20 or killing the final boss(es).
func apply_run_won() -> void:
	.apply_run_won()
	WBData.record_win(current_difficulty)
