extends Node2D

var TOKEN_SCENE_PATH = preload("res://archive/token.tscn")
var GRID_SIZE = 128

@onready var game = get_tree().root.get_node("Main")
@onready var heroes = game.heroes

signal hp_changed

func _ready():
	var token_position = 0
	for hero_id in game.heroes:
		var token = create_token(hero_id)
		token.set_position(Vector2(GRID_SIZE*token_position,GRID_SIZE*1))
		add_child(token)
		token_position += 1

func create_token(token_id: String):
	var token = TOKEN_SCENE_PATH.instantiate()
	var char_data = game.heroes[token_id]
	token.set_name(token_id)
	token.char_name = char_data["char_name"]
	token.allegiance = "Party"
	token.get_node("Image").set_texture(load(char_data["token_path"]))
	token.set_hp(char_data["cur_hp"], char_data["temp_hp"], char_data["max_hp"])
	hp_changed.connect(token._hp_changed)
	return token

func more_than_one_token_selected() -> bool:
	var selected = 0
	for token in get_children():
		if token.get_node("Control/Button").button_pressed:
			selected += 1
	if selected > 1:
		return true
	else:
		return false
