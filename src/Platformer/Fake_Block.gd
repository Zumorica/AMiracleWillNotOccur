extends KinematicBody2D

export(Texture) var sprite_default
export(Texture) var sprite_triggered
export(bool) var on_trigger_opacity_change = false
export(float) var opacity = 1

var is_triggered = false

func _ready():
	$Sprite.texture = sprite_default

func trigger():
	if not is_triggered:
		is_triggered = true
		if on_trigger_opacity_change:
			modulate.a = opacity
		else:
			$Sprite.texture = sprite_triggered
		set_collision_layer(0)
		set_collision_mask(0)