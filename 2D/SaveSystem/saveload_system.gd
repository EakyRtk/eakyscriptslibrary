class_name SaveLoad extends Object

const SAVE_LOAD_LOCATION : String = "user://save/"
const DEFAULT_SAVE_NAME : String = "save01"
const DEFAULT_SAVE : Dictionary = {
    "test_key": "test_value",
}

static func create_save_file(save_data: Dictionary = DEFAULT_SAVE, save_name: String = DEFAULT_SAVE_NAME) -> void:
    if not DirAccess.dir_exists_absolute(SAVE_LOAD_LOCATION):
        DirAccess.make_dir_absolute(SAVE_LOAD_LOCATION)
    if not FileAccess.file_exists(SAVE_LOAD_LOCATION + save_name + ".json"):
        var file := FileAccess.open(SAVE_LOAD_LOCATION + save_name + ".json", FileAccess.WRITE)
        file.store_string(JSON.stringify(save_data, "\t"))

static func load_save_file(save_name: String = DEFAULT_SAVE_NAME) -> Dictionary:
    if not FileAccess.file_exists(SAVE_LOAD_LOCATION + save_name + ".json"):
        printerr("SAVE FILE \"%s\" DOES NOT EXIST !!" % save_name)
        return {}
    var _data : Dictionary = JSON.parse_string(FileAccess.open(SAVE_LOAD_LOCATION + save_name + ".json", FileAccess.READ).get_as_text())
    return _data