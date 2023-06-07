class_name Main
extends Node2D

@onready var _grid = $Grid
@onready var _tokens = $Grid/Tokens
@onready var _portraits = $CanvasLayer/Portraits

func _ready():
	_grid.calculate_bounds()
	_grid.generate_grid()
	_grid.generate_area()
	_tokens.characters = Global.save.characters
	_tokens.generate_tokens()
	_portraits.characters = Global.save.characters
	_portraits.generate_portraits()
