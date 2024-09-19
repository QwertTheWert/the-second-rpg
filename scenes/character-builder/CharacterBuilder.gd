extends Control

const ANCESTRY_RESOURCE_PATH = "res://resource/game_data/ancestries/"
const BACKGROUND_RESOURCE_PATH = "res://resource/game_data/backgrounds/"
const CLASS_RESOURCE_PATH = "res://resource/game_data/classes/"

const UNTRAINED_IMG = "res://assets/data/proficiency/untrained.png"
const TRAINED_IMG = "res://assets/data/proficiency/trained.png"
const EXPERT_IMG = "res://assets/data/proficiency/expert.png"
const MASTER_IMG = "res://assets/data/proficiency/master.png"
const LEGENDARY_IMG = "res://assets/data/proficiency/legendary.png"

const HEIGHT_DIF = 151
const WIDTH_DIF = 12

@onready var tab_container = $TabContainer

@onready var build = $Build/VBoxContainer
@onready var anc_tab = $TabContainer/Ancestry
@onready var bg_tab = $TabContainer/Background
@onready var cls_tab = $TabContainer/Class
@onready var attr_tab = $TabContainer/Attributes

@onready var screen_size = DisplayServer.window_get_size()

var ancestry_data : Array[Ancestry_Data] = []
var heritage_data : Array[Heritage_Data] = []
var background_data : Array[Background_Data] = []
var class_data : Array[Class_Data] = []
var subclass1_data : Array[Feature_Data] = []
var subclass2_data : Array[Feature_Data] = []

var character = Character_Data.new()

func _on_size_changed() -> void:
	screen_size = DisplayServer.window_get_size()
	for i in get_tree().get_nodes_in_group("Option"):
		i.custom_minimum_size.y = screen_size.y - HEIGHT_DIF
		i.custom_minimum_size.x = (screen_size.x - WIDTH_DIF) / 4 - 8
	for i in get_tree().get_nodes_in_group("Double Size"):
		i.custom_minimum_size.y = screen_size.y - HEIGHT_DIF
		i.custom_minimum_size.x = (screen_size.x - WIDTH_DIF)  * 5 / 8 - 4
	for i in get_tree().get_nodes_in_group("Body"):
		i.custom_minimum_size.x = (screen_size.x - WIDTH_DIF) *  3 / 8 - 12
	var cus_size = (screen_size.x - WIDTH_DIF)  * 5 / 8 - 12
	%AncestryBoosts.get_parent().custom_minimum_size.x = cus_size
	%AncestryBoosts.get_parent().size.x = cus_size
	%AncestryBoosts.get_node("../../").custom_minimum_size.x = cus_size
	%AncestryBoosts.get_node("../../").size.x = cus_size

func _ready():
	get_tree().get_root().size_changed.connect(self._on_size_changed)
	_load_ancestries()
	_load_backgrounds()
	_load_classes()
	anc_tab.load_ancestry()
	attr_tab.load_free_boosts()
	
	for i in tab_container.get_child_count()-1:
		tab_container.set_tab_disabled(i+1, true)
	tab_container.set_tab_disabled(tab_container.get_child_count()-1, false)

func get_data(_selected, _list):
	for i in _list:
		if not i.is_variant:
			if i.name == _selected:
				return i
		else:
			if i.variant_name == _selected:
				return i

func _load_ancestries():
	var dir = DirAccess.open(ANCESTRY_RESOURCE_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var file_to_play_with = load(ANCESTRY_RESOURCE_PATH + file)
		ancestry_data.append(file_to_play_with)
		file = dir.get_next()
	
	ancestry_data.sort_custom(sort_name_alphabetically)

func _load_backgrounds():
	var dir = DirAccess.open(BACKGROUND_RESOURCE_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var file_to_play_with = load(BACKGROUND_RESOURCE_PATH + file)
		background_data.append(file_to_play_with)
		file = dir.get_next()
	
	background_data.sort_custom(sort_name_alphabetically)

func _load_classes():
	var dir = DirAccess.open(CLASS_RESOURCE_PATH)
	dir.list_dir_begin()
	var file = dir.get_next()
	while file != "":
		var file_to_play_with = load(CLASS_RESOURCE_PATH + file)
		class_data.append(file_to_play_with)
		file = dir.get_next()
	
	class_data.sort_custom(sort_name_alphabetically)

func sort_name_alphabetically(a, b) -> bool:
	if a.name < b.name:
		return true
	return false

func return_prof_image(data):
	match data:
		Global.Prof_Rank.UNTRAINED:
			return UNTRAINED_IMG
		Global.Prof_Rank.TRAINED:
			return  TRAINED_IMG
		Global.Prof_Rank.EXPERT:
			return EXPERT_IMG
		Global.Prof_Rank.MASTER:
			return MASTER_IMG
		Global.Prof_Rank.LEGENDARY:
			return LEGENDARY_IMG
