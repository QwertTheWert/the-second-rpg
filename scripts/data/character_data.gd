class_name Character_Data
extends Resource

@export var id : int
@export var name := "Default"
@export_dir var image_path: String
@export var level := 1
@export var experience := 0
@export var ancestry := GLOBALS.Ancestry.HUMAN
@export var heritage := GLOBALS.Heritage.HERITAGE_1
@export var background := GLOBALS.Background.BACKGROUND_1
@export var character_class:= GLOBALS.Class.CLERIC

@export var size:= GLOBALS.Size.MEDIUM
@export var key_ability:= GLOBALS.Ability.STRENGTH

@export var languages: Array[String] = ["Common"]

@export var speed:= 5

@export var hp_formula: HP_Formula = HP_Formula.new()

@export var hp_max: int = hp_formula.ancestry_hp + hp_formula.bonus_hp + ((hp_formula.class_hp + hp_formula.bonus_hp_per_level + floor(ability_modifier.constution)) * level)
@export var hp_cur:= hp_max
@export var hp_temp:= 0

@export var ability_modifier: Ability_Score = Ability_Score.new()

@export var proficiencies: Resource
@export var feats: Resource
@export var features: Resource
@export var lore: Resource

@export var map_position: Vector2i



