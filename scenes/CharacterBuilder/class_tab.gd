extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")
@onready var _main_tab = _main.get_node("TabContainer")
@onready var _label = $Label
@onready var _tree = $Tree
signal change_selected_class()

func load_tab():
	_tree.clear()
	_label.append_text("[font_size=24]Select a Class[/font_size]\n")
	
	var _root = _tree.create_item()
	for _cls in _main.class_data:
		var _cls_button = _tree.create_item(_root)
		_cls_button.set_text(0, _cls.name)

func _on_cell_selected():
	var _data = _main.get_data(_tree.get_selected().get_text(0), _main.class_data)
	
	_label.clear()
	_label.append_text("[font_size=24]%s[/font_size]\n" % [_data.name])
	
	_label.append_text("%s\n\n" % [_data.text])
	if _data.key_attribute.size() == 1:
		var _key = Global.Attributes.keys()[_data.key_attribute[0]]
		_label.append_text("[b]Key Attribute: %s[/b]\nAt 1st level, your class gives you an attribute boost to %s.\n\n" % [_key, _key.to_pascal_case()])
	elif _data.key_attribute.size() == 2:
		var _key1 = Global.Attributes.keys()[_data.key_attribute[0]]
		var _key2 = Global.Attributes.keys()[_data.key_attribute[1]]
		_label.append_text("[b]Key Attribute: %s OR %s[/b]\nAt 1st level, your class gives you an attribute boost to your choice of %s or %s.\n\n" % [_key1, _key2, _key1.to_pascal_case(),_key2.to_pascal_case()])
	else:
		var _key = Global.Attributes.keys()[_data.key_attribute[0]]
		_label.append_text("[b]Key Attribute: %s OR OTHER[/b]\nAt 1st level, your class gives you an attribute boost to %s or an option from rogue's racket..\n\n" % [_key, _key.to_pascal_case()])
	
	_label.append_text("[b]Hit Points: %s plus your Constitution modifier[/b]
You increase your maximum number of HP by this number at 1st level and every level thereafter.\n\n" % [_data.class_hp])

	_label.append_text("%s\n\n" % [_data.text])
	
	
	change_selected_class.emit()



func _on_back_pressed():
	_main_tab.set_current_tab(1)

func _on_next_pressed():
	_main_tab.set_current_tab(3)

