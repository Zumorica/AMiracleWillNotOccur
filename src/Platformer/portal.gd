extends Area2D

var is_triggered = false
var portal_entered = false

func _ready():
	set_physics_process(false)

func trigger():
	if not is_triggered:
		$AnimationPlayer.play("Animation")
		set_physics_process(true)
		is_triggered = true

func portal_enter():
	if not portal_entered:
		portal_entered = true
		miracle.platformer_level = 1
		miracle.platformer_respawn_coordinates = Vector2(96, 1312)
		miracle.game_root.player.can_move = false
		miracle.game_root.player.can_restart = false
		miracle.load_scene("res://src/Platformer/Platformer_Bernkastel.tscn")

func _physics_process(delta):
	for body in get_overlapping_bodies():
		if body is KinematicBody2D:
			if body.has_method("die"):
				portal_enter()
