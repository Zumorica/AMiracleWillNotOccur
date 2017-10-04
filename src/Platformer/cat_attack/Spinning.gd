extends AnimatedSprite

const GRAVITY = 30000
var velocity = Vector2(0, 0)

var time_before_deleting = 15


func _ready():
	randomize()
	if randf() < 0.25:
		randomize()
		var rand = (randi()%6) + 1
		get_node(str(rand)).play()
	if typeof(time_before_deleting) == TYPE_INT:
		get_tree().create_timer(time_before_deleting).connect("timeout", self, "queue_free")


func _physics_process(delta):
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("die"):
			body.die()
		if body.get("is_player_bullet"):
			body.queue_free()
	velocity.y += GRAVITY * pow(delta, 2)
	move_local_x(velocity.x * delta)
	move_local_y(velocity.y * delta)