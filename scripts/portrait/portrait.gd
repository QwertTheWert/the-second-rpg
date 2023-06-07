class_name Portrait
extends TextureRect

@onready var _main = get_tree().root.get_node("Main")
@onready var portraits = get_parent()

const DRAG_TEXTURE_PATH = preload("res://scenes/portrait-drag.tscn")

var character_data: Character_Data: #setget
	get:
		return character_data
	set(value):
		character_data = value


func _ready():
	$Control/HealthBar.max_value = character_data.hit_points.max_hp
	$Control/HealthBar.value = character_data.hit_points.max_hp - character_data.hit_points.current_hp
	$Control/NamePlate.text = "%s/%s" % [character_data.hit_points.current_hp, character_data.hit_points.max_hp]

func unselect(_name) -> void:
	if _name != name:
		$Button.button_pressed = false
		$Control/SelectOutline.hide()
		Global.selected_character.erase(name)


func _update_hp_bar():
	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_LINEAR)
	tween.tween_property($Control/HealthBar, "value", character_data.hit_points.max_hp - character_data.hit_points.current_hp, 0.1)
	$Control/HealthBar.max_value = character_data.hit_points.max_hp
	$Control/NamePlate.text = "%s/%s" % [character_data.hit_points.current_hp, character_data.hit_points.max_hp]

func change_hp(_value: int):
	if Global.selected_character.has(name):
		_update_hp_bar()

func _get_drag_data(_pos):
	var data = {}
	data["origin_slot"] = self
	data["origin_panel"] = "Portraits"
	data["origin_char"] = character_data
	data["origin_selected"] = $Button.button_pressed
	data["origin_order"] = _main.get_node("Grid/Tokens/%s" % [data["origin_slot"].name]).marching_order
	
	var control = DRAG_TEXTURE_PATH.instantiate()
	control.get_node("Image").texture = $Image.texture
#	if not $Button.button_pressed:
#		control.get_node("SelectedOutline").hide()
	set_drag_preview(control)
	
	return data
	
func _can_drop_data(_at_position, data):
	if data["origin_panel"] == "Portraits":
		data["target_slot"] = self
		data["target_char"] = character_data
		data["target_selected"] = $Button.button_pressed
		data["target_order"] = _main.get_node("Grid/Tokens/%s" % [data["target_slot"].name]).marching_order
		return true
	else:
		return false

func _drop_data(_pos, data):
	if data["origin_panel"] == "Portraits":
		if data["target_slot"] != data["origin_slot"]:
			data["target_slot"].name = "Target"
			data["origin_slot"].name = "Origin"
			_swap_portrait_pos(data["target_slot"],data["target_order"],data["origin_char"],data["origin_selected"])
			_swap_portrait_pos(data["origin_slot"],data["origin_order"],data["target_char"],data["target_selected"])

func _swap_portrait_pos(_slot, _order, _char, _selected):
	_slot.character_data = _char
	var target_portrait = load(_slot.character_data.image_path + "/portrait.png")
	_slot.name = "PC-%s" % [_slot.character_data.id]
	_slot.get_node("Image").set_texture(target_portrait)
	_slot._update_hp_bar()
	
	var target_button = _slot.get_node("Button")
	target_button.button_pressed = _selected
	target_button._on_toggled(target_button.button_pressed)
