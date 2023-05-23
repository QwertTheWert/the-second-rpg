extends Control

@export var interface_scale = 0.8

func _ready():
	set_scale(Vector2(interface_scale,interface_scale))

func _can_drop_data(_at_position, _data):
	return true
	

func _drop_data(_pos, data):
	if data["origin_slot"] != null:
		data["origin_slot"].get_child(0).set_modulate("#ffffffff")
