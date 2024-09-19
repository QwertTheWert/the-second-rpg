class_name Character_Data
extends Resource

@export var id : int
@export var name := "Default"
@export_dir var image_path: String

@export var level := 1
@export var experience := 0

@export var ancestry : Ancestry_Data
@export var heritage : Heritage_Data
@export var background : Background_Data
@export var character_class: Class_Data
@export var subclass1: Feature_Data
@export var subclass2: Feature_Data

@export var size:= Global.Size.MEDIUM

@export var attributes := Attribute_Array.new()
@export var attribute_boosts : Dictionary = {
	"anc_n" : [null, null, null],
	"anc_a" : [null, null],
	"anc_f" : null,
	"bg" : [null, null],
	"cls" : null,
	"1st" : [null, null, null, null],
	"5th" : [null, null, null, null],
	"10th" : [null, null, null, null],
	"20th" : [null, null, null, null]
}
@export var key_ability:= Global.Attributes.STRENGTH

@export var languages: Array[String] = ["Common"]

@export var speed:= 5

@export var hit_points:= Hit_Points.new()

@export var proficiencies:= Proficiencies.new()
@export var feats: Resource
@export var features: Resource
@export var lore: Resource

@export var map_position: Vector2i
