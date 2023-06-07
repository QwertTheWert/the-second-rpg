class_name Character_Data
extends Resource

@export var id : int
@export var name := "Default"
@export_dir var image_path: String
@export var level := 1
@export var experience := 0
@export var ancestry : Ancestry_Data = load("res://resource/game_data/ancestries/06.tres")
@export var heritage := load("res://resource/game_data/heritages/0600.tres")
@export var background := load("res://resource/game_data/backgrounds/00.tres")
@export var character_class:= load("res://resource/game_data/classes/00.tres")

@export var size:= Global.Size.MEDIUM

@export var ability_modifier:= Stat_Modifiers.new()
@export var key_ability:= Global.Attributes.STRENGTH

@export var languages: Array[String] = ["Common"]

@export var speed:= 5

@export var hit_points:= Hit_Points.new()

@export var proficiencies:= Proficiencies.new()
@export var feats: Resource
@export var features: Resource
@export var lore: Resource

@export var map_position: Vector2i
