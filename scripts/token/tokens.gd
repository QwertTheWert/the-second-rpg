extends Node2D

var TOKEN_SCENE_PATH = preload("res://scenes/token.tscn")

@onready var _main = get_tree().root.get_node("Main")
@onready var _grid = _main.get_node("Grid")
var characters: Array[Character_Data]

signal hp_changed


func generate_tokens() -> void:
	for character in characters:
		var token = TOKEN_SCENE_PATH.instantiate()
		token.name = "PC %s" % [character.id]
		token.character_data = character
		token.get_node("Sprite2D").set_texture(load(character.image_path + "/token.png"))
		token.position = character.map_position * _grid.cell_size + Vector2i(_grid.cell_size/2, _grid.cell_size/2)
		
		if character.size >= 2:
			var _size_num = character.size -1  
			token.get_node("Sprite2D").scale = Vector2(0.125, 0.125) * _size_num
			token.get_node("CollisionShape2D").shape.size = Vector2(_grid.cell_size, _grid.cell_size) * _size_num	
		elif character.size == 1:
			token.get_node("Sprite2D").scale = Vector2(0.1, 0.1)
			token.get_node("CollisionShape2D").shape.size = Vector2(_grid.cell_size, _grid.cell_size)
		
		
		_grid.get_node("Area2D").input_event.connect(token._map_input_event)
		add_child(token)

func more_than_one_character_selected() -> bool:
	var _selected = 0
	for token in get_children():
		if token.is_in_group("Character") and token.get_node("Button").button_pressed:
			_selected += 1
	if _selected > 1:
		return true
	else:
		return false
