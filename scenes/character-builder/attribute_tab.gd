extends TabBar

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")
@onready var _anc_boosts = %AncestryBoosts
@onready var _bg_boosts = %BackgroundBoosts
@onready var _cls_boost = %ClassBoost
@onready var _free_boost = %FreeBoosts

@onready var free_boost_nodes = [
		_free_boost.get_node("Boosts/FreeBoost1"), 
		_free_boost.get_node("Boosts/FreeBoost2"), 
		_free_boost.get_node("Boosts/FreeBoost3"), 
		_free_boost.get_node("Boosts/FreeBoost4")]

const BOOST_ICON = preload("res://assets/ui-elements/character-builder/boost.png")

func load_boost_options(nodes: Array):
	for node in nodes:
		node.clear()
	for i in Global.Attributes:
		for node in nodes:
			node.add_icon_item(BOOST_ICON, i)
			node.set_fit_to_longest_item(true)
			node._select_int(-1)

func load_free_boosts():
	load_boost_options(free_boost_nodes)

func _on_toggle_alternate_toggled(button_pressed):
	if button_pressed:
		_anc_boosts.get_node("NormalBoosts").hide()
		_anc_boosts.get_node("AltBoosts").show()
		compare_attribute(_main.character.attribute_boosts["anc_a"], _anc_boosts)
	else:
		_anc_boosts.get_node("NormalBoosts").show()
		_anc_boosts.get_node("AltBoosts").hide()
		compare_attribute(_main.character.attribute_boosts["anc_n"], _anc_boosts)

func _on_boost_selected(node, type, attr):
	node.set_fit_to_longest_item(false)
	match type: 
		"AncFree":
			_main.character.attribute_boosts["anc_n"][0] = attr
			compare_attribute(_main.character.attribute_boosts["anc_n"], _anc_boosts)
		"BGBoost1":
			attr = _main.character.background.attribute_boost[attr]
			_main.character.attribute_boosts["bg"][0] = attr
			compare_attribute(_main.character.attribute_boosts["bg"], _bg_boosts)
		"BGBoost2":
			_main.character.attribute_boosts["bg"][1] = attr
			compare_attribute(_main.character.attribute_boosts["bg"], _bg_boosts)
		"ChoiceBoost":
			_main.character.attribute_boosts["cls"] = attr
		"FreeBoost1":
			_main.character.attribute_boosts["1st"][0] = attr
			compare_attribute(_main.character.attribute_boosts["1st"], _free_boost)
		"FreeBoost2":
			_main.character.attribute_boosts["1st"][1] = attr
			compare_attribute(_main.character.attribute_boosts["1st"], _free_boost)
		"FreeBoost3":
			_main.character.attribute_boosts["1st"][2] = attr
			compare_attribute(_main.character.attribute_boosts["1st"], _free_boost)
		"FreeBoost4":
			_main.character.attribute_boosts["1st"][3] = attr
			compare_attribute(_main.character.attribute_boosts["1st"], _free_boost)

func compare_attribute(array: Array, node: Node):
	for i in range(0,array.size()):
		for j in range(0,array.size()):
			if array[j] == array[i] && i != j && array[j] != null && array[i] != null:
				node.get_node("DuplicateWarning").show()
				return
	node.get_node("DuplicateWarning").hide()

func _on_change_ancestry():
	var nodes = [
		_anc_boosts.get_node("NormalBoosts/AncFree"), 
		_anc_boosts.get_node("AltBoosts/AltBoost1"), 
		_anc_boosts.get_node("AltBoosts/AltBoost2")]
	load_boost_options(nodes)
	
	var anc_boosts = _main.character.ancestry.attribute_boost
	if anc_boosts.size() > 0:
		var anc_boost1 = Global.Attributes.keys()[anc_boosts[0]]
		var anc_boost2 = Global.Attributes.keys()[anc_boosts[1]]
		var flaw = Global.Attributes.keys()[_main.character.ancestry.attribute_flaw[0]]
		_anc_boosts.get_node("NormalBoosts/AncBoost1").text = anc_boost1
		_anc_boosts.get_node("NormalBoosts/AncBoost2").text = anc_boost2
		_anc_boosts.get_node("NormalBoosts/AncFlaw").text = flaw
		_anc_boosts.get_node("ToggleAlternate").button_pressed = false
		_anc_boosts.get_node("ToggleAlternate").show()
	else:
		_anc_boosts.get_node("ToggleAlternate").button_pressed = true
		_anc_boosts.get_node("ToggleAlternate").hide()

func _on_change_background():
	var node = _bg_boosts.get_node("Boosts/BGBoost1")
	node.clear()
	
	for i in _main.character.background.attribute_boost:
		node.add_icon_item(BOOST_ICON, Global.Attributes.keys()[i])
		node.set_fit_to_longest_item(true)
		node._select_int(-1)

	load_boost_options([_bg_boosts.get_node("Boosts/BGBoost2")])

func _on_change_class():
#		var nodes = [
#				_anc_boosts.get_node("NormalBoosts/AncFree"), _anc_boosts.get_node("AltBoosts/AltBoost1"), _anc_boosts.get_node("AltBoosts/AltBoost2"), _bg_boosts.get_node("Boosts/BGBoost2"),_free_boost.get_node("Boosts/FreeBoost1"), _free_boost.get_node("Boosts/FreeBoost2"), _free_boost.get_node("Boosts/FreeBoost3"), _free_boost.get_node("Boosts/FreeBoost4")]
	var key_attr = _main.character.character_class.key_attribute
	if key_attr.size() == 1:
		var cls_boost = Global.Attributes.keys()[key_attr[0]]
		_cls_boost.get_node("Boost/FixedBoost").text = cls_boost
		_cls_boost.get_node("Boost/ChoiceBoost").hide()
		_cls_boost.get_node("Boost/FixedBoost").show()
	else:
		_cls_boost.get_node("Boost/ChoiceBoost").show()
		_cls_boost.get_node("Boost/ChoiceBoost").clear()
		_cls_boost.get_node("Boost/FixedBoost").hide()
		for i in key_attr:
			var attr = Global.Attributes.keys()[i]
			_cls_boost.get_node("Boost/ChoiceBoost").add_icon_item(BOOST_ICON, attr)
