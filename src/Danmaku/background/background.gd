extends Node2D

var speed = 5 setget get_speed,set_speed
export(NodePath) var camera

func _ready():
	camera = get_node(camera)
	set_physics_process(true)

func _physics_process(delta):
	camera.move_local_y(speed)

func get_speed():
	return speed

func set_speed(num):
	assert typeof(num) == TYPE_INT
	speed = num

func set_shader_enabled(enabled=true):
	$ParallaxBackground/ParallaxLayer/Sprite.material.set_shader_param("enable_glitch", enabled)

func set_shader_params(block_thresh=0.2, block_dist=0.35,  line_thresh=0.25):
	$ParallaxBackground/ParallaxLayer/Sprite.material.set_shader_param("block_thresh_modifier", block_thresh)
	$ParallaxBackground/ParallaxLayer/Sprite.material.set_shader_param("block_dist_modifier", block_dist)
	$ParallaxBackground/ParallaxLayer/Sprite.material.set_shader_param("line_thresh_modifier", line_thresh)