extends Sprite

var bullet = preload("res://src/Danmaku/player_bullet.tscn")
var power = preload("res://src/Danmaku/power.gd")
var point_enemy = preload("res://src/Danmaku/point_enemy.gd")
var point = preload("res://src/Danmaku/point.gd")
export(PackedScene) var bomb_scene

var velocity = Vector2(0, 0)
var speed = 256
var is_invincible = false
var can_move = true
var can_shoot = true
onready var orig_speed = speed 
onready var initial_position = get_position()

func _ready():
	set_physics_process(true)

func die():
	if not is_invincible:
		miracle.game_root.lives -= 1
		miracle.game_root.power = 0
		miracle.game_root.died_during_spellcard = true # We don't really care if there's a spellcard going on or not since each spellcard sets this to false when it starts
		is_invincible = true
		miracle.game_root.get_node("Pichun").play()
		can_move = false
		can_shoot = false
		hide()
		position = initial_position
		yield(get_tree().create_timer(1.5), "timeout")
		can_move = true
		can_shoot = true
		show()
		$InvincibleTimer.start()

func shoot():
	if can_shoot and miracle.game_root.can_control:
		can_shoot = false
		if miracle.game_root.power < 32:
			$ShootTimer.wait_time = 0.3
			$ShootTimer.start()
			var new_bullet = bullet.instance()
			new_bullet.position = get_position() + Vector2(0, 8)
			get_node("../BulletManager").add_child(new_bullet)
		else:
			if miracle.game_root.power < 64:
				$ShootTimer.wait_time = 0.2
				$ShootTimer.start()
				var new_bullet_left = bullet.instance()
				var new_bullet_right = bullet.instance()
				if speed == orig_speed:
					new_bullet_left.position = get_position() + Vector2(-32, 0)
					new_bullet_right.position = get_position() + Vector2(32, 0)
				else:
					new_bullet_left.position = get_position() + Vector2(-8, 0)
					new_bullet_right.position = get_position() + Vector2(8, 0)
				get_node("../BulletManager").add_child(new_bullet_left)
				get_node("../BulletManager").add_child(new_bullet_right)
			else:
				if miracle.game_root.power < 128:
					$ShootTimer.wait_time = 0.15
					$ShootTimer.start()
					var new_bullet_left_1 = bullet.instance()
					var new_bullet_right_1 = bullet.instance()
					if speed == orig_speed:
						new_bullet_left_1.position = get_position() + Vector2(-32, 0)
						new_bullet_right_1.position = get_position() + Vector2(32, 0)
					else:
						new_bullet_left_1.position = get_position() + Vector2(-8, 4)
						new_bullet_right_1.position = get_position() + Vector2(8, 4)
					get_node("../BulletManager").add_child(new_bullet_left_1)
					get_node("../BulletManager").add_child(new_bullet_right_1)
				else:
					if miracle.game_root.power != 255:
						$ShootTimer.wait_time = 0.15
						$ShootTimer.start()
						var new_bullet_left_1 = bullet.instance()
						var new_bullet_right_1 = bullet.instance()
						var new_bullet_left_2 = bullet.instance()
						var new_bullet_right_2 = bullet.instance()
						if speed == orig_speed:
							new_bullet_left_1.position = get_position() + Vector2(-32, 0)
							new_bullet_right_1.position = get_position() + Vector2(32, 0)
						else:
							new_bullet_left_1.position = get_position() + Vector2(-8, 4)
							new_bullet_right_1.position = get_position() + Vector2(8, 4)
						new_bullet_left_2.position = get_position() + Vector2(-48, -4)
						new_bullet_right_2.position = get_position() + Vector2(48, -4)
						get_node("../BulletManager").add_child(new_bullet_left_1)
						get_node("../BulletManager").add_child(new_bullet_right_1)
						get_node("../BulletManager").add_child(new_bullet_left_2)
						get_node("../BulletManager").add_child(new_bullet_right_2)
					else:
						$ShootTimer.wait_time = 0.075
						$ShootTimer.start()
						var new_bullet_left_1 = bullet.instance()
						var new_bullet_right_1 = bullet.instance()
						var new_bullet_left_2 = bullet.instance()
						var new_bullet_right_2 = bullet.instance()
						var new_bullet_left_3 = bullet.instance()
						var new_bullet_right_3 = bullet.instance()
						var new_bullet_center = bullet.instance()
						if speed == orig_speed:
							new_bullet_left_1.position = get_position() + Vector2(-32, 0)
							new_bullet_right_1.position = get_position() + Vector2(32, 0)
						else:
							new_bullet_left_1.position = get_position() + Vector2(-8, 4)
							new_bullet_right_1.position = get_position() + Vector2(8, 4)
						new_bullet_left_2.position = get_position() + Vector2(-48, -4)
						new_bullet_right_2.position = get_position() + Vector2(48, -4)
						new_bullet_left_3.position = get_position() + Vector2(-58, -8)
						new_bullet_right_3.position = get_position() + Vector2(58, -8)
						new_bullet_center.position = get_position() + Vector2(0, 12)
						get_node("../BulletManager").add_child(new_bullet_left_1)
						get_node("../BulletManager").add_child(new_bullet_right_1)
						get_node("../BulletManager").add_child(new_bullet_left_2)
						get_node("../BulletManager").add_child(new_bullet_right_2)
						get_node("../BulletManager").add_child(new_bullet_center)
						get_node("../BulletManager").add_child(new_bullet_left_3)
						get_node("../BulletManager").add_child(new_bullet_right_3)

func bomb():
	if miracle.game_root.bomb > 0 and not is_invincible and miracle.game_root.can_control:
		miracle.game_root.bomb -= 1
		is_invincible = true
		add_child(bomb_scene.instance())

func _physics_process(delta):
	rotate(deg2rad(speed * delta))
	speed = orig_speed
	velocity = Vector2(0, 0)
	if miracle.game_root.game_started and can_move and miracle.game_root.can_control:
		if Input.is_action_pressed("danmaku_shift"):
			speed = orig_speed / 2
		if Input.is_action_pressed("danmaku_up"):
			velocity += Vector2(0, -1)
		if Input.is_action_pressed("danmaku_down"):
			velocity += Vector2(0, 1)
		if Input.is_action_pressed("danmaku_left"):
			velocity += Vector2(-1, 0)
		if Input.is_action_pressed("danmaku_right"):
			velocity += Vector2(1, 0)
		if Input.is_action_pressed("danmaku_shoot"):
			shoot()
		if Input.is_action_pressed("danmaku_bomb"):
			bomb()
	var old_position = position
	position += (velocity * speed) * delta
	if (position.y < 125) and miracle.game_root.power == 255:
		get_tree().set_group("point", "follow_player", true)
		get_tree().set_group("power", "follow_player", true)
	else:
		get_tree().set_group("point", "follow_player", false)
		get_tree().set_group("power", "follow_player", false)
	for body in $CircleArea2D.get_overlapping_bodies():
		if body is power:
			miracle.game_root.power += body.power
			miracle.game_root.score += 500
			body.queue_free()
		elif body is point_enemy or body is point:
			miracle.game_root.score += body.point
			body.queue_free()
			
	if not get_viewport_rect().has_point(position):
		position = old_position
	if not is_invincible:
		self_modulate.a = 1
		if $Area2D.get_overlapping_bodies().size():
			if $Area2D.get_overlapping_bodies()[0].is_deadly:
				die()
				
	else:
		self_modulate.a = 0.5
