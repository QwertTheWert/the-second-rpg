class_name Pathfinder
extends Node

var aStar = AStarGrid2D.new()
#@onready var _main = get_tree().root.get_node("Main")
#@onready var _grid: Grid = _main.get_node("Grid")

var move_speed: float = 5.0

func set_astar():
	aStar.set_size(Vector2i(get_parent().width, get_parent().height))
	aStar.set_cell_size(Vector2i(32, 32))
	aStar.set_default_compute_heuristic(AStarGrid2D.HEURISTIC_OCTILE)
	aStar.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES)
	aStar.update()
	
	for x in get_parent().width :
		for y in get_parent().height:
			if get_parent().get_cell_source_id(0, Vector2i(x,y)) == 1:
				aStar.set_point_solid(Vector2i(x,y), true)
	

func generate_path(_point_a: Vector2i, _point_b: Vector2i):
	if _point_b.x < 0 or _point_b.y < 0:
		return []
	return aStar.get_id_path(_point_a, _point_b)
	
