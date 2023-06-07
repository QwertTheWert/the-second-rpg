class_name Background_Data
extends Resource

@export var id := ""
@export var name := "Background"

@export var attribute_boost : Array[Global.Attributes] = [Global.Attributes.STRENGTH,Global.Attributes.DEXTERITY]
@export var skill:= Global.Skills.ACROBATICS

@export var variants: Array[Background_Data] = []
@export var is_variant:= false

@export_multiline var text:= ""
