#class_name Global
extends Node

const HERITAGE_RESOURCE_PATH = "res://resource/game_data/heritages/"

enum Skills { ACROBATICS, ARCANA, ATHLETICS, CRAFTING, DECEPTION, DIPLOMACY, 
	INTIMIDATION, LORE, MEDICINE, NATURE, OCCULTISM, PERFORMANCE, RELIGION, SOCIETY,
	STEALTH, SURVIVAL, THIEVERY }

enum Saves { FORTITUDE, REFLEX, WILL }
enum Armors { UNARMORED, LIGHT, MEDIUM, HEAVY }
enum Weapons { UNARMED, SIMPLE, MARTIAL, ADVANCED }
enum Classes { CLERIC, FIGHTER, ROGUE, WIZARD }

enum Darksense { NORMAL, LOW_LIGHT_VISION, DARKVISION, GREATER_DARKVISION}

enum Attributes { STRENGTH, DEXTERITY, CONSTITUTION, INTELLIGENCE, WISDOM, CHARISMA }

enum Size { TINY, SMALL, MEDIUM, LARGE, HUGE, GARGANTUAN }
enum Gamemode { EXPLORATION, ENCOUNTER }
enum Prof_Rank { UNTRAINED=0, TRAINED=2, EXPERT=4, MASTER=6, LEGENDARY=8 }

@onready var gamemode : Global.Gamemode

var save: Save_Data
var selected_character: Array[String]
var ancestry_data: Array[Ancestry_Data]
var heritage_data: Array[Heritage_Data]
var is_paused:= false
var is_shifted:= false

func _ready():
	_create_or_load_save()
	
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
		
	gamemode = save.gamemode
	
func _load_characters():
	var dir = DirAccess.open(save.CHARACTERS_FOLDER_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var file_to_play_with = load(save.CHARACTERS_FOLDER_PATH + file)
		save.characters.append(file_to_play_with)
		file = dir.get_next()
