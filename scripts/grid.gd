class_name Grid
extends TileMap

@export var width: int = 12
@export var height: int = 12
@export var cell_size: int = 32

@export var show_debug: bool = false

var grid: Dictionary = {}


func generate_grid():
	for x in width:
		for y in height:
			grid[Vector2i(x,y)] = Cell_Data.new(Vector2i(x,y))
			grid[Vector2i(x,y)].floor_data = preload("res://data/ground.tres")
			refresh_tile(Vector2i(x,y))
			
			#Debug Grid
			if show_debug:
				_show_debug(x, y)

func generate_area():
	$Area2D.position = Vector2(float(width*cell_size)/2, float(height*cell_size)/2)
	$Area2D/CollisionShape2D.shape.size = Vector2(width*cell_size, height*cell_size)
	
	
func refresh_tile(_pos: Vector2i) -> void:
	var data = grid[_pos]
	set_cell(0, _pos, data.floor_data.id, data.floor_data.coords)
	set_cell(1, _pos)

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



