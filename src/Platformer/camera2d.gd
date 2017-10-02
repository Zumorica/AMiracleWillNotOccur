extends Node2D

var last_offset = Vector2()
var active = true

var original_canvas_transform

func _ready():
	var canvas_transform = get_viewport_transform()
	canvas_transform[2] = Vector2(0,0)
	original_canvas_transform = canvas_transform
	get_viewport().set_canvas_transform(canvas_transform)
	set_fixed_process(true)
	
func get_player_stepified(screen_cord = false):
	var size = get_viewport_rect().size
	var stepified = Vector2()
	var parent_pos = get_parent().position
	parent_pos -= (get_viewport_rect().size / 2)
	stepified.x = stepify(parent_pos.x, size.x)
	stepified.y = stepify(parent_pos.y, size.y)
	if screen_cord:
		stepified = stepified / size
	return stepified
	
func reset():
	original_canvas_transform[2] = Vector2(0, 0)
	get_viewport().set_canvas_transform(original_canvas_transform)
	
func _fixed_process(delta):
	if active:
		if last_offset != get_player_stepified():
			var canvas_transform = get_viewport_transform()
			canvas_transform[2] += (last_offset - get_player_stepified())
			get_viewport().set_canvas_transform(canvas_transform)
			last_offset = get_player_stepified()
			prints("NEW ZONE", get_player_stepified(true))