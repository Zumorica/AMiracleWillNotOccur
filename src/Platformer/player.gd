extends KinematicBody2D

export(PackedScene) var head
export(PackedScene) var arm
export(PackedScene) var leg
export(PackedScene) var blood
export(PackedScene) var bullet
export(NodePath) var gameover
export(NodePath) var bgm
export(NodePath) var save_dialog

const GRAVITY = 1000.0
const FLOOR_ANGLE_TOLERANCE = 40
const WALK_FORCE = 2000
const WALK_MIN_SPEED = 200
const WALK_MAX_SPEED = 200
const STOP_FORCE = 2500
const JUMP_SPEED = 200
const JUMP_SPEED_HOLD = 100
const MAX_JUMP_FORCE = 3

const SLIDE_STOP_VELOCITY = 2.0
const SLIDE_STOP_MIN_TRAVEL = 2.0

var velocity = Vector2()
var on_air_time = 100
var jumps = 2
var jumping_force = MAX_JUMP_FORCE
var is_jumping = false
var is_sliding = false
var is_dead = false
var can_shoot = true
var can_move = true

var can_restart = true

var direction = 1
var bullet_count = 0

var collision = {}

func _ready():
	position = miracle.platformer_respawn_coordinates
	miracle.game_root.player = self
	if typeof(bgm) == TYPE_NODE_PATH:
		bgm = get_node(bgm)
	if typeof(save_dialog) == TYPE_NODE_PATH:
		save_dialog = get_node(save_dialog)
		save_dialog.connect("about_to_show", self, "on_popup_show")
		save_dialog.connect("popup_hide", self, "on_popup_hide")

func on_popup_show():
	can_restart = false

func on_popup_hide():
	can_restart = true

func slide_anim(flip):
	if $Sprite.flip_h != flip:
		is_sliding = true
		$Sprite.stop()
		$Sprite.play("sliding")
		yield($Sprite, "animation_finished")
		is_sliding = false
		$Sprite.flip_h = flip
		if not flip:
			direction = 1
		else:
			direction = -1

func shoot():
	if (can_shoot and bullet and bullet_count < 3) and not is_dead:
		var new_bullet = bullet.instance()
		new_bullet.player = self
		bullet_count += 1
		new_bullet.direction = direction
		if direction == 1:
			new_bullet.position = position + Vector2(26, 3)
		else:
			new_bullet.position = position - Vector2(26, -3)
		$ShootPistol.play()
		new_bullet.connect("deletion", self, "decrease_bullet_count")
		get_parent().add_child(new_bullet)
		if can_shoot == true:
			can_shoot = false
			yield(get_tree().create_timer(0.0625), "timeout")
			can_shoot = true

func decrease_bullet_count():
	bullet_count -= 1

func die():
	if not is_dead:
		randomize()
		if randf() > 0.5:
			$ahaha.play()
		is_dead = true
		miracle.platformer_deaths += 1
		var b = blood.instance()
		var h = head.instance()
		var a = arm.instance()
		var a2 = arm.instance()
		var l = leg.instance()
		var l2 = leg.instance()
		a2.linear_velocity.x = rand_range(-50, 50)
		l2.linear_velocity.x = rand_range(-50, 50)
		$Sprite.play("ded")
		if typeof(bgm) == TYPE_NODE_PATH:
			bgm = get_node(bgm)
		bgm.stop()
		$Gameover.play()
		get_parent().add_child(b, true)
		get_parent().add_child(h, true)
		get_parent().add_child(a, true)
		get_parent().add_child(a2, true)
		get_parent().add_child(l, true)
		get_parent().add_child(l2, true)
		b.position = position
		h.position = position
		a.position = position
		a2.position = position
		l.position = position
		l2.position = position
		$Sprite.flip_h = false
		yield(get_tree().create_timer(2), "timeout")
		get_node(gameover).show()

func _fixed_process(delta):
	var force = Vector2(0, GRAVITY)

	var walk_left = Input.is_action_pressed("platformer_left")
	var walk_right = Input.is_action_pressed("platformer_right")
	var jump = Input.is_action_just_pressed("platformer_jump")
	var jump_pressed = Input.is_action_pressed("platformer_jump")
	var is_restart_pressed = Input.is_action_pressed("platformer_restart")

	var stop = true
	if not can_move:
		walk_left = false
		walk_right = false
		jump = false
		jump_pressed = false

	if is_restart_pressed:
		if can_restart:
			if miracle.platformer_level == 0:
				miracle.load_scene("res://src/Platformer/platformer.tscn")
			elif miracle.platformer_level == 1:
				miracle.load_scene("res://src/Platformer/Platformer_Bernkastel.tscn")

	if (walk_left) and not is_dead:
		if (velocity.x <= WALK_MIN_SPEED and velocity.x > -WALK_MAX_SPEED):
			if force.x > 0:
				force.x = 0
			force.x = -WALK_FORCE
			stop = false
			slide_anim(true)

	elif (walk_right) and not is_dead:
		if (velocity.x >= -WALK_MIN_SPEED and velocity.x < WALK_MAX_SPEED):
			if force.x < 0:
				force.x = 0
			force.x = WALK_FORCE
			stop = false
			slide_anim(false)

	if (stop):
		var vsign = sign(velocity.x)
		var vlen = abs(velocity.x)
		vlen -= STOP_FORCE*delta
		if (vlen < 0):
			vlen = 0

		velocity.x = vlen*vsign

	velocity += force*delta

	#velocity = move_and_slide(velocity,Vector2(0,-1))
	# We have to do this fucking bullshit until I find a better way to get collisions. god fucking dammit
	var old_pos = position
	collision = move(velocity)
	position = old_pos
	velocity = move_and_slide(velocity,Vector2(0,-1))
	if not collision.empty():
		if not collision.collider is TileMap and collision.position.distance_to(position) < 30:
			if collision.collider.get("is_deadly"):
				if collision.collider.is_deadly:
					die()

	if is_on_floor() and not is_dead:
		jumps = 2
		if stop and not is_sliding and not (walk_right or walk_left):
			$Sprite.play("idling")
		elif not is_sliding and (walk_right or walk_left):
			$Sprite.play("walking")

	if velocity.y > 0 and not is_dead:
		# Falling
		$Sprite.play("falling")
		is_jumping = false


	if jump and jumps and not is_dead:
		velocity.y = -JUMP_SPEED
		$Sprite.play("jumping")
		if jumps == 2:
			$Jump.play()
		if jumps == 1:
			$DoubleJump.play()
		jumps -= 1
		jumping_force = MAX_JUMP_FORCE
		is_jumping = true

	if not jump and jump_pressed and jumping_force and not is_dead:
		velocity.y += -JUMP_SPEED_HOLD
		jumping_force -= 1

	if Input.is_action_just_pressed("platformer_shoot"):
		shoot()
