extends Button

#@onready var _main = get_tree().root.get_node("Main")

signal hp_signal(value)

func _on_pressed():
	var _dmg = int($"../LineEdit".text)
	emit_signal("hp_signal",_dmg)
