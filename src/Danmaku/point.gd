extends KinematicBody2D

var follow_player = false
var is_deadly = false
var velocity = Vector2(0, 150)
var point = 300

func _ready():
	set_physics_process(true)
	
func _physics_process(delta):
	if not follow_player:
		move_and_collide(velocity * delta)
	else:
		if miracle.game_root:
			var start = position
			var end = miracle.game_root.player.position
			var distance = start.distance_to(end)
			var direction = (end - start).normalized()
			move_and_collide(direction * 512 * delta)