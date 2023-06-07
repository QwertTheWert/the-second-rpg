class_name Token_Button
extends TextureButton

@onready var _main = get_tree().root.get_node("Main") 
@onready var _grid = _main.get_node("Grid")
@onready var _token = get_parent()

func _on_gui_input(event):
	if event is InputEventMouseButton and event.button_index == 1:
		if event.pressed:
			button_pressed = !button_pressed
			_on_pressed()
	if event is InputEventMouseMotion:
		_grid.clear_layer(1)


func _on_pressed():
	if  Global.gamemode == Global.Gamemode.EXPLORATION:
		if (not Global.is_shifted):
			var reselect = _token.tokens.more_than_one_character_selected()
			get_tree().call_group("Character", "unselect", _token.name)
			if reselect:
				button_pressed = true
			Global.selected_character.erase(_token.name)
	else:
		get_tree().call_group("Character", "unselect", _token.name)
	
	var _all_pc_tokens = get_tree().get_nodes_in_group("Character")
	var _all_portraits = get_tree().get_nodes_in_group("Portrait")
	for _pc_token in _all_pc_tokens:
		for _portrait in _all_portraits:
			if _pc_token.name == _portrait.name:
				_portrait.get_node("Button").button_pressed = _pc_token.get_node("Button").button_pressed

func _on_mouse_entered():
	$"../Control/HoverOutline".show()
	$"../Control/NamePlate".show()

func _on_mouse_exited():
	$"../Control/HoverOutline".hide()
	if not button_pressed:
		$"../Control/NamePlate".hide()

func _on_toggled(_button_pressed):
	if button_pressed:
		$"../Control/SelectOutline".show()
		$"../Control/NamePlate".show()
		_token.marker.get_node("SelectedSprite").show()
		_token.marker.get_node("UnselectedSprite").hide()
		if not Global.selected_character.has(_token.name):
			Global.selected_character.append(_token.name)
		if Global.selected_character.size() == 1 or Global.selected_character.size() > 1 and Global.is_shifted:
			_token.selection_status_changed.emit()
	else:
		$"../Control/SelectOutline".hide()
		$"../Control/NamePlate".hide()
		_token.marker.get_node("SelectedSprite").hide()
		_token.marker.get_node("UnselectedSprite").show()
		Global.selected_character.erase(_token.name)
		_token.selection_status_changed.emit()
		
