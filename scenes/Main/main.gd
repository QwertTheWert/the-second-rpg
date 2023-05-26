class_name Main
extends Node2D

@onready var _grid = $Grid
@onready var _tokens = $Grid/Tokens
@onready var gamemode : GLOBALS.Mode


@export var _save: Save_Data



var is_shifted = false
var selected_players = []

func _ready():
	_create_or_load_save()
	_grid.generate_grid()
	_grid.generate_area()
	_tokens.generate_tokens()
	
	
func _input(event):
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.pressed:
			is_shifted = true
		else:
			is_shifted = false
			
func _create_or_load_save() -> void:
	if Save_Data.save_exists():
		_save = Save_Data.load_save_data() as Save_Data
	else:
		_save = Save_Data.new()
		_load_characters()
		_save.map_name = "map_1"
		_save.global_position = Vector2i(2,2)
		
		_save.write_save_data()
	
	_tokens.characters = _save.characters
	gamemode = _save.GAMEMODE

func _load_characters():
	var dir = DirAccess.open(_save.CHARACTERS_FOLDER_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var file_to_play_with = load(_save.CHARACTERS_FOLDER_PATH + file)
		_save.characters.append(file_to_play_with)
		file = dir.get_next()
