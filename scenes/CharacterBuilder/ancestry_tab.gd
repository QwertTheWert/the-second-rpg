extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")
@onready var _main_tab = _main.get_node("TabContainer")
@onready var _label = $Label
@onready var _tree = $Tree
signal change_selected_ancestry()

func load_tab():
	_tree.clear()
	_label.append_text("[font_size=24]Select an Ancestry[/font_size]\n")
	
	var _root = _tree.create_item()
	for _anc in _main.ancestry_data:
		var _anc_button = _tree.create_item(_root)
		_anc_button.set_text(0, _anc.name)

func _on_cell_selected():
	get_parent().set_tab_hidden(1, false)
	var _data = _main.get_data(_tree.get_selected().get_text(0), _main.ancestry_data)
	
	_label.clear()
	_label.append_text("[font_size=24]%s[/font_size]\n" % [_data.name])
	_label.append_text("[b]Traits[/b] Humanoid, %s\n" % [_data.name])
	
	_label.append_text("[fill]%s[/fill]\n\n" % [_data.text])
	
	_label.append_text("[b]Size[/b] %s\n" % [Global.Size.keys()[_data.size].to_pascal_case()])
	_label.append_text("[b]Ancestry HP[/b] %s\n" % [_data.ancestry_hp])
	_label.append_text("[b]Speed[/b] %s feet\n" % [_data.speed * 5])
	_label.append_text("[b]Special Senses[/b] %s\n" % ["placeholder"])
	if _data.attribute_boost.size() == 2:
		var stat1 = Global.Attributes.keys()[_data.attribute_boost[0]].to_pascal_case()
		var stat2 = Global.Attributes.keys()[_data.attribute_boost[1]].to_pascal_case()
		_label.append_text("[b]Attribute Boosts[/b] %s, %s, and one free boost\n" % [stat1, stat2])
	else:
		_label.append_text("[b]Attribute Boosts[/b] two free boosts\n")
	if _data.attribute_flaw.size() == 1:
		var stat = Global.Attributes.keys()[_data.attribute_flaw[0]].to_pascal_case()
		_label.append_text("[b]Stat Flaw[/b] %s\n\n" % [stat])
	else:
		_label.append_text("[b]Stat Flaw[/b] none\n\n")
	
	
	_main.heritage_data = _data.heritages
	_main.heritage_data.sort_custom(_main.sort_name_alphabetically)
	_main.build.get_node("Heritage").set_text("   🟥 Heritage")
	_main.build.get_node("AncestryFeat1").set_text("   🟥 Ancestry Feat")
	change_selected_ancestry.emit()


func _on_next_pressed():
	if get_parent().is_tab_hidden(1):
		_main_tab.set_current_tab(1)
	else:
		get_parent().set_current_tab(1)
