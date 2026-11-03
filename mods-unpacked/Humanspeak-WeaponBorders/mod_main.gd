extends Node

const MOD_ID := "Humanspeak-WeaponBorders"


func _init() -> void:
	var dir := ModLoaderMod.get_unpacked_dir().plus_file(MOD_ID)
	var ext := dir.plus_file("extensions")
	ModLoaderMod.install_script_extension(ext.plus_file("weapon_selection.gd"))
	ModLoaderMod.install_script_extension(ext.plus_file("run_data.gd"))
	ModLoaderMod.install_script_extension(ext.plus_file("main.gd"))
	ModLoaderLog.info("Loaded", MOD_ID)
