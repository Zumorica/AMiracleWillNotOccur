extends Control

func _ready():
	if miracle.current_game == miracle.game.danmaku:
		$VBoxContainer/Label2.text = "\"How pitiful! *giggle*\""
		$VBoxContainer/Label3.text = "Score: %s"%miracle.danmaku_score
		$VBoxContainer/Label3.show()

func continue_button():
	if miracle.current_game == miracle.game.RPG:
		miracle.load_scene("res://src/RPG_title.tscn")
	elif miracle.current_game == miracle.game.danmaku:
		miracle.load_scene("res://src/Danmaku_title.tscn")
	else:
		exit()

func exit():
	miracle.load_scene("res://src/title.tscn")
