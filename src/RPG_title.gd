extends TextureRect

var scene = preload("res://src/RPG/RPG.tscn")

func _ready():
	miracle.current_game = miracle.game.RPG

func start():
	miracle.load_scene("res://src/RPG/RPG.tscn")
