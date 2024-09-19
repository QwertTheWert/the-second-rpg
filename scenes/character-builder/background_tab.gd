extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")

@onready var _tree = $VBoxContainer/Body/Options/Tree

@onready var _namebox =  %BackgroundTextBox/Name
@onready var _descbox = %BackgroundTextBox/Description
@onready var _list_of_variants = %BackgroundTextBox/ScrollContainer/VBoxContainer/Variants

@onready var _attributes = %BackgroundAttributes
@onready var _background_skill_training = %BackgroundSkillTraining
@onready var _feat = %BackgroundFeat


const CHILD_ELEMENT = preload("res://scenes/character-builder/child_element.tscn")
signal change_background()

func load_background():
	_tree.clear()
	_descbox.clear()
	var _root = _tree.create_item()
	for _bg in _main.background_data:
		if not _bg.is_variant:
			var _tree_item = _tree.create_item(_root)
			_tree_item.set_script(load("res://scripts/tree_item.gd"))
			_tree_item.set_icon(0, _bg.image)
			_tree_item.set_text(0, _bg.name)
			if _main.character.background == _bg:
				_tree.set_selected(_tree_item, 0)
			if _bg.variants.size():
				_tree_item.set_collapsed(true)
				for _variant in _bg.variants:
					var _variant_item = _tree.create_item(_tree_item)
					_variant_item.set_script(load("res://scripts/tree_item.gd"))
					_variant_item.set_icon(0, _variant.image)
					_variant_item.set_text(0, _variant.variant_name)
					if _main.character.background == _variant:
						_tree.set_selected(_variant_item, 0)
			else:
				_tree_item.set_disable_folding(true)

func _on_cell_selected():
	_descbox.clear()
	%BackgroundSkillTraining.get_node("Value").clear()
	
	for i in get_parent().get_child_count()-3:
		get_parent().set_tab_disabled(i+3, true)
	
	var _data = background_selected()
	match _main.cls_tab.curent_page:
		_main.cls_tab.CLASS:
			_main.cls_tab.load_class()
		_main.cls_tab.SUBCLASS1:
			_main.cls_tab.load_subclass(_main.subclass1_data, _main.character.subclass1)
		_main.cls_tab.CLASS:
			_main.cls_tab.load_subclass(_main.subclass2_data, _main.character.subclass2)
	if _data.variants.size():
		_tree.get_selected().set_collapsed(false)
		_list_of_variants.show()
		for i in _list_of_variants.get_children():
			if not i.name.matchn("Label"):
				i.queue_free()
		for variant in _data.variants:
			var v = CHILD_ELEMENT.instantiate()
			v.setup(variant)
			_list_of_variants.add_child(v)
		_background_skill_training.get_node("Value").append_text("[center]--[/center]")
	else:
		var s = Global.Skills.keys()[_data.skill].to_pascal_case()
		var prof = _main.return_prof_image(Global.Prof_Rank.TRAINED)
		_background_skill_training.get_node("Value").append_text(
			"[center]%s [img=16x16]%s[/img][/center]\n" % [s, prof])
		_list_of_variants.hide()
		get_parent().set_tab_disabled(2, false)
		if _main.character.character_class:
			get_parent().set_tab_disabled(3, false)
	
	_descbox.append_text("[p align=fill]%s[/p]\n\n" % [_data.text])
	_namebox.get_node("Image").set_texture(_data.image)
	_namebox.get_node("Label").set_text(_data.name)
	
func background_selected():
	var _data = _main.get_data(_tree.get_selected().get_text(0), _main.background_data)
	if _main.character.background != _data:
		_main.character.background = _data
		_main.character.attribute_boosts["bg"][0] = null
		_main.character.attribute_boosts["bg"][1] = null
		change_background.emit()

	_attributes.get_node("HBoxContainer/BGBoostOption1")
	_attributes.get_node("FreeBoost").show()

	var attr1 = _attributes.get_node("HBoxContainer/BGBoostOption1")
	for attribute in attr1.get_children():
		attribute.hide()
	attr1.get_child(_data.attribute_boost[0]).show()

	var attr2 = _attributes.get_node("HBoxContainer/BGBoostOption2")
	for attribute in attr2.get_children():
		attribute.hide()
	attr2.get_child(_data.attribute_boost[1]).show()
	
	_feat.show()
	for i in _feat.get_children():
		if not i.name.matchn("Label"):
			i.queue_free()
	
	var f = CHILD_ELEMENT.instantiate()
	f.setup(_data.feat)
	_feat.add_child(f)
	
	return _data
