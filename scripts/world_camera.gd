extends Camera2D

@export var speed = 400
@export var zoom_speed = 0.15
@export var min_zoon = 0.4
@export var max_zoom = 2
@export var mouse_pan_limit = 2
var screen_size
func _ready():
	screen_size = DisplayServer.window_get_size()
	position = screen_size/2
	get_tree().get_root().size_changed.connect(self._on_size_changed)

func _on_size_changed():
	screen_size = DisplayServer.window_get_size()

func _process(delta):
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

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				zoom += Vector2(zoom_speed, zoom_speed)
			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				zoom -= Vector2(zoom_speed, zoom_speed)
			zoom = Vector2(clamp(zoom.x, min_zoon, max_zoom), clamp(zoom.y, min_zoon, max_zoom))
