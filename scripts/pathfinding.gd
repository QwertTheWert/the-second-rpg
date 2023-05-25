class_name Pathfinder
extends Node

var aStar = AStar2D.new()
@onready var main = get_tree().root.get_node("Main")
@onready var grid: Grid = main.get_node("Grid")

var move_speed: float = 5.0

const DIAGONALS = [Vector2.UP+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.LEFT]
const DIRECTIONS = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT, Vector2.UP+Vector2.RIGHT, Vector2.DOWN+Vector2.RIGHT, Vector2.UP+Vector2.LEFT, Vector2.DOWN+Vector2.LEFT]

# Called when the node enters the scene tree for the first time.
func initialize():
	add_points()
	connect_all_points()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func add_points():
	var cur_ID = 0
	for point in grid.grid:
		aStar.add_point(cur_ID, grid.grid_to_world(point))
		cur_ID += 1

func get_point_ID(grid_point: Vector2) -> int:
	return aStar.get_closest_point(grid.grid_to_world(grid_point))
	
func get_world_ID(world_point: Vector2) -> int:
	return aStar.get_closest_point(world_point)
	
func get_ID_world_pos(_id: int) -> Vector2:
	return aStar.get_point_position(_id)
	
func get_ID_grid_pos(_id: int) -> Vector2:
	var world_pos = aStar.get_point_position(_id)
	return grid.world_to_grid(world_pos)

func connect_point(_point: Vector2):
	var _point_ID = get_point_ID(_point)
	for direction in DIRECTIONS:
		var neighbor = _point + direction
		var neighbor_ID = get_point_ID(neighbor)
		if grid.grid.has(neighbor) and grid.grid[neighbor] == null: #change later to see if navigable
			aStar.connect_points(_point_ID, neighbor_ID)
	
func disconnect_point(_point: Vector2):
	var _point_ID = get_point_ID(_point)
	for direction in DIRECTIONS:
		var neighbor = _point + direction
		var neighbor_ID = get_point_ID(neighbor)
		aStar.disconnect_points(_point_ID, neighbor_ID)
		
func connect_all_points():
	for point in grid.grid:
		connect_point(point)

func generate_path(_point_a, _point_b):
	print("ehh")
	var a_ID = get_point_ID(_point_a)
	var b_ID = get_point_ID(_point_b)
	return aStar.get_point_path(a_ID, b_ID)
