class_name Grid
extends TileMap

@export var width: int = 12
@export var height: int = 12
@export var cell_size: int = 128

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
				var rect = ReferenceRect.new()
				rect.position = map_to_local(Vector2i(x,y))
				rect.size = Vector2i(cell_size, cell_size)
				rect.editor_only = false
				$Debug.add_child(rect)
				var label = Label.new()
				label.position = map_to_local(Vector2i(x,y))
				label.text = str(Vector2i(x,y))
				$Debug.add_child(label)

func refresh_tile(_pos: Vector2i) -> void:
	var data = grid[_pos]
	set_cell(0, _pos, data.floor_data.id, data.floor_data.coords)
	set_cell(1, _pos)
#
#func grid_to_world(_pos: Vector2i) -> Vector2:
#	return _pos * cell_size
#
#func world_to_grid(_pos: Vector2) -> Vector2i:
#	return floor(_pos / cell_size)
