class_name Portraits
extends HBoxContainer

const PORTRAIT_SCENE_PATH = preload("res://scenes/portrait.tscn")

@onready var _main = get_tree().root.get_node("Main")
var characters: Array[Character_Data]



func generate_portraits() -> void:
	for character in characters:
		var portrait = PORTRAIT_SCENE_PATH.instantiate()
		var portrait_image = load(character.image_path + "/portrait.png")
		portrait.character_data = character
		portrait.name = "PC-%s" % [character.id]
		portrait.get_node("Image").set_texture(portrait_image)
		_main.get_node("CanvasLayer/DebugUI/Button").hp_signal.connect(portrait.change_hp)
				
		add_child(portrait)
		
		

func more_than_one_character_selected() -> bool:
	if _main.selected_character.size() > 1:
		return true
	else:
		return false


func more_than_one_portrait_selected():
	var selected = 0
	for portrait_slot in get_children():
		if portrait_slot.get_child_count() != 0:
			if portrait_slot.get_child(0).get_node("Button").button_pressed:
				selected += 1
	if selected > 1:
		return true
	else:
		return false

func _hide_portrait():
	var hide_button = $"../../PortraitHideButton"
	if hide_button.button_pressed:
		get_parent().hide()
	else:
		get_parent().show()
