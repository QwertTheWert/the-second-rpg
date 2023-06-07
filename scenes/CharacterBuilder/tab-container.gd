extends TabContainer


const PADDING_TAB_NAME = 20

func _ready():
	for tab_index in range(0, get_tab_count()):
		var tab_title = get_tab_title(tab_index)

		var tab_name_size = tab_title.length()
		var half_pad = ceil((PADDING_TAB_NAME + tab_name_size) / 2.0)
		var tab_title_padded = '%*s' % [half_pad, tab_title]

		tab_title_padded = '%-*s' % [PADDING_TAB_NAME, tab_title_padded]

		set_tab_title(tab_index, tab_title_padded)
"TabContainer/styles/tab_unselected"
