extends KinematicBody2D

var follow_player = false
var is_deadly = false
var velocity = Vector2(0, 150)
var power = 32

func _ready():
	set_fixed_process(true)
	var psize
	if power > 16:
		psize = 0.75
	elif power < 9:
		psize = 0.5625
	else:
		psize = power / 16
	scale = (Vector2(psize, psize))

func _fixed_process(delta):
	if not follow_player:
		move(velocity * delta)
	else:
		if miracle.game_root:
			var start = position
			var end = miracle.game_root.player.position
			var distance = start.distance_to(end)
			var direction = (end - start).normalized()
			move(direction * 512 * delta)