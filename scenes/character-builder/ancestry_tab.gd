extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")

@onready var _tree = $VBoxContainer/Body/Options/Tree
@onready var _title = $VBoxContainer/Title/Label

@onready var _anc_button = %AncestryOptionButton
@onready var _her_button = %HeritageOptionButton

@onready var _namebox =  %AncestryTextBox/Name
@onready var _traitbox = %AncestryTextBox/Traits/HBoxContainer
@onready var _descbox = %AncestryTextBox/Description
@onready var _list_of_her = %AncestryTextBox/ScrollContainer/VBoxContainer/Heritages
@onready var _list_of_anc_feats = %AncestryTextBox/ScrollContainer/VBoxContainer/AncestryFeats

@onready var _attributes = %AncestryAttributes
@onready var _other_info = %AncestryOtherInfo
@onready var _anc_features = %AncestryFeatures

var curent_page = ANCESTRY

const HERITAGE_IMG = preload("res://assets/data/heritage/heritage.png")
const CHILD_ELEMENT = preload("res://scenes/character-builder/child_element.tscn")
const ONE_BOOST = "Plus one additional attribute boost to an attribute other than the ones boosted by your ancestry."
const TWO_BOOST = "Two attribute boost to different attributes."

signal change_ancestry()

enum { ANCESTRY, HERITAGE }


func load_ancestry():
	_tree.clear()
	_descbox.clear()
	_title.set_text("Select an Ancestry")
	var _root = _tree.create_item()
	for _anc in _main.ancestry_data:
		var _tree_item = _tree.create_item(_root)
		_tree_item.set_script(load("res://scripts/tree_item.gd"))
		_tree_item.set_icon(0, _anc.image)
		_tree_item.set_text(0, _anc.name)
		if _main.character.ancestry == _anc:
			_tree.set_selected(_tree_item, 0)

func load_heritage():
	_tree.clear()
	_descbox.clear()
	_title.set_text("Select a Heritage")
	_list_of_her.hide()
	_list_of_anc_feats.hide()
	var _root = _tree.create_item()
	for _her in _main.heritage_data:
		var _tree_item = _tree.create_item(_root)
		_tree_item.set_script(load("res://scripts/tree_item.gd"))
		_tree_item.set_icon(0, _her.image)
		_tree_item.set_text(0, _her.name)
		if _main.character.heritage == _her:
			_tree.set_selected(_tree_item, 0)

func _on_cell_selected():
	var _data
	clear_traitbox()
	_descbox.clear()
	
	for i in get_parent().get_child_count()-2:
		get_parent().set_tab_disabled(i+2, true)
	
	match curent_page:
		ANCESTRY:
			_data = ancestry_selected()
		HERITAGE:
			_data = _main.get_data(_tree.get_selected().get_text(0), _main.heritage_data)
			_main.character.heritage = _data
			_her_button.set_texture(_data.image)
			_main.bg_tab.load_background()
			get_parent().set_tab_disabled(1, false)
			if _main.character.character_class:
				get_parent().set_tab_disabled(2, false)
				get_parent().set_tab_disabled(3, false)
	
	for _trait in _data.traits:
		var label = Label.new()
		label.set_text(_trait)
		_traitbox.add_child(label)
	
	_descbox.append_text("[p align=fill]%s[/p]\n\n" % [_data.text])
	_descbox.append_text("[url=fill]hahahaha[/url]\n")
	
	_namebox.get_node("Image").set_texture(_data.image)
	_namebox.get_node("Label").set_text(_data.name)
	
func ancestry_selected():
	var _data = _main.get_data(_tree.get_selected().get_text(0), _main.ancestry_data)
	if _main.character.ancestry != _data:
		_main.character.ancestry = _data
		_main.character.heritage = null
		_her_button.get_node("Button").disabled = false
		_her_button.set_texture(HERITAGE_IMG)
		get_parent().set_tab_disabled(1, true)
		change_ancestry.emit()
	else:
		if _main.character.character_class:
			get_parent().set_tab_disabled(2, false)
	_main.heritage_data = _data.heritages
	_main.heritage_data.sort_custom(_main.sort_name_alphabetically)
	_anc_button.set_texture(_data.image)
	
	_list_of_her.show()
	for i in _list_of_her.get_children():
		if not i.name.matchn("Label"):
			i.queue_free()
	for heritage in _data.heritages:
		var h = CHILD_ELEMENT.instantiate()
		h.setup(heritage)
		_list_of_her.add_child(h)
	
	_anc_features.show()
	for i in _anc_features.get_children():
		if not i.name.matchn("Label"):
			i.queue_free()
	for abil in _data.features:
		var a = CHILD_ELEMENT.instantiate()
		a.setup(abil)
		_anc_features.add_child(a)
	
	_list_of_anc_feats.show()
	for i in _list_of_anc_feats.get_children():
		if not i.name.matchn("Label"):
			i.queue_free()
	for feat in _data.feats:
		var p = CHILD_ELEMENT.instantiate()
		p.setup(feat)
		var p_label = p.get_node("Label")
		if feat.level == 1:
			p_label.set_text("%s (1st)" % p_label.text)
		else:
			p_label.set_text("%s (%th)" % p_label.text, str(p.level))
		_list_of_anc_feats.add_child(p)
	
	for attribute in _attributes.get_node("GridContainer").get_children():
		attribute.get_node("Value").set_text("--")
	if _data.attribute_boost.size():
		_main.character.attribute_boosts["anc_n"][0] = null
		_main.character.attribute_boosts["anc_n"][1] = _data.attribute_boost[0]
		_main.character.attribute_boosts["anc_n"][2] = _data.attribute_boost[1]
		for i in _data.attribute_boost:
			var attribute = _attributes.get_node("GridContainer").get_children()[i]
			attribute.get_node("Value").set_text("+1")
		for i in _data.attribute_flaw:
			var attribute = _attributes.get_node("GridContainer").get_children()[i]
			attribute.get_node("Value").set_text("-1")
		_attributes.get_node("FreeBoost").set_text(ONE_BOOST)
	else:
		_attributes.get_node("FreeBoost").set_text(TWO_BOOST)

	_main.character.attribute_boosts["anc_a"][0] = null
	_main.character.attribute_boosts["anc_a"][1] = null
	_attributes.get_node("FreeBoost").show()
	
	_other_info.get_node("AncestryHP/Value").set_text(str(_data.ancestry_hp))
	_other_info.get_node("Size/Value").set_text(Global.Size.keys()[_data.size].to_pascal_case())
	_other_info.get_node("Speed/Value").set_text(str(_data.speed * 5) + " feet")
	
	return _data

func clear_traitbox():
	for t in _traitbox.get_children():
		t.queue_free()

func _on_ancestry_button_toggled():
	if _anc_button.get_node("Button").button_pressed:
		clear_traitbox()
		_her_button.get_node("Button").button_pressed = false
		curent_page = ANCESTRY
		_namebox.get_node("Image").set_texture(null)
		_namebox.get_node("Label").set_text("")
		load_ancestry()
	else:
		_anc_button.get_node("Button").button_pressed = true

func _on_heritage_button_toggled():
	if _her_button.get_node("Button").button_pressed:
		clear_traitbox()
		_anc_button.get_node("Button").button_pressed = false
		curent_page = HERITAGE
		_namebox.get_node("Image").set_texture(null)
		_namebox.get_node("Label").set_text("")
		load_heritage()
	else:
		_her_button.get_node("Button").button_pressed = true


func _on_description_meta_hover_ended(meta):
	print('ajhja')


func _on_description_meta_hover_started(meta):
	print('ajhja')
