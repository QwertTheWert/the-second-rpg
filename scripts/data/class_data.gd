class_name Class_Data
extends Resource

@export var name := ""

@export var key_attribute: Array[Global.Attributes] = []
@export var class_hp := 8
@export var perception := Global.Prof_Rank.TRAINED

@export var fortitude := Global.Prof_Rank.TRAINED
@export var reflex := Global.Prof_Rank.TRAINED
@export var will := Global.Prof_Rank.TRAINED

@export var unarmed := Global.Prof_Rank.TRAINED
@export var simple := Global.Prof_Rank.TRAINED
@export var martial := Global.Prof_Rank.UNTRAINED
@export var advanced := Global.Prof_Rank.UNTRAINED

@export var unarmored := Global.Prof_Rank.TRAINED
@export var light := Global.Prof_Rank.UNTRAINED
@export var medium := Global.Prof_Rank.UNTRAINED
@export var heavy := Global.Prof_Rank.UNTRAINED

@export var class_dc := Global.Prof_Rank.TRAINED

@export_multiline var text := ""
