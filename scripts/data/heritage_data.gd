class_name Heritage_Data
extends Resource

@export var name := "Heritage"

@export var image := Texture2D.new()
@export var traits: Array[String] = []

@export var abilities: Array = []
@export var variants: Array[Heritage_Data] = []
@export var is_prerequisite_for: Array[Feature_Data] = []
@export var is_variant:= false

@export_multiline var text:= ""
