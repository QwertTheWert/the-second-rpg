extends HBoxContainer

signal hp_changed(char_id, value)

var PORTRAIT_SCENE_PATH = preload("res://scenes/portrait.tscn")
var PORTRAIT_SLOT_SCENE_PATH = preload("res://scenes/portrait_slot.tscn")

func _ready():
	var game = get_tree().get_nodes_in_group("Game")[0]
	var portrait_slot_index = 0
	for hero_id in game.heroes:
		get_child(portrait_slot_index).add_child(create_portrait(hero_id))
		portrait_slot_index += 1
	for slot in get_children():
		if slot.get_child_count() == 0:
			slot.hide()

func create_portrait(hero_id, game = get_tree().get_nodes_in_group("Game")[0]):
	var portrait = PORTRAIT_SCENE_PATH.instantiate()
	var char_data = game.heroes[hero_id]
	portrait.set_name(hero_id)
	portrait.char_name = char_data["char_name"]
	portrait.set_texture(load(char_data["portrait_path"]))
	portrait.set_hp(char_data["cur_hp"], char_data["temp_hp"], char_data["max_hp"])
	hp_changed.connect(portrait._hp_changed)
#	portrait.set_anchors_preset()
	return portrait

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
	print("press")
	if hide_button.button_pressed:
		get_parent().hide()
	else:
		get_parent().show()
