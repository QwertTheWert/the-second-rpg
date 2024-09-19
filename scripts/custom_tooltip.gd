extends Control

func _on_description_finished():
	var old_height = get_parent().size.y
	$Description.custom_minimum_size = Vector2.ZERO
	$Description.size = Vector2.ZERO
	$Description.fit_content = true

	get_parent().size.y = $Name.size.y + $Traits.size.y + $RightClick.size.y
	
	if $".".size.y - ($Name.size.y + $Traits.size.y + $RightClick.size.y) > 279:
		$Description.fit_content = false
		$Description.custom_minimum_size.y = 279
		$Description.size.y = 279
		$Description/TextureRect.show()
		get_parent().size.y = $Name.size.y + $Traits.size.y + $RightClick.size.y

	
	var new_height = get_parent().size.y
	if get_parent().position.y < get_viewport().get_mouse_position().y:
			get_parent().position.y += old_height - new_height + 8
