extends TextureRect

func _ready():
	miracle.current_game = miracle.game.danmaku
	$AnimationPlayer.play("start")

func start():
	miracle.load_scene("res://src/Danmaku/danmaku.tscn")
