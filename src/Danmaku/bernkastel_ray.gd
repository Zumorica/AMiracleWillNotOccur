extends KinematicBody2D

var is_deadly = true

func _ready():
	set_process(true)
	
func _process(delta):
	$Foreground.modulate = get_parent().foreground_color
	$Background.modulate = get_parent().background_color
	$Particles2D.modulate = get_parent().foreground_color
	$Particles2D2.modulate = get_parent().foreground_color