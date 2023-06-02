class_name Save_Data
extends Resource

const SAVE_GAME_PATH = "user://save_files/save_data.tres"
const SAVE_GAME_FOLDER_PATH = "user://save_files/"
const CHARACTERS_FOLDER_PATH = "user://save_files/characters/"



@export var version = 1
@export var characters: Array[Character_Data]

@export var map_name := ""
@export var global_position := Vector2.ZERO
@export var gamemode := Global.Gamemode.ENCOUNTER

func write_save_data() -> void:
	ResourceSaver.save(self, SAVE_GAME_PATH)
	
static func save_exists() -> bool:
	return ResourceLoader.exists(SAVE_GAME_PATH)
	
static func load_save_data() -> Resource:
	return ResourceLoader.load(SAVE_GAME_PATH, "", ResourceLoader.CACHE_MODE_REPLACE)
	
