extends Node2D

func _ready() -> void:
    SaveLoad.create_save_file()
    print(SaveLoad.load_save_file())