extends TextureRect

func _ready():
	miracle.current_game = miracle.game.platformer
	$AnimationPlayer.play("start")

func start():
	if miracle.platformer_level == 0:
		miracle.load_scene("res://src/Platformer/platformer.tscn")
	elif miracle.platformer_level == 1:
		miracle.load_scene("res://src/Platformer/Platformer_Bernkastel.tscn")
