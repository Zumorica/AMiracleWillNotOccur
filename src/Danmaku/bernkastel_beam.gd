extends KinematicBody2D

var is_deadly = true

export(int) var direction = 360
export(Vector2) var velocity = Vector2(0, 0)
export(Vector2) var acceleration = Vector2(0, 0)
export(float) var angular_velocity = 0
export(float) var time_before_rays = 0
export(float) var time_between_rays = 0.25
export(float) var time_before_deleting = 30.0
export(bool) var rotate_sprite_according_to_direction = true
export(int) var max_rays_created = 30
export(Color) var foreground_color = Color8(163, 0, 255, 255) setget ,set_foreground_color
export(Color) var background_color = Color8(255, 255, 255, 255) setget ,set_background_color
export(float) var direction_affects_velocity = true
export(bool) var destroy_if_offscreen = true

var ray = preload("res://src/Danmaku/bernkastel_ray.tscn")
var rays_created = 0
var being_destroyed = false
		
func _ready():
	add_to_group("bernkastel_bullets")
	$Foreground.modulate = foreground_color
	$Background.modulate = background_color
	$Particles2D.modulate = foreground_color
	set_fixed_process(true)
	if typeof(time_before_deleting) == TYPE_INT:
		get_tree().create_timer(time_before_deleting).connect("timeout", self, "destroy")
	var timer = Timer.new()
	timer.wait_time = time_between_rays
	timer.one_shot = false
	add_child(timer, true)
	timer.connect("timeout", self, "create_new_ray")
	if time_before_rays:
		get_tree().create_timer(time_before_rays).connect("timeout", timer, "start")
	else:
		timer.start()

func set_foreground_color(color):
	assert typeof(color) == TYPE_COLOR
	foreground_color = color
	if has_node("Foreground"):
		$Foreground.modulate = foreground_color
	if has_node("Particles2D"):
		$Particles2D.modulate = foreground_color

func set_background_color(color):
	assert typeof(color) == TYPE_COLOR
	background_color = color
	if has_node("Background"):
		$Background.modulate = background_color

func destroy():
	if not being_destroyed:
		being_destroyed = true
		angular_velocity = 0
		for i in get_children():
			var ob = weakref(i)
			self.self_modulate.a -= self.self_modulate.a / 16
			if ob.get_ref():
				ob.get_ref().queue_free()
			yield(get_tree().create_timer(time_between_rays), "timeout")
		queue_free()

func create_new_ray():
	if rays_created < max_rays_created:
		var new_ray = ray.instance()
		new_ray.position = Vector2(48, -24) * Vector2(rays_created, 1)
		#new_ray.rotation_deg = direction# buggy reee
		new_ray.z = -1
		add_child(new_ray)
		rays_created += 1
	
func _fixed_process(delta):
	direction += angular_velocity
	if rotate_sprite_according_to_direction:
		rotation_deg = direction
	velocity = Vector2((velocity.x + (acceleration.x * delta)), (velocity.y + (acceleration.y * delta)))
	if direction_affects_velocity:
		move(Vector2(miracle.costable[int(round(direction)) % 360], miracle.sintable[int(round(direction)) % 360]) * velocity * delta)
	else:
		move(velocity * delta)
	if not get_viewport_rect().has_point(position) and destroy_if_offscreen:
		velocity = Vector2()
		destroy()