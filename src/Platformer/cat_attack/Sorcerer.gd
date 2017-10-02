extends AnimatedSprite

export(NodePath) var bgm
export(NodePath) var animationplayer
export(NodePath) var bulletmanager
export(NodePath) var player

var end_vector = Vector2(0, 0)
var is_moving = false
var velocity = Vector2(160, 160)

var health = 50
var is_alive = true

signal stopped_moving()

func _ready():
	bgm = get_node(bgm)
	animationplayer = get_node(animationplayer)
	bulletmanager = get_node(bulletmanager)
	player = get_node(player)

func trigger():
	animationplayer.play("FadeMusic")
	$Bell.play()
	yield(get_tree().create_timer(2.25), "timeout")
	$Bell.play()
	move(Vector2(1800, 2176))
	yield(self, "stopped_moving")
	yield(get_tree().create_timer(1.5), "timeout")
	$Meow.play()
	animationplayer.play("FadeMusicIn")
	yield(get_tree().create_timer(3), "timeout")
	if not player.is_dead and is_alive:
		bgm.stream = load("res://res/snd/patchworkchimera.ogg")
		bgm.play()
		var old_db = $Trap.volume_db
		$Trap.volume_db = -15
		for i in [1, 2, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16]:
			bulletmanager.spike({"position" : Vector2(64 * i, 0), "rotation_deg" : 180}, {"time_before_trigger" : 0})
		if miracle.tried_to_run_away:
			bulletmanager.spike({"position" : Vector2(64 * 3, -64 * 2), "rotation_deg" : 180}, {"time_before_trigger" : 0})
		if miracle.tried_to_run_away and miracle.asked_for_mercy:
			bulletmanager.spike({"position" : Vector2(64 * 4, -64 * 2), "rotation_deg" : 180}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(0, 64 * 11), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		$Trap.play()
		$Trap.volume_db = old_db
	move(Vector2(2215, 1900))
	yield(self, "stopped_moving")
	if not player.is_dead and is_alive:
		bulletmanager.multibeam({"position" : Vector2(64 * 8, 64 * 6), "destroy_if_offscreen" : false, "time_before_deleting" : 10, "time_between_rays" : 0.025}, {"group" : "beam1", "beams" : 1, "beam_step_start" : 90, "bernkastel_parent" : false})
		yield(get_tree().create_timer(1.5), "timeout")
		bulletmanager.spike({"position" : Vector2(0, 64*11), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().set_group("beam1", "angular_velocity", -2)
		yield(get_tree().create_timer(0.75), "timeout")
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 12), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 11), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(1), "timeout")
		for i in [8, 9, 10, 11, 12, 14, 15, 16]:
			bulletmanager.spike({"position" : Vector2(64 * i, 64 * 0), "rotation_deg" : 180}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(1), "timeout")
		get_tree().set_group("beam1", "angular_velocity", -0.25)
		yield(get_tree().create_timer(1), "timeout")
		for i in [11, 10, 9, 7]:
			bulletmanager.spike({"position" : Vector2(0, 64*i), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(0.9), "timeout")
		get_tree().set_group("beam1", "angular_velocity", 0)
		bulletmanager.spinning({"position" : Vector2(64 * 8, 64 * -1), "velocity" : Vector2(-100, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 9, 64 * -1), "velocity" : Vector2(100, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 10, 64 * -1), "velocity" : Vector2(-100, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 11, 64 * -1), "velocity" : Vector2(100, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 12, 64 * -1), "velocity" : Vector2(-100, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 13, 64 * -1), "velocity" : Vector2(100, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 17, 64 * 5), "velocity" : Vector2(-200, 0)})
		bulletmanager.spinning({"position" : Vector2(64 * 17, 64 * 6), "velocity" : Vector2(-200, 0)})
		for i in [10, 12, 14, 16]:
			bulletmanager.spike({"position" : Vector2(64 * i, 64 * 0), "rotation_deg" : 180}, {"time_before_trigger" : 0})
		yield(get_tree().create_timer(3), "timeout")
	if not player.is_dead and is_alive:
		$Kusuga.play()
		bulletmanager.scythe({"position" : Vector2(0, 64*11)}, {"group" : "scythe"})
		yield(get_tree().create_timer(1.75), "timeout")
		get_tree().call_group("scythe", "move", Vector2(-500, 64*11))
		yield(get_tree().create_timer(1.75), "timeout")
		move(bulletmanager.position + Vector2(64*2, 64*11))
		yield(self, "stopped_moving")
		flip_h = true
	if not player.is_dead and is_alive:
		for i in range(10):
			bulletmanager.spinning({"position" : Vector2(16 * i, 64 * 12), "velocity" : Vector2(10 * (i+1), -2000)})
		yield(get_tree().create_timer(2), "timeout")
		$Trap.play()
		bulletmanager.spike({"position" : Vector2(-64, 64 * 11), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(-64, 64 * 10), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(-64, 64 * 7.5), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(-64, 64 * 6.5), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		yield(get_tree().create_timer(2), "timeout")
		$Trap.play()
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 11), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 10), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 7.5), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 6.5), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		yield(get_tree().create_timer(6), "timeout")
	if not player.is_dead and is_alive:
		move(Vector2(1900, 2176))
		yield(self, "stopped_moving")
		flip_h = false
		yield(get_tree().create_timer(1.5), "timeout")
		$Meow.play()
		yield(get_tree().create_timer(0.5), "timeout")
		bulletmanager.multibeam({"position" : Vector2(64 * 8, 64 * 8), "destroy_if_offscreen" : false, "time_before_deleting" : 30, "time_between_rays" : 0.025}, {"group" : "beam1", "beams" : 2, "beam_step" : 180, "beam_step_start" : 180, "bernkastel_parent" : false})
		yield(get_tree().create_timer(0.75), "timeout")
		bulletmanager.spike({"position" : Vector2(0, 64 * 11), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(1.25), "timeout")
		bulletmanager.spike({"position" : Vector2(0, 64 * 10), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(0, 64 * 9), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		bulletmanager.spike({"position" : Vector2(0, 64 * 8), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(0.75), "timeout")
		bulletmanager.spike({"position" : Vector2(64 * 17, 64 * 12), "rotation_deg" : 270}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(0.5), "timeout")
		bulletmanager.spike({"position" : Vector2(0, 64 * 10), "rotation_deg" : 90}, {"time_before_trigger" : 0})
		$Trap.play()
		yield(get_tree().create_timer(1), "timeout")
		$Trap.play()
		for i in [2, 4, 6, 8, 10, 12, 14]:
			bulletmanager.spike({"position" : Vector2(64 * i, 0), "rotation_deg" : 180}, {"time_before_trigger" : 0})
		yield(get_tree().create_timer(1.25), "timeout")
		get_tree().set_group("beam1", "angular_velocity", 4.25)
		yield(get_tree().create_timer(0.32), "timeout")
		get_tree().set_group("beam1", "angular_velocity", 0)
		yield(get_tree().create_timer(5), "timeout")
		if not player.is_dead:
			get_tree().call_group("beam1", "destroy")
			get_tree().call_group("cat_defeat", "trigger")
	if not player.is_dead:
		animationplayer.play("FadeMusic")
		if is_alive:
			$Meow.play()
			yield(get_tree().create_timer(1), "timeout")
			$Bell.play()
			move(Vector2(3000, 3000))
			yield(self, "stopped_moving")
			queue_free()
		else:
			$DeadMeow.play()
			$AnimationPlayer.play("Die")
			yield(get_tree().create_timer(7), "timeout")
			move(Vector2(3000, 3000))
			yield(self, "stopped_moving")
			queue_free()

func move(point):
	is_moving = true
	end_vector = point

func _fixed_process(delta):
	if health <= 0:
		is_alive = false
	if is_moving:
		if position.distance_to(end_vector) < 100:
			is_moving = false
			emit_signal("stopped_moving")
		else:
			var direction = rad2deg(end_vector.angle_to_point(position))
			flip_h = end_vector.x > position.x
			position += Vector2(cos(deg2rad(direction)), sin(deg2rad(direction))) * velocity * delta
	for body in $Area2D.get_overlapping_bodies():
		if body.has_method("die"):
			if is_alive:
				body.die()
		if body.get("is_player_bullet"):
			body.queue_free()
			health -= 1
			if is_alive:
				$AnimationPlayer.play("hit")