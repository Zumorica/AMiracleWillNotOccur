extends Area2D


export(float) var velocity = -750
export(float) var lifetime_after_trigger = 10
var triggered = false

func trigger():
	triggered = true
	if lifetime_after_trigger != -1:
		yield(get_tree().create_timer(lifetime_after_trigger), "timeout")
		queue_free()

func _process(delta):
	if triggered:
		move_local_y(velocity * delta)
	for body in get_overlapping_bodies():
		if body.has_method("die"):
			body.die()