extends Area2D

@onready var main = get_tree().root.get_node("Main")
@onready var grid: Grid = main.get_node("Grid")
@onready var pf: Pathfinder = grid.get_node("Pathfinding")

var data: Token_Data = Token_Data.new()

var path: Array[Vector2]
var pos: Vector2 :
	get:
		return pos
	set(value):
		pos = value

func _ready():
	pos = grid.world_to_grid(position)
	
func _process(delta):
	move(delta)

func move(delta):
	if path.size() > 0:
		if position.distance_to(grid.grid_to_world(path[0])) < 5:
			position = grid.grid_to_world(path[0])
			pos = path[0]
			path.pop_front()
		else:
			position += (grid.grid_to_world(path[0]) - position).normalized() * data.speed * delta

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed == true:
			print("run")
#			if path.size() > 0:
#				path = [path.front()]
			var clicked = grid.world_to_grid(get_global_mouse_position())
			var path_packed_arrays = PackedVector2Array([])
			path_packed_arrays = pf.generate_path(pos, clicked)
