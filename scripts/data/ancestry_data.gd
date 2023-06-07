class_name Ancestry_Data
extends Resource

@export var name := "Ancestry"

@export var traits: Array[String] = ["Humanoid"]

@export var heritages: Array[Heritage_Data] = []

@export var attribute_boost : Array[Global.Attributes] = []
@export var attribute_flaw : Array[Global.Attributes] = []

@export var size := Global.Size.MEDIUM
@export var ancestry_hp := 8
@export var speed := 5

@export var abilities: Array = []

@export_multiline var text:= ""
