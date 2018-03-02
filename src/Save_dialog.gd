extends WindowDialog

export(NodePath) var save_list
export(NodePath) var savegame_name
export(NodePath) var stage_name
export(NodePath) var date

var selected = null
var saves = []
onready var initial_position = rect_position

func _ready():
	save_list = get_node(save_list)
	savegame_name = get_node(savegame_name)
	stage_name = get_node(stage_name)
	date = get_node(date)
	refresh()

func reset_names():
	savegame_name.text = "    Unknown"
	stage_name.text = "    Unknown"
	date.text = "    Unknown"

func save_selected(save):
	reset_names()
	var data = miracle._load_game(save)
	if typeof(data) == TYPE_DICTIONARY:
		savegame_name.text = "    " + save
		stage_name.text = "    " + miracle.game_name[data.game]
		if data.has("date"):
			date.text = "    %s:%s:%s %s/%s/%s" %[data.date.hour, data.date.minute, data.date.second, data.date.day, data.date.month, data.date.year]
		else:
			date.text = "    Unknown"
	else:
		savegame_name.text = "    Corrupt save"
		stage_name.text = "    Unknown"
		date.text = "    Unknown"

func overwrite_pressed():
	if selected != null:
		save_game(saves[selected], true)

func button_pressed():
	var n = $"NewSaveDialogue/VBoxContainer/LineEdit".text
	save_game(n)

func save_game(n, is_overwrite=false):
	miracle.save_game(n)
	if is_overwrite:
		save_selected(saves[selected])
	refresh()
	if $NewSaveDialogue.is_visible():
		$NewSaveDialogue.hide()

func refresh():
	reset_names()
	save_list.clear()
	saves.clear()
	var directory = Directory.new()
	directory.open("user://save/")
	directory.list_dir_begin(true, true)
	var n = directory.get_next()
	while n != "":
		if not directory.current_is_dir():
			if n.ends_with(".sav"):
				saves.append(n)
				save_list.add_item(n.replace(".sav", ""))
		n = directory.get_next()

func _on_List_item_selected(index):
	selected = index
	save_selected(saves[index])

func popup():
	rect_position = initial_position
	refresh()
	emit_signal("about_to_show")
	.popup()

func hide():
	emit_signal("popup_hide")
	.hide()
