class_name Character_Data
extends Resource

@export var id : int
@export var name := "Default"
@export_dir var image_path: String
@export var level := 1
@export var experience := 0
@export var ancestry := Global.Ancestries.HUMAN
@export var heritage := Global.Heritages.HERITAGE_1
@export var background := Global.Backgrounds.BACKGROUND_1
@export var character_class:= Global.Classes.CLERIC

@export var size:= Global.Size.MEDIUM

@export var ability_modifier:= Ability_Modifiers.new()
@export var key_ability:= Global.Abilities.STRENGTH

@export var languages: Array[String] = ["Common"]

@export var speed:= 5

@export var hit_points:= Hit_Points.new()

@export var proficiencies:= Proficiencies.new()
@export var feats: Resource
@export var features: Resource
@export var lore: Resource

@export var map_position: Vector2i
