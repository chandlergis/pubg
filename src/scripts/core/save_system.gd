class_name SaveSystem
extends RefCounted

const SAVE_PATH := "user://save.json"


static func save(data: Dictionary) -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("SaveSystem: cannot open %s for write" % SAVE_PATH)
		return
	file.store_string(JSON.stringify(data, "  "))


static func load_data() -> Dictionary:
	if not FileAccess.file_exists(SAVE_PATH):
		return _default_data()
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	if parsed is Dictionary:
		return parsed
	return _default_data()


static func _default_data() -> Dictionary:
	return {
		"gold": 0,
		"stash": [],
		"owned_keys": [],
		"stats": {
			"raids_run": 0,
			"raids_extracted": 0,
			"kills": 0,
		},
	}
