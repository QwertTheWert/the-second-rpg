class_name TokenName
extends Node2D

const TOKEN_SCENE_PATH = preload("res://scenes/token.tscn")

@onready var _main = get_tree().root.get_node("Main")
@onready var _grid = _main.get_node("Grid")
var characters: Array[Character_Data]

signal hp_changed
signal selection_status_changed(_character_data)

func generate_tokens() -> void:
	var marching_order = 1
	for character in characters:
		var token = TOKEN_SCENE_PATH.instantiate()
		token.name = "PC-%s" % [character.id]
		token.character_data = character
		token.get_node("Sprite2D").set_texture(load(character.image_path + "/token.png"))
		token.position = character.map_position * _grid.cell_size + Vector2i(_grid.cell_size/2, _grid.cell_size/2)
		token.marching_order = marching_order
		token.get_node("Control/NamePlate").text = character.name
		if character.size >= 2:
			var _size_num = character.size -1  
			token.get_node("Sprite2D").scale = Vector2(0.125, 0.125) * _size_num
			token.get_node("CollisionShape2D").shape.size = Vector2(_grid.cell_size, _grid.cell_size) * _size_num	
		elif character.size == 1:
			token.get_node("Sprite2D").scale = Vector2(0.1, 0.1)
			token.get_node("CollisionShape2D").shape.size = Vector2(_grid.cell_size, _grid.cell_size)
		_main.get_node("CanvasLayer/DebugUI/Button").hp_signal.connect(token.change_hp)
		token.selection_status_changed.connect(_main.get_node("CanvasLayer/Controls/VBoxContainer/Actions/Strikes").set_data)
		add_child(token)
		
		marching_order += 1

func more_than_one_character_selected() -> bool:
	if Global.selected_character.size() > 1:
		return true
	else:
		return false
