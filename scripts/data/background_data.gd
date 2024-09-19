class_name Background_Data
extends Resource

@export var name := "Background"
@export var variant_name := ""
@export var image := load("res://assets/data/background/background.svg")
var traits: Array[String] = []

@export var attribute_boost : Array[Global.Attributes] = [Global.Attributes.STRENGTH,Global.Attributes.DEXTERITY]
@export var skill:= Global.Skills.ACROBATICS

@export var variants: Array[Background_Data] = []
@export var is_variant:= false

@export var feat: Feature_Data = Feature_Data.new()
@export_multiline var text:= ""
