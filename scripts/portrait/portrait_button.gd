class_name Texture_Button
extends TextureButton

@onready var _portrait = get_parent()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed == false:
			button_pressed = !button_pressed
			_on_pressed()
func _on_pressed():
	if  Global.gamemode == Global.Gamemode.EXPLORATION:
		if (not Global.is_shifted):
			var reselect = _portrait.portraits.more_than_one_character_selected()
			get_tree().call_group("Portrait", "unselect", _portrait.name)
			if reselect:
				button_pressed = true
			Global.selected_character.erase(_portrait.name)
	else:
		get_tree().call_group("Portrait", "unselect", _portrait.name)
	
	var _all_portraits = get_tree().get_nodes_in_group("Portrait")
	var _all_pc_tokens = get_tree().get_nodes_in_group("Character")
	for _cur_portrait in _all_portraits:
		for _pc_token in _all_pc_tokens:
			if _pc_token.name == _cur_portrait.name:
				_pc_token.get_node("Button").button_pressed = _cur_portrait.get_node("Button").button_pressed
func _on_mouse_entered():
	$"../Control/HoverOutline".show()

func _on_mouse_exited():
	$"../Control/HoverOutline".hide()


func _on_toggled(_button_pressed):
	if button_pressed:
		$"../Control/SelectOutline".show()
		if not Global.selected_character.has(_portrait.name):
			Global.selected_character.append(_portrait.name)
	else:
		$"../Control/SelectOutline".hide()
		Global.selected_character.erase(_portrait.name)
		
