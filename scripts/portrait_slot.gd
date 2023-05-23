extends TextureRect

func _get_drag_data(_pos):
	if get_child_count() > 0:
		var data = {}
		data["origin_slot"] = self
		data["origin_panel"] = "PortraitContainer"
		data["origin_id"] = get_child(0).name
		
		
		var drag_texture = get_child(0).duplicate()
		
		var control = Control.new()
		control.add_child(drag_texture)
		drag_texture.set_position(-0.5 * drag_texture.size)
		set_drag_preview(control)
		
		get_child(0).set_modulate("#ffffff20")
		return data
	
func _can_drop_data(_at_position, data):
	var target_panel = get_parent().name
	if target_panel == data["origin_panel"]:
		data["target_slot"] = self
		if get_child_count() == 0:
			data["target_id"] = null
		else:
			data["target_id"] = get_child(0).name
		return true
	else:
		data["origin_slot"].get_child(0).set_modulate("#ffffffff")
		return false

func _drop_data(_pos, data):
	data["origin_slot"].get_child(0).set_modulate("#ffffffff")
	if data["target_slot"] != data["origin_slot"]:
		if data["target_id"] != null:
			data["target_slot"].get_child(0).free()
			data["target_slot"].add_child(get_parent().create_portrait(data["origin_id"]))
			data["origin_slot"].get_child(0).free()
			data["origin_slot"].add_child(get_parent().create_portrait(data["target_id"]))
		else:
			data["target_slot"].add_child(get_parent().create_portrait(data["origin_id"]))
			data["origin_slot"].get_child(0).free()

#func _gui_input(event):
#	if Input.is_action_just_released("left_click"):
#		print("hehe")

func _process(delta):
	print(is_drag_successful())
