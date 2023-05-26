extends Node2D

var TOKEN_SCENE_PATH = preload("res://scenes/token.tscn")

@onready var _main = get_tree().root.get_node("Main")
@onready var _grid = _main.get_node("Grid")

var characters: Array[Character_Data]

signal hp_changed


func generate_tokens() -> void:
	for character in characters:
		var token = TOKEN_SCENE_PATH.instantiate()
		token.character_data = character
		token.get_node("Sprite2D").set_texture(load(character.image_path + "/token.png"))
		token.position = character.map_position * _grid.cell_size + Vector2i(_grid.cell_size/2, _grid.cell_size/2)
		
		_grid.get_node("Area2D").input_event.connect(token._map_input_event)
#		hp_changed.connect(token._hp_changed)
		add_child(token)
#func more_than_one_token_selected() -> bool:
#	var selected = 0
#	for token in get_children():
#		if token.get_node("Control/Button").button_pressed:
#			selected += 1
#	if selected > 1:
#		return true
#	else:
#		return false
