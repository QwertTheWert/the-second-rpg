extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")
@onready var _label = $Label
@onready var _tree = $Tree

func load_tab() -> void:
	_tree.clear()
	_label.append_text("[font_size=24]Select a Background[/font_size]\n")
	
	var _root = _tree.create_item()
	for _bg in _main.background_data:
		if not _bg.is_variant:
			var _bg_button = _tree.create_item(_root)
			_bg_button.set_text(0, _bg.name)
			if _bg.variants.size():
				for _variant in _bg.variants:
					var _variant_button = _tree.create_item(_bg_button)
					_variant_button.set_text(0, _variant.name)
				_bg_button.set_collapsed(true)
			else:
				_bg_button.set_disable_folding(true)
				

func _on_cell_selected():
	var _data = _main.get_data(_tree.get_selected().get_text(0), _main.background_data)
#
	if _data.variants.size():
		_tree.get_selected().set_collapsed(false)

	_label.clear()
	_label.append_text("[font_size=24]%s[/font_size]\n" % [_data.name])
	
	_label.append_text("[fill]%s[/fill]\n\n" % [_data.text])
	
	var stat1 = Global.Attributes.keys()[_data.attribute_boost[0]].to_pascal_case()
	var stat2 = Global.Attributes.keys()[_data.attribute_boost[1]].to_pascal_case()
	_label.append_text("[b]Attribute Boosts[/b] %s or %s, and one additional free boost\n" % [stat1, stat2])
	if _data.variants.size():
		_label.append_text("[b]Skills[/b] trained in ")
		if _data.variants.size() == 2:
			var _skill1 = Global.Skills.keys()[_data.variants[0].skill].to_pascal_case()
			var _skill2 = Global.Skills.keys()[_data.variants[1].skill].to_pascal_case()
			_label.append_text("%s or %s" % [_skill1, _skill2])
		else:
			for i in _data.variants:
				var _skill = Global.Skills.keys()[i.skill].to_pascal_case()
				if i != _data.variants[-1]:
					_label.append_text("%s, " % [_skill])
				else:
					_label.append_text("or %s" % [_skill])
	else:
		var _skill = Global.Skills.keys()[_data.skill].to_pascal_case()
		_label.append_text("[b]Skills[/b] trained in %s\n" % [_skill])


func _on_next_pressed():
	get_parent().set_current_tab(2)


func _on_back_pressed():
	get_parent().set_current_tab(0)
	if get_parent().get_node("Ancestry/TabContainer").is_tab_hidden(1):
		get_parent().get_node("Ancestry/TabContainer").set_current_tab(0)
	else:
		get_parent().get_node("Ancestry/TabContainer").set_current_tab(1)
