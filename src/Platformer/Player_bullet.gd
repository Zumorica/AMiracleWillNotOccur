extends KinematicBody2D

var velocity = 1024
var direction = 1

var player
var collision

var is_player_bullet = true

var max_lifetime = 0.75
var current_lifetime = 0

signal deletion()

func _fixed_process(delta):
	current_lifetime += delta
	var new_collision = move(delta * Vector2(velocity * direction, 0))
	
	if not new_collision.empty():
		if new_collision.collider is TileMap:
			queue_free()
			return
		# Might be faulty. Test thoroughly
		if new_collision == collision:
			queue_free()
			return
		collision = new_collision
	if current_lifetime > max_lifetime:
		queue_free()
		return
		
func queue_free():
	emit_signal("deletion")
	.queue_free()