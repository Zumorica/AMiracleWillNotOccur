extends KinematicBody2D

var is_deadly = true

export(float) var direction = 360
export(Vector2) var velocity = Vector2(8, 8)
export(Vector2) var acceleration = Vector2(0, 0)
export(float) var angular_velocity = 0
export(bool) var rotate_sprite_according_to_direction = true
export(Color) var foreground_color = Color8(163, 0, 255, 255) setget set_foreground_color
export(Color) var background_color = Color8(255, 255, 255, 255) setget set_background_color
export(bool) var is_player_bullet = false
export(float) var direction_affects_velocity = true
export(bool) var destroy_if_offscreen = true
var can_be_destroyed = true

func can_be_bombed():
	return can_be_destroyed

func _ready():
	if not is_player_bullet:
		add_to_group("bernkastel_bullets")
		$Foreground.modulate = foreground_color
		$Background.modulate = background_color
	else:
		add_to_group("player_bullets")
	set_physics_process(true)

func set_foreground_color(color):
	assert typeof(color) == TYPE_COLOR
	foreground_color = color
	if has_node("Foreground"):
		$Foreground.modulate = color


func set_background_color(color):
	assert typeof(color) == TYPE_COLOR
	background_color = color
	if has_node("Background"):
		$Background.modulate = color

func get_angle_to_player(from=null):
	if from:
		assert typeof(from) == TYPE_VECTOR2
		return rad2deg(miracle.game_root.player.get_position().angle_to_point(from))
	else:
		return rad2deg(miracle.game_root.player.get_position().angle_to_point(get_position()))

func _physics_process(delta):
	if angular_velocity:
		direction += angular_velocity
	if rotate_sprite_according_to_direction:
		rotation_degrees = direction
	velocity = Vector2((velocity.x + (acceleration.x * delta)), (velocity.y + (acceleration.y * delta)))
	if direction_affects_velocity:
		move_and_collide(Vector2(miracle.costable[int(round(direction)) % 360], miracle.sintable[int(round(direction)) % 360]) * velocity * delta)
	else:
		move_and_collide(velocity * delta)
	if (not get_viewport_rect().has_point(position)) and destroy_if_offscreen:
		velocity = Vector2()
		queue_free()
