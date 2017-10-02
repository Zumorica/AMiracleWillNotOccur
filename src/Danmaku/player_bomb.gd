extends Area2D

export(int) var time_alive = 4

export(PackedScene) var point
export(Script) var beam
export(Script) var ray

func _ready():
	set_fixed_process(true)
	yield(get_tree().create_timer(time_alive), "timeout")
	get_parent().is_invincible = false
	queue_free()
	
func _fixed_process(dt):
	get_tree().set_group("point", "follow_player", true)
	get_tree().set_group("power", "follow_player", true)
	if get_overlapping_bodies().size():
		for body in get_overlapping_bodies():
			if not body is beam and not body is ray:
				if body.has_method("can_be_bombed"):
					if body.can_be_bombed():
						pass
					else:
						return
			else:
				return
			if point:
				var pt = point.instance()
				pt.position = body.position
				get_node("../..").add_child(pt)
			body.queue_free()
	if get_overlapping_areas().size():
		for area in get_overlapping_areas():
			if area.get("health"):
				area.health -= 30