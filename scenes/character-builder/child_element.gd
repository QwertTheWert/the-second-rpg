extends HBoxContainer
class_name Child_Element

const CUSTOM_POPUP = preload("res://scenes/custom_tooltip.tscn")
var data
var tooltip
func setup(_data):
	data = _data
	$TextureRect.texture = data.image
	$Label.set_text(data.name)

func _make_custom_tooltip(_for_text):
	tooltip = CUSTOM_POPUP.instantiate()
	tooltip.get_node("Name/Image").set_texture(data.image)
	tooltip.get_node("Name/Label").set_text(data.name)
	tooltip.get_node("Description").append_text("[p align=fill]%s[/p]" % data.text)
	for _trait in data.traits:
		var label = Label.new()
		label.set_text(_trait)
		tooltip.get_node("Traits/HBoxContainer").add_child(label)
	
	return tooltip
