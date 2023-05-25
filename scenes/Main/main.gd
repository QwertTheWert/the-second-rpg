extends Node2D

@onready var grid = $Grid

var is_shifted = false
var is_encounter_mode = true
var selected_players = []
var heroes = {
	"PC01": {
		"char_name" : "Wizard",
		"max_hp" : 16, 
		"cur_hp" : 8, 
		"temp_hp" : 0,
		"portrait_path" : "res://assets/player-characters-portraits/wizard.png",
		"token_path" : "res://assets/player-characters-tokens/wizard.png"
	},
	"PC02": {
		"char_name" : "Paladin",
		"max_hp" : 200, 
		"cur_hp" : 150, 
		"temp_hp" : 50,
		"portrait_path" : "res://assets/player-characters-portraits/paladin.png",
		"token_path" : "res://assets/player-characters-tokens/paladin.png"
	},
	"PC03": {
		"char_name" : "Rogue",
		"max_hp" : 18, 
		"cur_hp" : 13, 
		"temp_hp" : 0,
		"portrait_path" : "res://assets/player-characters-portraits/rogue.png",
		"token_path" : "res://assets/player-characters-tokens/rogue.png"
	},
	"PC04": {
		"char_name" : "Bard",
		"max_hp" : 19, 
		"cur_hp" : 2, 
		"temp_hp" : 0,
		"portrait_path" : "res://assets/player-characters-portraits/bard.png",
		"token_path" : "res://assets/player-characters-tokens/bard.png"
	},
	"PC05": {
		"char_name" : "Cleric",
		"max_hp" : 14, 
		"cur_hp" : 0, 
		"temp_hp" : 0,
		"portrait_path" : "res://assets/player-characters-portraits/cleric.png",
		"token_path" : "res://assets/player-characters-tokens/cleric.png"
	},
	"PC06": {
		"char_name" : "Sorcerer",
		"max_hp" : 14, 
		"cur_hp" : 14, 
		"temp_hp" : 1,
		"portrait_path" : "res://assets/player-characters-portraits/sorcerer.png",
		"token_path" : "res://assets/player-characters-tokens/sorcerer.png"
	}
}

func _ready():
	grid.generate_grid()
	$Grid/Pathfinding.initialize()
	
func _input(event):
	if event is InputEventKey and event.keycode == KEY_SHIFT:
		if event.pressed:
			is_shifted = true
		else:
			is_shifted = false
