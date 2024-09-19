class_name Feature_Data
extends Resource

@export var name := "Feat"
@export var variant_name := ""
@export var type := Global.Abilities.FEAT

@export var image : Texture2D = load("res://assets/ui-elements/character-builder/feats.webp")
@export var level := 1
@export var traits: Array[String] = []
@export var action: Resource

@export var prerequisites: Array[Feature_Data] = []
@export var is_prerequisite_for: Array[Feature_Data] = []

@export var variants: Array[Feature_Data] = []
@export var is_variant:= false

@export_multiline var upper_text:= ""
@export_multiline var text:= ""

@export var ability = ""
