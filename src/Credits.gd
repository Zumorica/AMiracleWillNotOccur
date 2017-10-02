extends Control

func _ready():
	miracle.current_game = miracle.game.completed
	yield(get_tree().create_timer(15), "timeout")
	miracle.load_scene("res://src/DarkRikaCorner.tscn")