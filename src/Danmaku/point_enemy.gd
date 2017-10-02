extends KinematicBody2D

var is_deadly = false
var is_point = true
var point = 300

var velocity = 512
func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	if miracle.game_root:
		var start = position
		var end = miracle.game_root.player.position
		var distance = start.distance_to(end)
		var direction = (end - start).normalized()
		move(direction * velocity * delta)