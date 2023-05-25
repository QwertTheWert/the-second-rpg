class_name Pathfinder
extends Node

var aStar = AStarGrid2D.new()
@onready var main = get_tree().root.get_node("Main")
@onready var grid: Grid = main.get_node("Grid")

var move_speed: float = 5.0

const DIAGONALS = [Vector2.UP+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.LEFT]
const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.LEFT]

func _ready():
	aStar.set_size(Vector2i(128, 128))
	aStar.set_cell_size(Vector2(12, 12))
	aStar.set_default_compute_heuristic(AStarGrid2D.HEURISTIC_OCTILE)
	aStar.update()





#func get_ID_world_pos(_id: int) -> Vector2:
#	return aStar.get_point_position(_id)
#
#func get_ID_grid_pos(_id: int) -> Vector2:
#	var world_pos = aStar.get_point_position(_id)
#	return grid.world_to_grid(world_pos)
#
#func connect_point(_point: Vector2):
#	var _point_ID = get_point_ID(_point)
#	for direction in DIRECTIONS:
#		var neighbor = _point + direction
#		var neighbor_ID = get_point_ID(neighbor)
#		if grid.grid.has(neighbor) and grid.grid[neighbor] == null: #change later to see if navigable
#			aStar.connect_points(_point_ID, neighbor_ID)
#
#func disconnect_point(_point: Vector2):
#	var _point_ID = get_point_ID(_point)
#	for direction in DIRECTIONS:
#		var neighbor = _point + direction
#		var neighbor_ID = get_point_ID(neighbor)
#		aStar.disconnect_points(_point_ID, neighbor_ID)
#
#func connect_all_points():
#	for point in grid.grid:
#		connect_point(point)
#
func generate_path(_point_a: Vector2i, _point_b: Vector2i):
	return aStar.get_id_path(_point_a, _point_b)
