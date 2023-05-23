extends Node2D

var mouse_is_over_token = false

var game
var token_manager

var char_name
var allegiance
 
func _ready():
	$Control/NamePlate.set_text(char_name)
	game = get_tree().get_nodes_in_group("Game")[0]
	token_manager = get_tree().get_nodes_in_group("Token Manager")[0]
	if allegiance == "Party":
		add_to_group("PC Token")

func set_hp(cur_hp, temp_hp = 0, max_hp = $Control/HPBar.max_value):
	$Control/HPBar.max_value = max_hp
	$Control/HPBar.value = cur_hp
	
	$Control/HPBar/TempHPBar.max_value = max_hp
	$Control/HPBar/TempHPBar.value = temp_hp

	
func _hp_changed(hero, cur_hp, temp_hp = 0):
	if hero == name:
		set_hp(cur_hp, temp_hp)
		

func unselect(char_id):
	if char_id != name:
		$Control/Button.button_pressed = false


func _on_button_down():
	var reselect = token_manager.more_than_one_token_selected()
	if not game.is_shifted:
		get_tree().call_group("Token", "unselect", name)
		unselect(name)
		if reselect == true:
			$Control/Button.button_pressed = false

func _on_button_up():
	var tokens = get_tree().get_nodes_in_group("PC Token")	
	var portraits = get_tree().get_nodes_in_group("Portrait")
	for token in tokens:
		for portrait in portraits:
			if portrait.name == token.name:
				portrait.get_node("Button").button_pressed = token.get_node("Control/Button").button_pressed
				pass

func _mouse_entered():
	$Control/NamePlate.show()

func _on_mouse_exited():
	$Control/NamePlate.hide()
