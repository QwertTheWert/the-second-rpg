extends Control

const ANCESTRY_RESOURCE_PATH = "res://resource/game_data/ancestries/"
const BACKGROUND_RESOURCE_PATH = "res://resource/game_data/backgrounds/"
const CLASS_RESOURCE_PATH = "res://resource/game_data/classes/"


const NESTED_TAB_HEIGHT_DIFFERENCE = 63
const TAB_HEIGHT_DIFFERENCE = 32
const BUTTON_HEIGHT_DIFFERENCE = 48
const CONST_PANEL_WIDTH = 320
const TEXT_BOX_WIDTH_DIFFERENCE = 32
const TEXT_BOX_HEIGHT_DIFFERENCE = 16
const ATTRIBUTE_PANEL_DIFFERENCE = 16



@onready var build = $Build/VBoxContainer
@onready var anc_tab = $TabContainer/Ancestry/TabContainer
@onready var her_tab = $TabContainer/Ancestry/TabContainer/Heritage
@onready var bg_tab = $TabContainer/Background
@onready var cls_tab = $TabContainer/Class/TabContainer
@onready var attr_tab = $TabContainer/AttributesSkills

@onready var screen_size = DisplayServer.window_get_size()

var ancestry_data : Array[Ancestry_Data] = []
var heritage_data : Array[Heritage_Data] = []
var background_data : Array[Background_Data] = []
var class_data : Array[Class_Data] = []

func _on_size_changed() -> void:
	screen_size = DisplayServer.window_get_size()
	$TabContainer.size =  Vector2(screen_size.x - CONST_PANEL_WIDTH, screen_size.y)
	$TabContainer.position =  Vector2(CONST_PANEL_WIDTH, 0)
	
	var nested_node_height = screen_size.y - NESTED_TAB_HEIGHT_DIFFERENCE - BUTTON_HEIGHT_DIFFERENCE
	for node in get_tree().get_nodes_in_group("Nested Tree"):
		node.size.y = nested_node_height
	for node in get_tree().get_nodes_in_group("Nested TextBox"):
		node.size = Vector2(screen_size.x - 2 * CONST_PANEL_WIDTH - TEXT_BOX_WIDTH_DIFFERENCE, nested_node_height - TEXT_BOX_HEIGHT_DIFFERENCE)
		node.position = Vector2(CONST_PANEL_WIDTH + TEXT_BOX_WIDTH_DIFFERENCE / 2, TEXT_BOX_HEIGHT_DIFFERENCE / 2)

	var node_height = screen_size.y - TAB_HEIGHT_DIFFERENCE - BUTTON_HEIGHT_DIFFERENCE
	for node in get_tree().get_nodes_in_group("Tree"):
		node.size.y = node_height
	for node in get_tree().get_nodes_in_group("TextBox"):
		node.size = Vector2(screen_size.x - 2 * CONST_PANEL_WIDTH - TEXT_BOX_WIDTH_DIFFERENCE, node_height - TEXT_BOX_HEIGHT_DIFFERENCE)
		node.position = Vector2(CONST_PANEL_WIDTH + TEXT_BOX_WIDTH_DIFFERENCE / 2, TEXT_BOX_HEIGHT_DIFFERENCE / 2)
	
	attr_tab.get_node("Boosts").size.x = (screen_size.x - CONST_PANEL_WIDTH) / 2 - ATTRIBUTE_PANEL_DIFFERENCE
#	attr_tab.get_node("Boosts").scale = Vector2(screen_size.x / 1280.0, screen_size.x / 1280.0)
	
	attr_tab.get_node("Attributes").size.x  = attr_tab.get_node("Boosts").size.x

func _ready():
	get_tree().get_root().size_changed.connect(self._on_size_changed)
	_load_ancestries()
	_load_backgrounds()
	_load_classes()
	anc_tab.get_node("Ancestry").load_tab()
	anc_tab.set_tab_hidden(1, true)
	bg_tab.load_tab()
	cls_tab.get_node("Class").load_tab()
	
func get_data(_selected, _list):
	for i in _list:
		if i.name == _selected:
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

func _on_ancestry_tree_cell_selected():
	build.get_node("Ancestry").set_text("✅ %s" % [anc_tab.get_node("Ancestry/Tree").get_selected().get_text(0)])

func _on_heritage_tree_cell_selected():
	build.get_node("Heritage").set_text("   ✅ %s" % [her_tab.get_node("Tree").get_selected().get_text(0)])

func _on_background_tree_cell_selected():
	var _data = get_data(bg_tab.get_node("Tree").get_selected().get_text(0), background_data)
	if not _data.variants.size():
		build.get_node("Background").set_text("✅ %s" % [bg_tab.get_node("Tree").get_selected().get_text(0)])
	else: 
		build.get_node("Background").set_text("🟥 Background")


func _on_class_tree_cell_selected():
	build.get_node("Class").set_text("✅ %s" % [cls_tab.get_node("Class/Tree").get_selected().get_text(0)])
