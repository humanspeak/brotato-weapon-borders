extends "res://main.gd"

const WBData = preload("res://mods-unpacked/JasonK-WeaponBorders/weapon_borders_data.gd")


# In endless mode the game doesn't count the run as won at wave 20, so credit
# the win as soon as the final regular wave is survived.
func _set_run_states() -> void:
	._set_run_states()
	if RunData.is_endless_run and RunData.current_wave == RunData.nb_of_waves and not _is_wave_failed:
		WBData.record_win(RunData.current_difficulty)
