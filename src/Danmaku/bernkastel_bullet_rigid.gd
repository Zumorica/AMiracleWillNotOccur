extends RigidBody2D

export(int) var direction = 360
#export(Vector2) var velocity = Vector2(8, 8)
export(Vector2) var acceleration = Vector2(0, 0)
#export(int) var angular_velocity = 0
export(bool) var rotate_sprite_according_to_direction = true

func _ready():
	linear_velocity = Vector2(miracle.costable[int(round(direction)) % 360], miracle.sintable[int(round(direction)) % 360]) * linear_velocity
	add_to_group("bernkastel_bullets")
	set_fixed_process(true)

func _integrate_forces(state):
	var delta = 1
	if rotate_sprite_according_to_direction:
		rotation_deg = direction
	#linear_velocity = Vector2((linear_velocity.x + (acceleration.x * delta)), (linear_velocity.y + (acceleration.y * delta)))
	#move(Vector2(miracle.costable[int(round(direction)) % 360], miracle.sintable[int(round(direction)) % 360]) * linear_velocity * delta)
	if not get_viewport_rect().has_point(position):
		#velocity = Vector2()
		queue_free()