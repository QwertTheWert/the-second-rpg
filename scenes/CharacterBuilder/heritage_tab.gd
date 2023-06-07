extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")
@onready var _main_tab = _main.get_node("TabContainer")
var _label
var _tree

func load_tab():
	_label = $Label
	_tree = $Tree
	_tree.clear()
	_label.clear()
	
	_label.append_text("[font_size=24]Select a Heritage[/font_size]\n")
	
	var _root = _tree.create_item()
	for _heri in _main.heritage_data:
		var _heri_button = _tree.create_item(_root)
		_heri_button.set_text(0, _heri.name)
		if _heri.variants.size():
			print(_heri.name)

func _on_cell_selected():
	var _data = _main.get_data(_tree.get_selected().get_text(0), _main.heritage_data)

	_label.clear()
	_label.append_text("[font_size=24]%s[/font_size]\n" % [_data.name])
	_label.append_text("[fill]%s[/fill]\n\n" % [_data.text])


func _on_back_pressed():
	get_parent().set_current_tab(0)


func _on_next_pressed():
	_main_tab.set_current_tab(1)
