extends Node2D

export(int) var level = 0

var player
var bern_boss_started = false 

func _init():
	miracle.game_root = self

func _ready():
	miracle.current_game = miracle.game.platformer
	miracle.platformer_level = level