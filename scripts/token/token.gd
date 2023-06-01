class_name Token
extends Area2D

signal selection_status_changed

@onready var _main = get_tree().root.get_node("Main")
@onready var _grid: Grid = _main.get_node("Grid")
@onready var _pf: Pathfinder = _grid.get_node("Pathfinding")
@onready var _EXPLORATION_MOVE_SPEED:= 18 * character_data.speed
@onready var _ENCOUNTER_MOVE_SPEED:= 432
var marker: Area2D
var _new_course:= false
var marching_order: int

@onready var tokens = get_parent()

var MARKER_SCENE_PATH = preload("res://scenes/marker.tscn")


var character_data: Character_Data: #setget
	get:
		return character_data
	set(value):
		character_data = value

var _movement_used: float = 0.0

var path: Array[Vector2i]
var ruler_path: Array[Vector2i]

var pos: Vector2i :
	get:
		return pos
	set(value):
		pos = value

func _ready():
	pos = _grid.local_to_map(position)
	$Control/HealthBar.max_value = character_data.hp_max
	$Control/HealthBar.value = character_data.hp_cur
	_create_marker()

func _process(delta):
	if not _main.is_paused: _move(delta)

func _move(delta):
	if path.size() > 0:
		if position.distance_to(_grid.map_to_local(path[0])) < 4:
			position = _grid.map_to_local(path[0])
			pos = path[0]
			path.pop_front()
			if path.size() == 0:
				marker.hide()
		else:
			if _main.gamemode == GLOBALS.Mode.EXPLORATION:
				position += (_grid.map_to_local(path[0]) - position).normalized() * _EXPLORATION_MOVE_SPEED * delta
			else:
				position += (_grid.map_to_local(path[0]) - position).normalized() * _ENCOUNTER_MOVE_SPEED * delta

func _limit_path(_path: Array[Vector2i]):
	_movement_used = 0
	if _path.size() > 0 and _main.gamemode == GLOBALS.Mode.ENCOUNTER:
		path.append(_path[0])
		for i in _path.size()-1:
			var d = abs(_path[i] - _path[i+1])
			if d.x + d.y == 1:
				_movement_used += 1
			elif d.x + d.y > 1:
				_movement_used += 1.5
			if floor(_movement_used) <= character_data.speed * 3:
				path.append(_path[i+1])
	else:
		path = _path
	if path.size() > 0:
		_put_marker(path[-1])
	
func _create_marker() -> void:
	marker = MARKER_SCENE_PATH.instantiate()
	marker.name = "%s Marker" % [name]
	marker.hide()
	add_sibling(marker)
	get_parent().move_child(marker, -1)

func _put_marker(_position: Vector2i) -> void:
	var half_size = int(_grid.cell_size/2)
	marker.position = _position * _grid.cell_size + Vector2i(half_size, half_size)
	marker.show()

func _pathfind_to_position(_position: Vector2) -> void:
	var _total_path = _pf.generate_path(pos, _position)
	
	if _total_path.size() > 0:
		_grid.clear_layer(1)
		move_to_front()
		
		if path.size() > 0:
			path.clear()
			_new_course = true

		if _total_path.size() > 1 and _new_course:
			if _total_path.size() > 2:
				_total_path.pop_front()
			_total_path.pop_front()
			_new_course = false
		
		_limit_path(_total_path)

func _draw_ruler() -> void:
	_grid.clear_layer(1)
	if ruler_path.size() > 1:
		ruler_path.clear()
	ruler_path.append(pos)
	var _mouse_pos = _grid.local_to_map(get_global_mouse_position())
	ruler_path.append_array(_pf.generate_path(pos, _mouse_pos))
	
	if ruler_path.size() > 2:
		_highlight_ruler()

func _highlight_ruler()-> void:
	var _ruler_length = 0
	for i in ruler_path.size()-2:
		if floor(_ruler_length) <= character_data.speed * 3 and (i != ruler_path.size()-1):
			var _cur_index = i+2
			var d = abs(ruler_path[_cur_index-1] - ruler_path[_cur_index])
			if d.x + d.y == 1:
				_ruler_length += 1
			elif d.x + d.y > 1:
				_ruler_length += 1.5
			
			if floor(_ruler_length) <= character_data.speed:
				_grid.set_cell(1, ruler_path[_cur_index], 2, Vector2i(0, 0))
			elif floor(_ruler_length) <= character_data.speed * 2:
				_grid.set_cell(1, ruler_path[_cur_index], 2, Vector2i(1, 0))
			elif floor(_ruler_length) <= character_data.speed * 3:
				_grid.set_cell(1, ruler_path[_cur_index], 2, Vector2i(2, 0))

func unselect(_name)-> void:
	if _name != name:
		$Button.button_pressed = false
		$Control/SelectOutline.hide()
		$Control/NamePlate.hide()
		marker.get_node("SelectedSprite").hide()
		marker.get_node("UnselectedSprite").show()
		_main.selected_character.erase(name)
#		selection_status_changed.emit(false, character_data)

func _update_hp_bar():
	$Control/HealthBar.max_value = character_data.hp_max
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($Control/HealthBar, "value", character_data.hp_cur, 0.1)

func change_hp(_value: int):
	if _main.selected_character.has(name):
		character_data.hp_cur = clamp(character_data.hp_cur - _value, 0, character_data.hp_max)
		_update_hp_bar()
