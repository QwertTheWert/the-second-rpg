class_name Area
extends Area2D

@onready var _main = get_tree().root.get_node("Main")
@onready var _grid: Grid = _main.get_node("Grid")
@onready var _pf: Pathfinder = _grid.get_node("Pathfinding")
@onready var _exploration_move_speed:= 18 * character_data.speed
@onready var _encounter_move_speed:= 250
var _marker: Area2D

@onready var tokens = get_parent()

var MARKER_SCENE_PATH = preload("res://scenes/marker.tscn")

var character_data: Character_Data: #setget
	get:
		return character_data
	set(value):
		character_data = value

var _movement_used: float = 0.0

var path: Array[Vector2i]
var pos: Vector2i :
	get:
		return pos
	set(value):
		pos = value

func _ready():
	pos = _grid.local_to_map(position)
	_create_marker()

func _process(delta):
	_move(delta)

func _move(delta):
	if path.size() > 0:
		if position.distance_to(_grid.map_to_local(path[0])) < 2:
			position = _grid.map_to_local(path[0])
			pos = path[0]
			path.pop_front()
			if path.size() == 0:
				_marker.hide()
		else:
			if _main.gamemode == GLOBALS.Mode.EXPLORATION:
				position += (_grid.map_to_local(path[0]) - position).normalized() * _exploration_move_speed * delta
			else:
				position += (_grid.map_to_local(path[0]) - position).normalized() * _encounter_move_speed * delta

func _limit_path(_path: Array[Vector2i]):
	_movement_used = 0
	if _path.size() > 0 and _main.gamemode == GLOBALS.Mode.ENCOUNTER:
		path.append(_path[0])
		for i in _path.size()-1:
			var p = abs(_path[i] - _path[i+1])
			if p.x + p.y == 1:
				_movement_used += 1
			elif p.x + p.y > 1:
				_movement_used += 1.5
			if floor(_movement_used) <= character_data.speed:
				path.append(_path[i+1])
	else:
		path = _path
	_put_marker(path[-1])
	
func _create_marker() -> void:
	_marker = MARKER_SCENE_PATH.instantiate()
	_marker.name = "%s Marker" % [name]
	_marker.hide()
	add_sibling(_marker)
	get_parent().move_child(_marker, -1)

func _put_marker(_position: Vector2i) -> void:
	_marker.position = _position * _grid.cell_size + Vector2i(_grid.cell_size/2, _grid.cell_size/2)
	_marker.show()

func _map_input_event(_viewport, event, _shape_idx) -> void:
	var _next
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and $Button.button_pressed:
		if event.pressed == true:
			move_to_front()
			
			if path.size() > 0:
				_next  = path.front()
				path.clear()

			var clicked = _grid.local_to_map(get_global_mouse_position())
			var total_path = _pf.generate_path(pos, clicked)

#			if _next != null and total_path.size() > 1:
#				print(Vector2(total_path[1]).normalized())
#				print(Vector2(_next).normalized())
#				print(Vector2(total_path[1]).normalized().dot(Vector2(_next).normalized()))
			if _next != null and total_path.size() > 1 and _next == total_path[1]:
				total_path.pop_front()
			
			_limit_path(total_path)

func unselect(_name):
	if _name != name:
		$Button.button_pressed = false
		$Control/SelectOutline.hide()


#func set_hp(cur_hp, temp_hp = 0, max_hp = $Control/HPBar.max_value):
#	$Control/HPBar.max_value = max_hp
#	$Control/HPBar.value = cur_hp
#
#	$Control/HPBar/TempHPBar.max_value = max_hp
#	$Control/HPBar/TempHPBar.value = temp_hp
#
#
#func _hp_changed(hero, cur_hp, temp_hp = 0):
#	if hero == name:
#		set_hp(cur_hp, temp_hp)
#
#


#func _on_mouse_entered():
#	$Control/NamePlate.show()
#	$Control/HoverOutline.show()
#
#func _on_mouse_exited():
#	$Control/NamePlate.hide()
#	$Control/HoverOutline.hide()
