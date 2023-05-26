class_name Pathfinder
extends Node

var aStar = AStarGrid2D.new()
#@onready var _main = get_tree().root.get_node("Main")
#@onready var _grid: Grid = _main.get_node("Grid")

var move_speed: float = 5.0

const DIAGONALS = [Vector2.UP+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.LEFT]
const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.LEFT]

func _ready():
	aStar.set_size(Vector2i(32, 32))
	aStar.set_cell_size(Vector2(12, 12))
	aStar.set_default_compute_heuristic(AStarGrid2D.HEURISTIC_OCTILE)
	aStar.update()

func generate_path(_point_a: Vector2i, _point_b: Vector2i):
#	if _point_b.x <= 0 or _point_b.y <= 0:
#		print(_point_b)
	return aStar.get_id_path(_point_a, _point_b)
