class_name Ancestry_Data
extends Resource

@export var name := "Ancestry"

@export var image := load("res://assets/data/ancestry/ancestry.png")
@export var traits: Array[String] = ["Humanoid"]

@export var heritages: Array[Heritage_Data] = []
@export var feats: Array[Feature_Data] = []

@export var attribute_boost : Array[Global.Attributes] = []
@export var attribute_flaw : Array[Global.Attributes] = []

@export var size := Global.Size.MEDIUM
@export var ancestry_hp := 8
@export var speed := 5

@export var features: Array[Feature_Data] = []

const is_variant:= false


@export_multiline var text:= ""
