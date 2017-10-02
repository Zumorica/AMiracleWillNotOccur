extends Area2D

export(Texture) var sprite_off
export(Texture) var sprite_on
export(GDScript) var bullet
export(NodePath) var save_dialog
var can_save = true

func _ready():
	$Sprite.texture = sprite_off

func save(who):
	if can_save:
		miracle.platformer_respawn_coordinates = who.player.position
		$Sprite.texture = sprite_on
		can_save = false
		get_node(save_dialog).popup()
		yield(get_tree().create_timer(2), "timeout")
		$Sprite.texture = sprite_off
		can_save = true

func _process(delta):
	for body in get_overlapping_bodies():
		if body is bullet:
			save(body)