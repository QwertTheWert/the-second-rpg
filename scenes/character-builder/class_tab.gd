extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")

@onready var _tree = $VBoxContainer/Body/Options/Tree
@onready var _title = $VBoxContainer/Title/Label

@onready var _cls_button = %ClassOptionButton
@onready var _subclass1_button = %Subclass1OptionButton
@onready var _subclass2_button = %Subclass2OptionButton

@onready var _namebox =  %ClassTextBox/Name
@onready var _traitbox = %ClassTextBox/Traits/HBoxContainer
@onready var _descbox = %ClassTextBox/Description
@onready var _list_of_features = %ClassFeatures
@onready var _list_of_feats = %ClassFeats

@onready var _class_statistics = %ClassStatistics
@onready var _proficiencies = %Proficiencies
@onready var _granted_features = %GrantedFeatures

var curent_page = CLASS


const RACKET_IMG = preload("res://assets/data/subclass/racket.svg")
const MUSE_IMG = preload("res://assets/data/subclass/muse.svg")
const DEITY_IMG = preload("res://assets/data/subclass/deity.svg")
const FONT_IMG = preload("res://assets/data/subclass/font.svg")
const SCHOOL_IMG = preload("res://assets/data/subclass/school.svg")
const THESIS_IMG = preload("res://assets/data/subclass/thesis.svg")


const CHILD_ELEMENT = preload("res://scenes/character-builder/child_element.tscn")
const ONE_BOOST = "Plus one additional attribute boost to an attribute other than the ones boosted by your ancestry."
const TWO_BOOST = "Two attribute boost to different attribute modifiers."

signal change_class()

enum { CLASS, SUBCLASS1, SUBCLASS2 }


func load_class():
	_tree.clear()
	_descbox.clear()
	_title.set_text("Select a Class")
	var _root = _tree.create_item()
	for _cls in _main.class_data:
		var _tree_item = _tree.create_item(_root)
		_tree_item.set_script(load("res://scripts/tree_item.gd"))
		_tree_item.set_icon(0, _cls.image)
		_tree_item.set_text(0, _cls.name)
		if _main.character.character_class == _cls:
			_tree.set_selected(_tree_item, 0)

func load_subclass(a: Array[Feature_Data], b: Feature_Data):
	_tree.clear()
	_descbox.clear()
	match _main.character.character_class.name:
		"Bard":
			_title.set_text("Select a Muse")
		"Rogue":
			_title.set_text("Select a Racket")
	_list_of_features.hide()
	_list_of_feats.hide()
	var _root = _tree.create_item()
	for i in a:
		var _tree_item = _tree.create_item(_root)
		_tree_item.set_script(load("res://scripts/tree_item.gd"))
		_tree_item.set_icon(0, i.image)
		_tree_item.set_text(0, i.name)
		if i == b:
			_tree.set_selected(_tree_item, 0)
			if i.variants.size():
				for _variant in i.variants:
					var _variant_item = _tree.create_item(_tree_item)
					_variant_item.set_script(load("res://scripts/tree_item.gd"))
					_variant_item.set_icon(0, _variant.image)
					_variant_item.set_text(0, _variant.variant_name)
				_tree_item.set_collapsed(true)
			else:
				_tree_item.set_disable_folding(true)

func _on_cell_selected():
	var _data
	clear_traitbox()
	_descbox.clear()
	
	match curent_page:
		CLASS:
			_data = class_selected(_data)
			change_class.emit()
			if not _data.subclasses1.size():
				get_parent().set_tab_disabled(3, false)
		SUBCLASS1:
			_data = _main.get_data(_tree.get_selected().get_text(0), _main.subclass1_data)
			_main.character.subclass1 = _data
			if _data != null:
				_subclass1_button.set_texture(_data.image)
			if not _main.character.character_class.subclasses2.size():
				get_parent().set_tab_disabled(3, false)
		SUBCLASS2:
			_data = _main.get_data(_tree.get_selected().get_text(0), _main.subclass2_data)
			_main.character.subclass2 = _data
			if _data != null:
				_subclass2_button.set_texture(_data.image)
			get_parent().set_tab_disabled(3, false)
	
	_descbox.append_text("[fill]%s[/fill]\n\n" % [_data.text])
	_namebox.get_node("Image").set_texture(_data.image)
	_namebox.get_node("Label").set_text(_data.name)
	
func class_selected(data):
	data = _main.get_data(_tree.get_selected().get_text(0), _main.class_data)
	if _main.character.character_class != data:
		_main.character.character_class = data
		_main.character.subclass1 = null
		_main.character.subclass2 = null
		
		for node in get_tree().get_nodes_in_group("Subclass"):
			node.hide()
		
		set_subclass(data)
		set_statistics(data)
		
		_proficiencies.get_node("Perception/Value").clear()
		var perc_prof = _main.return_prof_image(data.perception)
		_proficiencies.get_node("Perception/Value").append_text(
			"[center]Perception [img=16x16]%s[/img][/center]\n" % perc_prof)
		
		set_saves(data)
		set_attacks(data)
		set_defenses(data)
		
#		_list_of_features.show()
#		for i in _list_of_features.get_children():
#			if not i.name.matchn("Label"):
#				i.queue_free()
		for i in _granted_features.get_children():
			i.queue_free()
		for feature in data.features:
			var node = CHILD_ELEMENT.instantiate()
			node.setup(feature)
			match feature.level:
				1:
					_granted_features.add_child(node)
	
		set_dcs(data)
		
		get_parent().set_tab_disabled(3, true)
		
		_list_of_feats.show()

	_cls_button.set_texture(data.image)

	return data

func clear_traitbox():
	for t in _traitbox.get_children():
		t.queue_free()

func set_subclass(data):
	match data.name:
		"Bard":
			_subclass1_button.show()
			_subclass1_button.set_texture(MUSE_IMG)
			_main.subclass1_data = data.subclasses1
			_main.subclass1_data.sort_custom(_main.sort_name_alphabetically)
		"Rogue":
			_subclass1_button.show()
			_subclass1_button.set_texture(RACKET_IMG)
			_main.subclass1_data = data.subclasses1
			_main.subclass1_data.sort_custom(_main.sort_name_alphabetically)
		"Wizard":
			_subclass1_button.show()
			_subclass1_button.set_texture(SCHOOL_IMG)
			_subclass2_button.show()
			_subclass2_button.set_texture(THESIS_IMG)
			_main.subclass1_data = data.subclasses1
			_main.subclass1_data.sort_custom(_main.sort_name_alphabetically)
			_main.subclass2_data = data.subclasses2
			_main.subclass2_data.sort_custom(_main.sort_name_alphabetically)

func set_statistics(data):
	_class_statistics.get_node("KeyAttribute/Value").clear()
	match data.key_attribute.size():
		1:
			_main.character.attribute_boosts["cls"] = data.key_attribute[0]
			var a = Global.Attributes.keys()[data.key_attribute[0]].to_pascal_case()
			_class_statistics.get_node("KeyAttribute/Value").append_text(
				"[center]%s[/center]\n" % a)
		2:
			_main.character.attribute_boosts["cls"] = null
			var a = Global.Attributes.keys()[data.key_attribute[0]].to_pascal_case()
			var b = Global.Attributes.keys()[data.key_attribute[1]].to_pascal_case()
			_class_statistics.get_node("KeyAttribute/Value").append_text(
				"[center]%s or %s[/center]\n" % [a, b])
		_:
			_main.character.attribute_boosts["cls"] = null
			_class_statistics.get_node("KeyAttribute/Value").append_text(
				"[center]Dexterity or Others[/center]\n")
	_class_statistics.get_node("ClassHP/Value").set_text("+%s / level" % data.class_hp)

func set_saves(data):
	_proficiencies.get_node("SavingThrows/Value").clear()
	var fort_prof = _main.return_prof_image(data.fortitude)
	var ref_prof = _main.return_prof_image(data.reflex)
	var will_prof = _main.return_prof_image(data.will)
	_proficiencies.get_node("SavingThrows/Value").append_text(
		"[center]Fortitude [img=16x16]%s[/img][/center]\n" % fort_prof)
	_proficiencies.get_node("SavingThrows/Value").append_text(
		"[center]Reflex [img=16x16]%s[/img][/center]\n" % ref_prof)
	_proficiencies.get_node("SavingThrows/Value").append_text(
		"[center]Will [img=16x16]%s[/img][/center]\n" % will_prof)

func set_attacks(data):
	_proficiencies.get_node("Attacks/Value").clear()
	if data.unarmed != 0:
		var unarmed_prof = _main.return_prof_image(data.unarmed)
		_proficiencies.get_node("Attacks/Value").append_text(
			"[center]Unarmed Attacks [img=16x16]%s[/img][/center]\n" % unarmed_prof)
	if data.simple != 0:
		var simple_prof = _main.return_prof_image(data.simple)
		_proficiencies.get_node("Attacks/Value").append_text(
			"[center]Simple Weapon [img=16x16]%s[/img][/center]\n" % simple_prof)
	if data.martial != 0:
		var martial_prof = _main.return_prof_image(data.martial)
		_proficiencies.get_node("Attacks/Value").append_text(
			"[center]Martial Weapon [img=16x16]%s[/img][/center]\n" % martial_prof)
	if data.advanced != 0:
		var advanced_prof = _main.return_prof_image(data.advanced)
		_proficiencies.get_node("Attacks/Value").append_text(
			"[center]Advanced Weapon [img=16x16]%s[/img][/center]\n" % advanced_prof)

func set_defenses(data):
	_proficiencies.get_node("Defenses/Value").clear()
	if data.unarmored != 0:
		var unarmored_prof = _main.return_prof_image(data.unarmored)
		_proficiencies.get_node("Defenses/Value").append_text(
			"[center]Unarmored [img=16x16]%s[/img][/center]\n" % unarmored_prof)
	if data.light != 0:
		var light_prof = _main.return_prof_image(data.light)
		_proficiencies.get_node("Defenses/Value").append_text(
			"[center]Light [img=16x16]%s[/img][/center]\n" % light_prof)
	if data.medium != 0:
		var medium_prof = _main.return_prof_image(data.medium)
		_proficiencies.get_node("Defenses/Value").append_text(
			"[center]Medium [img=16x16]%s[/img][/center]\n" % medium_prof)
	if data.heavy != 0:
		var heavy_prof = _main.return_prof_image(data.heavy)
		_proficiencies.get_node("Defenses/Value").append_text(
			"[center]Heavy [img=16x16]%s[/img][/center]\n" % heavy_prof)

func set_dcs(data):
	_proficiencies.get_node("DC/Value").clear()
	var class_dc_prof = _main.return_prof_image(data.class_dc)
	if data.class_dc != 0:
		_proficiencies.get_node("DC/Value").append_text(
			"[center]%s DC [img=16x16]%s[/img][/center]\n" % [data.name, class_dc_prof])
	if data.arcane != 0:
		var arcane = _main.return_prof_image(data.arcane)
		_proficiencies.get_node("DC/Value").append_text(
			"[center]Arcane [img=16x16]%s[/img][/center]\n" % arcane)
	elif data.divine != 0:
		var divine = _main.return_prof_image(data.divine)
		_proficiencies.get_node("DC/Value").append_text(
			"[center]Divine [img=16x16]%s[/img][/center]\n" % divine)
	elif data.occult != 0:
		var occult = _main.return_prof_image(data.occult)
		_proficiencies.get_node("DC/Value").append_text(
			"[center]Occult [img=16x16]%s[/img][/center]\n" % occult)
	elif data.primal != 0:
		var primal = _main.return_prof_image(data.primal)
		_proficiencies.get_node("DC/Value").append_text(
			"[center]Primal [img=16x16]%s[/img][/center]\n" % primal)
	get_parent().set_tab_disabled(3, true)

func _on_class_button_pressed():
	if _cls_button.get_node("Button").button_pressed:
		clear_traitbox()
		for node in get_tree().get_nodes_in_group("Subclass"):
			node.get_node("Button").button_pressed = false
		curent_page = CLASS
		_namebox.get_node("Image").set_texture(null)
		_namebox.get_node("Label").set_text("")
		load_class()
	else:
		_cls_button.get_node("Button").button_pressed = true

func _on_subclass1_button_pressed():
	open_subclass(_subclass1_button, _main.subclass1_data, _main.character.subclass1)

func _on_subclass2_button_pressed():
	open_subclass(_subclass2_button, _main.subclass2_data, _main.character.subclass2)

func open_subclass(_subclass_button, _subclass_data, _selected_subclass):
	if _subclass_button.get_node("Button").button_pressed:
		clear_traitbox()
		_cls_button.get_node("Button").button_pressed = false
		for node in get_tree().get_nodes_in_group("Subclass"):
			if node != _subclass_button:
				node.get_node("Button").button_pressed = false
		_namebox.get_node("Image").set_texture(null)
		_namebox.get_node("Label").set_text("")
		load_subclass(_subclass_data, _selected_subclass)
		match _subclass_button:
			_subclass1_button:
				curent_page = SUBCLASS1
			_subclass2_button:
				curent_page = SUBCLASS2
	else:
		_subclass_button.get_node("Button").button_pressed = true

