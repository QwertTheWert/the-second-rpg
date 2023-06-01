class_name Main
extends Node2D

@onready var _grid = $Grid
@onready var _tokens = $Grid/Tokens
@onready var _portraits = $CanvasLayer/Portraits

@onready var gamemode : GLOBALS.Mode


@export var save: Save_Data
var selected_character: Array[String]
var is_paused:= false
var is_shifted:= false

func _ready():
	_create_or_load_save()
	_grid.calculate_bounds()
	_grid.generate_grid()
	_grid.generate_area()
	_tokens.generate_tokens()
	_portraits.generate_portraits()
	
	
func _input(event):
	if event is InputEventKey:
		if event.keycode == KEY_SHIFT:
			if event.pressed:
				is_shifted = true
			else:
				is_shifted = false
		if event.keycode == KEY_SPACE and event.pressed:
			is_paused = not is_paused



func _create_or_load_save() -> void:
	if Save_Data.save_exists():
		save = Save_Data.load_save_data() as Save_Data
	else:
		save = Save_Data.new()
		_load_characters()
		save.map_name = "map_1"
		save.global_position = Vector2i(2,2)
		
		save.writesave_data()
	
	_tokens.characters = save.characters
	_portraits.characters = save.characters
	gamemode = save.GAMEMODE

func _load_characters():
	var dir = DirAccess.open(save.CHARACTERS_FOLDER_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var file_to_play_with = load(save.CHARACTERS_FOLDER_PATH + file)
		save.characters.append(file_to_play_with)
		file = dir.get_next()
