class_name Character_Data
extends Resource

@export var id : int
@export var name := "Default"
@export_dir var image_path: String
@export var level := 1
@export var experience := 0
@export var ancestry := 0
@export var heritage := 0
@export var background := 0
@export var size:= 2
@export var key_ability:= 0

@export var languages: Array[String] = ["Common"]

@export var speed:= 5

@export var hp_max:= 10
@export var hp_cur:= 10
@export var hp_temp:= 0


@export var abil_str:= 0.0
@export var abil_dex:= 0.0
@export var abil_con:= 0.0
@export var abil_int:= 0.0
@export var abil_wis:= 0.0
@export var abil_cha:= 0.0

@export var proficiencies: Resource
@export var feats: Resource
@export var features: Resource
@export var lore: Resource

@export var map_position: Vector2i



