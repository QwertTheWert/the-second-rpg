class_name Strikes
extends TextureButton


func set_data():
	if Global.selected_character.size() == 1:
		$".".show()
		$"../Button2".show()
		$"../Button3".show()
		$"../Button4".show()
	elif Global.selected_character.size() == 0:
		$".".hide()
		$"../Button2".hide()
		$"../Button3".hide()
		$"../Button4".hide()
	else:
		$".".hide()
		$"../Button2".hide()
		$"../Button3".hide()
