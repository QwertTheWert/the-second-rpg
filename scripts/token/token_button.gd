class_name Token_Button
extends TextureButton

@onready var _main = get_tree().root.get_node("Main") 
@onready var _token = get_parent()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed == true:
			button_pressed = !button_pressed
			_on_pressed()
#			var reselect = token_manager.more_than_one_token_selected()
#				get_tree().call_group("Token", "unselect", name)
#				unselect(name)
#				if reselect == true:
#					$Control/Button.button_pressed = true
#		else:
#			var tokens = get_tree().get_nodes_in_group("PC Token")
#			var portraits = get_tree().get_nodes_in_group("Portrait")
#			for token in tokens:
#				for portrait in portraits:
#					if portrait.name == token.name:
#						portrait.get_node("Button").button_pressed = token.get_node("Control/Button").button_pressed
#						pass


func _on_pressed():
	if  _main.gamemode == GLOBALS.Mode.EXPLORATION:
		if (not _main.is_shifted):
			var reselect = _token.tokens.more_than_one_character_selected()	
			get_tree().call_group("Character", "unselect", _token.name)
			if reselect:
				button_pressed = true
	else:
		get_tree().call_group("Character", "unselect", _token.name)
	
	if button_pressed:
		$"../Control/SelectOutline".show()
	else:
		$"../Control/SelectOutline".hide()
