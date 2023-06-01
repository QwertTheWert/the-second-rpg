extends TileMap

#
#@export var width: int = 12
#@export var height: int = 12
#@export var cell_size: int = 32
#
#@export var show_debug: bool = false
## This defines how many tiles are roughly within the radius of the circle
#const CIRCLE_RADIUS = 10
#var grid: Dictionary = {}
#
#func _ready():
#	generate_grid()
#	generate_circle()
#
##func generate_circle(x0, y0, radius):
##	var f = 1 - radius
##	var ddf_x = 1
##	var ddf_y = -2 * radius
##	var x = 0
##	var y = radius
##	self.set(x0, y0 + radius, colour)
##	self.set(x0, y0 - radius, colour)
##	self.set(x0 + radius, y0, colour)
##	self.set(x0 - radius, y0, colour)
##
##	while x < y:
##		if f >= 0: 
##			y -= 1
##			ddf_y += 2
##			f += ddf_y
##		x += 1
##		ddf_x += 2
##		f += ddf_x    
##		self.set(x0 + x, y0 + y, colour)
##		self.set(x0 - x, y0 + y, colour)
##		self.set(x0 + x, y0 - y, colour)
##		self.set(x0 - x, y0 - y, colour)
##		self.set(x0 + y, y0 + x, colour)
##		self.set(x0 - y, y0 + x, colour)
##		self.set(x0 + y, y0 - x, colour)
##		self.set(x0 - y, y0 - x, colour)
##Bitmap.circle = circle
##
##bitmap = Bitmap(25,25)
##bitmap.circle(x0=12, y0=12, radius=12)
##bitmap.chardisplay()
#
#
#func generate_grid():
#	for x in width:
#		for y in height:
#			grid[Vector2i(x,y)] = Cell_Data.new(Vector2i(x,y))
#			grid[Vector2i(x,y)].floor_data = preload("res://data/ground.tres")
#			refresh_tile(Vector2i(x,y))
#
#			#Debug Grid
#			if show_debug:
#				_show_debug(x, y)
#
#
#func refresh_tile(_pos: Vector2i) -> void:
#	var data = grid[_pos]
#	set_cell(0, _pos, data.floor_data.id, data.floor_data.coords)
#	set_cell(1, _pos)
#	set_cell(0, _o)
#
#func _show_debug(x: int, y: int):
#	var rect = ReferenceRect.new()
#	rect.position = map_to_local(Vector2i(x,y))
#	rect.size = Vector2i(cell_size, cell_size)
#	rect.editor_only = false
#	$Debug.add_child(rect)
#	var label = Label.new()
#	label.position = map_to_local(Vector2i(x,y))
#	label.text = str(Vector2i(x,y))
#	$Debug.add_child(label)
#
#
## DRAW CIRCLE
## PATHFIND TO THEIR SPACES
## FLOOD FILL

