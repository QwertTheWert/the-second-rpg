class_name Grid
extends TileMap

@onready var _main = get_tree().root.get_node("Main")
@onready var _pf = $Pathfinding

var width:= 0
var height:= 0
@export var cell_size: int = 32

@export var show_debug: bool = false

var grid: Dictionary = {}

func calculate_bounds() -> void:
	var _used_cells = get_used_cells(0)
	for _pos in _used_cells:
		if _pos.x > width:
			width = int(_pos.x)
		if _pos.y > height:
			height = int(_pos.y)
			
	width += 1
	height += 1

func generate_grid():
	for x in width:
		for y in height:
			grid[Vector2i(x,y)] = Cell_Data.new(Vector2i(x,y))
			grid[Vector2i(x,y)].floor_data = preload("res://data/ground.tres")
#			refresh_tile(Vector2i(x,y))
			
			#Debug Grid
			if show_debug:
				_show_debug(x, y)
	$Pathfinding.set_astar()

func generate_area():
	$Area2D.position = Vector2(float(width*cell_size)/2, float(height*cell_size)/2)
	$Area2D/CollisionShape2D.shape.size = Vector2(width*cell_size, height*cell_size)
	

func _map_input_event(_viewport, event, _shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == true:
			var _mouse_pos = local_to_map(get_global_mouse_position())
			if _main.selected_character.size() == 1:
				$Tokens.get_node(_main.selected_character[0])._pathfind_to_position(_mouse_pos)
			elif _main.selected_character.size() > 1:
				group_march(_mouse_pos)
				
				
	if event is InputEventMouseMotion and _main.gamemode == GLOBALS.Mode.ENCOUNTER:
		if _main.selected_character.size() == 1:
			if $Tokens.get_node(_main.selected_character[0]).path.size() < 1:
				$Tokens.get_node(_main.selected_character[0])._draw_ruler()

func group_march(_mouse_pos: Vector2i):
	_main.selected_character.sort_custom(sort_march_order)
	if _main.selected_character.size() == 2:
		var _token_1 = $Tokens.get_node(_main.selected_character[0])
		var _token_2 = $Tokens.get_node(_main.selected_character[1])
		var _check_right = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,0)).size())
		var _check_left = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,0)).size())
		var _check_down = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,1)).size())
		if not _check_right:
			if not _check_left:
				if not _check_down:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
					_token_2._pathfind_to_position(_mouse_pos)
					return
				_token_1._pathfind_to_position(_mouse_pos)
				_token_2._pathfind_to_position(_mouse_pos + Vector2i(0,1))
				return
			_token_1._pathfind_to_position(_mouse_pos+ Vector2i(-1,0))
			_token_2._pathfind_to_position(_mouse_pos)
			return
		_token_1._pathfind_to_position(_mouse_pos)
		_token_2._pathfind_to_position(_mouse_pos + Vector2i(1,0))
		return

	if _main.selected_character.size() == 3:
		var _token_1 = $Tokens.get_node(_main.selected_character[0])
		var _token_2 = $Tokens.get_node(_main.selected_character[1])
		var _token_3 = $Tokens.get_node(_main.selected_character[2])
		var _check_right = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,0)).size())
		var _check_left = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,0)).size())
		var _check_down = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,0)).size())
		
		if not _check_right:
			if not _check_left:
				var _check_down_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,1)).size())
				var _check_down_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,2)).size())
				var _check_up_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,-1)).size())
				var _check_up_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,-2)).size())
				if _check_down_1 and _check_down_2:
					_token_1._pathfind_to_position(_mouse_pos)
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(0,1))
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(0,2))
					return
				elif _check_down_1 and _check_up_1:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
					_token_2._pathfind_to_position(_mouse_pos)
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(0,1))
					return
				elif _check_up_1 and _check_up_2:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-2))
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
					_token_3._pathfind_to_position(_mouse_pos)
					return
			if _check_down:
				_token_1._pathfind_to_position(_mouse_pos)
				_token_2._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
				_token_3._pathfind_to_position(_mouse_pos + Vector2i(-2,0))
				return
		if not _check_down:
			var _check_left_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,0)).size())
			var _check_left_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-2,0)).size())
			var _check_right_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,0)).size())
			var _check_right_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(2,0)).size())
			if _check_right_1 and _check_right_2:
				_token_1._pathfind_to_position(_mouse_pos)
				_token_2._pathfind_to_position(_mouse_pos + Vector2i(1,0))
				_token_3._pathfind_to_position(_mouse_pos + Vector2i(2,0))
				return
			elif _check_right_1 and _check_left_1:
				_token_1._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
				_token_2._pathfind_to_position(_mouse_pos)
				_token_3._pathfind_to_position(_mouse_pos + Vector2i(1,0))
				return
			elif _check_left_1 and _check_left_2:
				_token_1._pathfind_to_position(_mouse_pos + Vector2i(-2,0))
				_token_2._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
				_token_3._pathfind_to_position(_mouse_pos)
				return
		_token_1._pathfind_to_position(_mouse_pos)
		_token_2._pathfind_to_position(_mouse_pos + Vector2i(1,0))
		_token_3._pathfind_to_position(_mouse_pos + Vector2i(0,1))
		return

	if _main.selected_character.size() == 4:
		var _token_1 = $Tokens.get_node(_main.selected_character[0])
		var _token_2 = $Tokens.get_node(_main.selected_character[1])
		var _token_3 = $Tokens.get_node(_main.selected_character[2])
		var _token_4 = $Tokens.get_node(_main.selected_character[3])
		var _check_right = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,0)).size())
		var _check_left = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,0)).size())
		var _check_down = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,1)).size())
		var _check_up = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,-1)).size())
		var _check_up_right = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,-1)).size())
		var _check_down_right = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,1)).size())
		var _check_down_left = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,1)).size())
		
		if (not _check_right or not _check_down_right) and (not _check_left or not _check_down_left):
			var _check_down_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,1)).size())
			var _check_down_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,2)).size())
			var _check_down_3 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,3)).size())
			var _check_up_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,-1)).size())
			var _check_up_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,-2)).size())
			var _check_up_3 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(0,-3)).size())
			var _height = int(_check_down_1) + int(_check_down_2) + int(_check_down_3) + int(_check_up_1) + int(_check_up_2) + int(_check_up_3)
			if _height >= 4:
				if _check_down_1 and _check_down_2 and _check_down_3:
					_token_1._pathfind_to_position(_mouse_pos)
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(0,1))
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(0,2))
					_token_4._pathfind_to_position(_mouse_pos + Vector2i(0,3))
					return
				elif _check_down_1 and _check_down_2 and _check_up_1:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
					_token_2._pathfind_to_position(_mouse_pos)
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(0,1))
					_token_4._pathfind_to_position(_mouse_pos + Vector2i(0,2))
					return
				elif _check_down_1 and _check_up_1 and _check_up_2:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-2))
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
					_token_3._pathfind_to_position(_mouse_pos)
					_token_4._pathfind_to_position(_mouse_pos + Vector2i(0,1))
					return
				elif _check_up_1 and _check_up_2 and _check_up_3:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-3))
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(0,-2))
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
					_token_4._pathfind_to_position(_mouse_pos)
					return
		if (not _check_up or not _check_up_right) and (not _check_down_right or not _check_down):
			var _check_right_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(1,0)).size())
			var _check_right_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(2,0)).size())
			var _check_right_3 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(3,0)).size())
			var _check_left_1 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-1,0)).size())
			var _check_left_2 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-2,0)).size())
			var _check_left_3 = bool(_pf.generate_path(_token_1.pos, _mouse_pos + Vector2i(-3,0)).size())
			var _width = int(_check_right_1) + int(_check_right_2) + int(_check_right_3) + int(_check_left_1) + int(_check_left_2) + int(_check_left_3)
			if _width >= 4:
				if _check_right_1 and _check_right_2 and _check_right_3:
					_token_1._pathfind_to_position(_mouse_pos)
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(1,0))
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(2,0))
					_token_4._pathfind_to_position(_mouse_pos + Vector2i(3,0))
					return
				elif _check_right_1 and _check_right_2 and _check_left_1:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
					_token_2._pathfind_to_position(_mouse_pos)
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(1,0))
					_token_4._pathfind_to_position(_mouse_pos + Vector2i(2,0))
					return
				elif _check_right_1 and _check_left_1 and _check_left_2:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(-2,0))
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
					_token_3._pathfind_to_position(_mouse_pos)
					_token_4._pathfind_to_position(_mouse_pos + Vector2i(1,0))
					return
				elif _check_left_1 and _check_left_2 and _check_left_3:
					_token_1._pathfind_to_position(_mouse_pos + Vector2i(-3,0))
					_token_2._pathfind_to_position(_mouse_pos + Vector2i(-2,0))
					_token_3._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
					_token_4._pathfind_to_position(_mouse_pos)
					return
		if (not _check_right) and _check_left and (not _check_down_right) and _check_down_left:
			_token_1._pathfind_to_position(_mouse_pos + Vector2i(-1,0))
			_token_2._pathfind_to_position(_mouse_pos)
			_token_3._pathfind_to_position(_mouse_pos + Vector2i(-1,1))
			_token_4._pathfind_to_position(_mouse_pos + Vector2i(0,1))
			return
		if (not _check_down) and _check_up and (not _check_down_right) and _check_up_right:
			_token_1._pathfind_to_position(_mouse_pos + Vector2i(0,-1))
			_token_2._pathfind_to_position(_mouse_pos + Vector2i(1,-1))
			_token_3._pathfind_to_position(_mouse_pos)
			_token_4._pathfind_to_position(_mouse_pos + Vector2i(1,0))
			return
		_token_1._pathfind_to_position(_mouse_pos)
		_token_2._pathfind_to_position(_mouse_pos + Vector2i(1,0))
		_token_3._pathfind_to_position(_mouse_pos +  Vector2i(0, 1))
		_token_4._pathfind_to_position(_mouse_pos + Vector2i(1,1))
		return
		
func sort_march_order(a, b) -> bool:
	if $Tokens.get_node(a).marching_order < $Tokens.get_node(b).marching_order:
		return true
	return false

#func refresh_tile(_pos: Vector2i) -> void:
#	var data = grid[_pos]
#	set_cell(0, _pos, data.floor_data.id, data.floor_data.coords)
#	set_cell(1, _pos)

func _show_debug(x: int, y: int):
	var rect = ReferenceRect.new()
	rect.position = map_to_local(Vector2i(x,y))
	rect.size = Vector2i(cell_size, cell_size)
	rect.editor_only = false
	$Debug.add_child(rect)
	var label = Label.new()
	label.position = map_to_local(Vector2i(x,y))
	label.text = str(Vector2i(x,y))
	$Debug.add_child(label)



