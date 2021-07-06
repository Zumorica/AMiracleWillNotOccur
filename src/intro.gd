extends CenterContainer

func _ready():
	$AnimationPlayer.play("intro")
	yield($AnimationPlayer, "animation_finished")
	miracle.load_scene("res://src/title.tscn")
