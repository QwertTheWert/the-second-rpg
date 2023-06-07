extends Node

@onready var _main = get_tree().get_root().get_node("CharacterBuilder")

func _ready():
	for i in Global.Attributes:
		$Boosts/AncestralBoosts/ANCOption.add_item("➕ "+i)
		$Boosts/BackgroundBoosts/BGBoost1.add_item("➕ "+i)
		$Boosts/BackgroundBoosts/BGBoost2.add_item("➕ "+i)
		$Boosts/ClassBoost.add_item("➕ "+i)
		$Boosts/AlternateBoosts/ALTBoost1.add_item("➕ "+i)
		$Boosts/AlternateBoosts/ALTBoost2.add_item("➕ "+i)		
		$Boosts/BoostsOptions/BGBoost1.add_item("➕ "+i)
		$Boosts/BoostsOptions/BGBoost2.add_item("➕ "+i)
		$Boosts/BoostsOptions/BGBoost3.add_item("➕ "+i)
		$Boosts/BoostsOptions/BGBoost4.add_item("➕ "+i)
func load_tab() -> void:
	pass
				

func _on_cell_selected():
	pass
		
func _on_next_pressed():
	pass

func _on_back_pressed():
	get_parent().set_current_tab(2)


func _on_alternate_toggle_toggled(button_pressed):
	if button_pressed:
		$Attributes/AncestralBoosts.hide()
		$Attributes/AlternateBoosts.show()
	else:
		$Attributes/AncestralBoosts.show()
		$Attributes/AlternateBoosts.hide()
