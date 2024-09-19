extends OptionButton

signal boost_selected(node: Node, type: String, attr: int)



func _on_item_selected(index):
	emit_signal("boost_selected", $".", name, index)
