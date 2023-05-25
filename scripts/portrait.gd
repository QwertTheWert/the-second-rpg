extends TextureRect

var char_name
var game
var portrait_container

func _ready():
	game = get_tree().get_nodes_in_group("Game")[0]
	portrait_container = get_tree().get_nodes_in_group("UI Containers")[0]
	$HPBar.texture_progress = texture

func set_hp(cur_hp, temp_hp = 0, max_hp = $Image/HPBar.max_value):
	if temp_hp > 0:
		$HPLabel.set_text("%s+/%s" % [cur_hp + temp_hp, max_hp])
	else:	
		$HPLabel.set_text("%s/%s" % [cur_hp, max_hp])
	$HPBar.max_value = max_hp
	$HPBar.value = cur_hp

	
func _hp_changed(hero, cur_hp, temp_hp = 0, max_hp = $Image/HPBar.max_value):
	if hero == name:
		set_hp(cur_hp, temp_hp, max_hp)
		
func unselect(char_id):
	if char_id != name:
		$Button.button_pressed = false

func _on_button_down():
	var reselect = portrait_container.more_than_one_portrait_selected()
	if not game.is_shifted:
		get_tree().call_group("Portrait", "unselect", name)
		unselect(name)
		if reselect == true:
			$Button.button_pressed = false
			
func _on_button_up():
	var portraits = get_tree().get_nodes_in_group("Portrait")
	var tokens = get_tree().get_nodes_in_group("PC Token")
	for portrait in portraits:
		for token in tokens:
			if token.name == portrait.name:
				token.get_node("Control/Button").button_pressed = portrait.get_node("Button").button_pressed
				pass
	
