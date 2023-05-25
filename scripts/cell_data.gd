class_name Cell_Data
extends Object

signal cell_changed(_pos: Vector2)
signal nav_changed(_pos: Vector2)

var pos: Vector2

var floor_data: Floor_Data:
	set (value):
		floor_data = value
		emit_signal("cell_changed", pos)
	get:
		return floor_data

var occupier = null :
	set (value):
		occupier = value
		emit_signal("cell_changed", pos)
	get:
		return occupier

var navigable: bool = true :
	set (value):
		navigable = value
		emit_signal("nav_changed", pos)
	get:
		return navigable
		
func _init(_pos: Vector2):
	pos = _pos
