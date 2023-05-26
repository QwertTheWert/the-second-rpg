class_name Token
extends Area2D

@onready var _main = get_tree().root.get_node("Main")
@onready var _grid: Grid = _main.get_node("Grid")
@onready var _pf: Pathfinder = _grid.get_node("Pathfinding")


var character_data: Character_Data: #setget
	get:
		return character_data
	set(value):
		character_data = value
var _token_data: Token_Data = Token_Data.new()
var _movement_used : float = 0.0

var path: Array[Vector2i]
var pos: Vector2i :
	get:
		return pos
	set(value):
		pos = value

func _ready():
	pos = _grid.local_to_map(position)

func _process(delta):
	move(delta)

func move(delta):
	if path.size() > 0:
		if position.distance_to(_grid.map_to_local(path[0])) < 5:
			position = _grid.map_to_local(path[0])
			pos = path[0]
			path.pop_front()
		else:
			position += (_grid.map_to_local(path[0]) - position).normalized() * _token_data.speed * delta

func limit_path(_path: Array[Vector2i]):
	_movement_used = 0
	if _path.size() > 0:
		path.append(_path[0])
		for i in _path.size()-1:
			var p = abs(_path[i] - _path[i+1])
			if p.x + p.y == 1:
				_movement_used += 1
			elif p.x + p.y > 1:
				_movement_used += 1.5
			if floor(_movement_used) <= _token_data.move_speed:
				path.append(_path[i+1])

func _map_input_event(_viewport, event, _shape_idx):
	var _next
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and $Control/Button.button_pressed:
		if event.pressed == true:
			move_to_front()
			$"../Line2D".points = []
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
			limit_path(total_path)



			for point in path:
				point = (Vector2(point) * 32 + Vector2(16,16))
				$"../Line2D".add_point(point,-1)



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
#func unselect(char_id):
#	if char_id != name:
#		$Control/Button.button_pressed = false
#
#func _on_mouse_entered():
#	$Control/NamePlate.show()
#	$Control/HoverOutline.show()
#
#func _on_mouse_exited():
#	$Control/NamePlate.hide()
#	$Control/HoverOutline.hide()
#
##
#func _on_input_event(_viewport, event, _shape_idx):
#	if event is InputEventMouseButton and event.button_index == 1:
#		if event.pressed == true:
#			$Control/Button.button_pressed = not $Control/Button.button_pressed
##			var reselect = token_manager.more_than_one_token_selected()
##			if not game.is_shifted:
##				get_tree().call_group("Token", "unselect", name)
##				unselect(name)
##				if reselect == true:
##					$Control/Button.button_pressed = true
##		else:
##			var tokens = get_tree().get_nodes_in_group("PC Token")
##			var portraits = get_tree().get_nodes_in_group("Portrait")
##			for token in tokens:
##				for portrait in portraits:
##					if portrait.name == token.name:
##						portrait.get_node("Button").button_pressed = token.get_node("Control/Button").button_pressed
##						pass
#
