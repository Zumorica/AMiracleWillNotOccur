extends Node2D

var speed = 5 setget get_speed,set_speed
export(NodePath) var camera

func _ready():
	camera = get_node(camera)
	set_fixed_process(true)

func _fixed_process(delta):
	camera.move_local_y(speed)

func get_speed():
	return speed

func set_speed(num):
	assert typeof(num) == TYPE_INT
	speed = num