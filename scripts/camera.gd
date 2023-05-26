extends Camera2D

var speed: float = 400.0
var zoom_speed: float = 0.2
var min_zoom: float =  1.0
var max_zoom: float =  6.0
var drag_sentivitiy: float = 1.0
var mouse_pan_limit: int = 2


@onready var screen_size = DisplayServer.window_get_size()

func _ready() -> void:
#	position = screen_size/2
	get_tree().get_root().size_changed.connect(self._on_size_changed)

func _on_size_changed() -> void:
	screen_size = DisplayServer.window_get_size()

func _process(delta)-> void:
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("camera_right"):
		velocity.x += 1
	if Input.is_action_pressed("camera_left"):
		velocity.x -= 1
	if Input.is_action_pressed("camera_down"):
		velocity.y += 1
	if Input.is_action_pressed("camera_up"):
		velocity.y -= 1
	
	var mouse_pos = get_viewport().get_mouse_position()
	if mouse_pos.x > screen_size.x - mouse_pan_limit:
		velocity.x += 1
	if mouse_pos.x < mouse_pan_limit:
		velocity.x -= 1
	if mouse_pos.y > screen_size.y - mouse_pan_limit:
		velocity.y += 1
	if mouse_pos.y < mouse_pan_limit:
		velocity.y -= 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
#
	position += velocity / zoom * delta
	position = Vector2(clamp(position.x, 0, screen_size.x), clamp(position.y, 0, screen_size.y))

func _input(event) -> void:
	if event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_MIDDLE):
		position -= event.relative * drag_sentivitiy / zoom
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom += Vector2(zoom_speed, zoom_speed)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom -= Vector2(zoom_speed, zoom_speed)
		zoom = clamp(zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
