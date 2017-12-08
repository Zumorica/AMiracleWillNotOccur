extends Sprite

var end_vector = Vector2(0, 0)
var is_moving = false
var velocity = Vector2(800, 800)
var amplitude = 500
var angular_frequency = 2.5
var current_rotation = 90
var mas_enabled = true
var mas_offset = 500
var time_before_deleting = 15

func _ready():
	if typeof(time_before_deleting) == TYPE_INT:
		get_tree().create_timer(time_before_deleting).connect("timeout", self, "queue_free")

func move(point):
	mas_enabled = false
	is_moving = true
	end_vector = point

func _physics_process(delta):
	rotation_degrees += velocity.length() * 2 * delta
	if mas_enabled:
		var initial_rotation = current_rotation
		current_rotation += (angular_frequency * delta)
		position.x = (amplitude * cos(current_rotation * delta + initial_rotation)) + mas_offset
	if is_moving:
		if position.distance_to(end_vector) < 100:
			is_moving = false
			emit_signal("stopped_moving")
		else:
			var direction = rad2deg(end_vector.angle_to_point(position))
			flip_h = end_vector.x > position.x
			position += Vector2(cos(deg2rad(direction)), sin(deg2rad(direction))) * velocity * delta
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("die"):
			body.die()
		if body.get("is_player_bullet"):
			body.queue_free()