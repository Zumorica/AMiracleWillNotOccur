extends KinematicBody2D

const GRAVITY = 150000000
var velocity = Vector2(0, 0)

var time_before_deleting = 5
var has_exploded = false

var timer

func _ready():
	randomize()
	if randf() < 0.25:
		$Wry.play()

func explode():
	if not has_exploded:
		has_exploded = true
		if time_before_deleting != false:
			timer = get_tree().create_timer(time_before_deleting)
			timer.connect("timeout", self, "queue_free")
			$Particles2D.lifetime = timer.get_time_left()
		$Sprite.modulate.a = 0
		$Particles2D.emitting = true
		$Crash.play()

func _fixed_process(delta):
	if has_exploded:
		for body in $Area2D.get_overlapping_bodies():
			if body.has_method("die"):
				body.die()
	velocity.y += GRAVITY * pow(delta, 2)
	var old_position = position
	var collision = move(velocity * delta)
	position = old_position
	velocity = move_and_slide(velocity * delta, Vector2(0, -1))
	if not collision.empty():
		if collision.collider is TileMap:
			explode()
		elif collision.collider.has_method("die"):
			collision.collider.die()