extends Node2D

export(NodePath) var bernkastel

onready var base_bullet = load("res://src/Danmaku/bernkastel_bullet.tscn")
onready var yellow_star_bullet = load("res://src/Danmaku/bernkastel_star_bullet.tscn")
onready var beam = load("res://src/Danmaku/bernkastel_beam.tscn")
onready var spike = load("res://src/Platformer/spike.tscn")
onready var spinning = load("res://src/Platformer/cat_attack/Spinning.tscn")
onready var scythe = load("res://src/Platformer/cat_attack/Scythe.tscn")

signal pattern_end(group_name)
signal pattern_created(group_name)


func _ready():
	bernkastel = get_node(bernkastel)

func create_bullet(arg1={"position" : Vector2(0, 0), "direction" : 0, \
					    "velocity" : Vector2(0, 0), "acceleration" : Vector2(0, 0),
						"angular_velocity" : 0, "foreground_color" : Color8(163, 0, 255, 255),\
					    "background_color" : Color8(255, 255, 255, 255)}, \
				   packed_scene=base_bullet):
	var new_bullet = packed_scene.instance()
	for argument in arg1:
		new_bullet.set(argument, arg1[argument])
	return new_bullet

func create_beam(arg1={"position" : Vector2(0,0), "direction" : 0, 
					  "time_before_deleting" : 30, "rays" : 30, \
					  "angular_velocity" : 0, "time_between_rays" : 0.15, \
					  "time_before_rays" : 0, "velocity" : Vector2(0, 0), \
					  "acceleration" : Vector2(0, 0), "foreground_color" : Color8(163, 0, 255, 255),\
					  "background_color" : Color8(255, 255, 255, 255)}, packed_scene=beam):
	var new_beam = packed_scene.instance()
	for argument in arg1:
		new_beam.set(argument, arg1[argument])
	return new_beam

func create_spike(arg1={"position" : Vector2(0, 0), "rotation_degrees" : 0,
						"velocity" : -750, "lifetime_after_trigger" : 15}, \
				  packed_scene=spike):
	var new_spike = packed_scene.instance()
	for argument in arg1:
		new_spike.set(argument, arg1[argument])
	return new_spike
	
func create_spinning(arg1={"position" : Vector2(0, 0), "velocity" : Vector2(0, -100), "time_before_deleting" : 15}, packed_scene=spinning):
	var new_spinning = packed_scene.instance()
	for argument in arg1:
		new_spinning.set(argument, arg1[argument])
	return new_spinning

func create_scythe(arg1={"position" : Vector2(0, 600), "mas_offset" : 300, "velocity" : Vector2(800, 800), 
						 "time_before_deleting" : 15, "amplitude" : 500, "angular_frequency" : 2.5, "mas_enabled" : true}, packed_scene=scythe):
	var new_scythe = packed_scene.instance()
	for argument in arg1:
		new_scythe.set(argument, arg1[argument])
	return new_scythe

func scythe(arg1={"position" : Vector2(0, 600), "mas_offset" : 300, "velocity" : Vector2(800, 800), 
				  "time_before_deleting" : 15, "amplitude" : 500, "angular_frequency" : 2.5, "mas_enabled" : true},
			arg2={"group" : null}, packed_scene=scythe):
	var scythe = create_scythe(arg1, packed_scene)
	if arg2.has("group"):
		if typeof(arg2.group) == TYPE_STRING:
			scythe.add_to_group(arg2.group)
	add_child(scythe)

func spinning(arg1={"position" : Vector2(0, 0), "velocity" : Vector2(0, -100), "time_before_deleting" : 15}, 
			  arg2={"group" : null}, packed_scene=spinning):
	var spinner = create_spinning(arg1, packed_scene)
	if arg2.has("group"):
		if typeof(arg2.group) == TYPE_STRING:
			spinner.add_to_group(arg2.group)
	add_child(spinner)
	
func spike(arg1={"position" : Vector2(0, 0), "rotation_degrees" : 0,
						"velocity" : -750, "lifetime_after_trigger" : 15}, \
		   arg2={"time_before_trigger" : 5, "group" : null}, packed_scene=spike):
	var new_spike = create_spike(arg1, packed_scene)
	add_child(new_spike)
	if arg2.has("time_before_trigger"):
		if typeof(arg2.time_before_trigger) == TYPE_INT:
			get_tree().create_timer(arg2.time_before_trigger).connect("timeout", new_spike, "trigger")
		else:
			new_spike.trigger()
	if arg2.has("group"):
		if typeof(arg2.group) == TYPE_STRING:
			new_spike.add_to_group(arg2.group)
	return new_spike

func line(arg1={"position" : Vector2(0, 0), "direction" : 0, \
			    "velocity" : Vector2(0, 0), "acceleration" : Vector2(0, 0),
			    "angular_velocity" : 0}, \
		  arg2={"bullets" : 30, "delay_between_bullets" : 0.1, "bernkastel_parent" : false, \
				"random_color" : false}, \
		  packed_scene=base_bullet):
	var group = "line-%s"%OS.get_unix_time()
	var bullets = 30
	var delay_between_bullets = 0.1
	var bernkastel_parent = false
	if arg2.has("bullets"):
		bullets = arg2.bullets
	if arg2.has("delay_between_bullets"):
		delay_between_bullets = arg2.delay_between_bullets
	if arg2.has("group"):
		group = arg2.group
	if arg2.has("bernkastel_parent"):
		bernkastel_parent = arg2.bernkastel_parent
	emit_signal("pattern_created", group)
	for i in range(bullets):
		var new_bullet = create_bullet(arg1, packed_scene)
		new_bullet.add_to_group(group)
		if arg2.has("random_color"):
			if arg2.random_color:
				randomize()
				new_bullet.foreground_color = Color(randf(), randf(), randf(), 1.0)
		if bernkastel_parent:
			bernkastel.add_child(new_bullet)
		else:
			add_child(new_bullet)
		yield(get_tree().create_timer(delay_between_bullets), "timeout")
	emit_signal("pattern_end")
	return group
	
func circle(arg1={"position" : Vector2(0, 0), "direction" : 0, \
			      "velocity" : Vector2(0, 0), "acceleration" : Vector2(0, 0),
			      "angular_velocity" : 0},\
			arg2={"bullets" : 40, "bullet_step" : 9, "initial_step" : 0, "bernkastel_parent" : false, \
				  "random_color" : false},\
			packed_scene=base_bullet):
	var group = "circle-%s" %(OS.get_unix_time())
	var a = 0
	var bullets = 40
	var bullet_step = 9
	var bernkastel_parent = false
	if arg2.has("bullets"):
		bullets = arg2.bullets
	if arg2.has("bullet_step"):
		bullet_step = arg2.bullet_step
	if arg2.has("initial_step"):
		a = arg2.initial_step
	if arg2.has("group"):
		group = arg2.group
	if arg2.has("bernkastel_parent"):
		bernkastel_parent = arg2.bernkastel_parent
	emit_signal("pattern_created", group)
	for i in range(bullets):
		a += bullet_step
		var new_bullet = create_bullet(arg1, packed_scene)
		new_bullet.add_to_group(group)
		new_bullet.direction = a
		if arg2.has("random_color"):
			if arg2.random_color:
				randomize()
				new_bullet.foreground_color = Color(randf(), randf(), randf(), 1.0)
		if bernkastel_parent:
			bernkastel.add_child(new_bullet)
		else:
			add_child(new_bullet)
	return group

func multibeam(arg1={"position" : Vector2(0,0), "direction" : 0, 
					  "time_before_deleting" : 30, "rays" : 30, \
					  "angular_velocity" : 0, "time_between_rays" : 0.15, \
					  "time_before_rays" : 0, "velocity" : Vector2(0, 0), \
					  "acceleration" : Vector2(0, 0), "foreground_color" : Color8(163, 0, 255, 255),\
					  "background_color" : Color8(255, 255, 255, 255)},\
			   arg2={"beams" : 1, "beam_step" : 0, "beam_step_start" : 0, "bernkastel_parent" : false, \
					 "random_color" : false},\
			   packed_scene=beam):
	var group = "multibeam-%s" %(OS.get_unix_time())
	var beams = 1
	var beam_step = 0
	var time_before_deleting = 30
	var a = 0
	var bernkastel_parent = false
	if arg2.has("beams"):
		beams = arg2.beams
	if arg2.has("beam_step"):
		beam_step = arg2.beam_step
	if arg2.has("group"):
		group = arg2.group
	if arg2.has("beam_step_start"):
		a = arg2.beam_step_start
	if arg2.has("bernkastel_parent"):
		bernkastel_parent = arg2.bernkastel_parent
#	if arg1.has("time_before_deleting"):
#		time_before_deleting = arg1.time_before_deleting
#	var timer = Timer.new()
#	timer.one_shot = true
#	timer.wait_time = time_before_deleting
#	add_child(timer)
#	timer.start()
	emit_signal("pattern_created", group)
	for i in range(beams):
		arg1["direction"] = a
		a += beam_step
		var new_beam = create_beam(arg1, packed_scene)
		new_beam.add_to_group(group)
		if arg2.has("random_color"):
			if arg2.random_color:
				randomize()
				new_beam.foreground_color = Color(randf(), randf(), randf(), 1.0)
		if bernkastel_parent:
			bernkastel.add_child(new_beam)
		else:
			add_child(new_beam)
#	yield(timer, "timeout")
#	timer.queue_free()
	emit_signal("pattern_end", group)
	return group

func spiral(arg1={"position" : Vector2(0, 0), "direction" : 0, \
				  "velocity" : Vector2(0, 0), "acceleration" : Vector2(0, 0),
				  "angular_velocity" : 0}, \
			arg2={"spirals" : 1, "spiral_step" : 0, \
				  "initial_step" : 0, "bullet_step" : 8,
				  "time_between_bullets" : 0.1, "duration" : 5, "bernkastel_parent" : false, \
				  "random_color" : false},
			packed_scene=base_bullet):
	var group = "spiral-%s" %(OS.get_unix_time())
	var a = 0
	var spirals = 1
	var spiral_step = 0
	var bullet_step = 8
	var time_between_bullets = 0.1
	var duration = 5
	var bernkastel_parent = false
	if arg2.has("initial_step"):
		a = arg2.initial_step
	if arg2.has("spirals"):
		spirals = arg2.spirals
	if arg2.has("spiral_step"):
		spiral_step = arg2.spiral_step
	if arg2.has("time_between_bullets"):
		time_between_bullets = arg2.time_between_bullets
	if arg2.has("duration"):
		duration = arg2.duration
	if arg2.has("group"):
		group = arg2.group
	if arg2.has("bernkastel_parent"):
		bernkastel_parent = arg2.bernkastel_parent
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	add_child(timer)
	timer.start()
	emit_signal("pattern_created", group)
	while timer.get_time_left():
		a += bullet_step
		for i in range(spirals):
			var new_bullet = create_bullet(arg1, packed_scene)
			new_bullet.add_to_group(group)
			new_bullet.direction = a + (i * spiral_step)
			if arg2.has("random_color"):
				if arg2.random_color:
					randomize()
					new_bullet.foreground_color = Color(randf(), randf(), randf(), 1.0)
			if bernkastel_parent:
				bernkastel.add_child(new_bullet)
			else:
				add_child(new_bullet)
		yield(get_tree().create_timer(time_between_bullets), "timeout")
	timer.queue_free()
	emit_signal("pattern_end", group)
	return group

func random_bullets(arg1={"position" : Vector2(0, 0), "direction" : 0, \
					    "velocity" : Vector2(0, 0), "acceleration" : Vector2(0, 0),
						"angular_velocity" : 0}, \
					arg2={"duration" : 5, "direction_vector" : Vector2(0, 360), \
						  "time_between_bullets" : 0.1, "random_color" : false, \
						  "bernkastel_parent" : false}, \
					packed_scene=base_bullet):
	var group = "randombullets-%s" %(OS.get_unix_time())
	var duration = 5
	var direction_vector = Vector2(0, 360)
	var time_between_bullets = 0.1
	var bernkastel_parent = false
	if arg2.has("duration"):
		duration = arg2.duration
	if arg2.has("direction_vector"):
		direction_vector = arg2.direction_vector
	if arg2.has("time_between_bullets"):
		time_between_bullets = arg2.time_between_bullets
	if arg2.has("group"):
		group = arg2.group
	if arg2.has("bernkastel_parent"):
		bernkastel_parent = arg2.bernkastel_parent
	var timer = Timer.new()
	timer.one_shot = true
	timer.wait_time = duration
	add_child(timer)
	timer.start()
	emit_signal("pattern_created", group)
	while timer.get_time_left():
		randomize()
		arg1.direction = rand_range(direction_vector.x, direction_vector.y)
		var new_bullet = create_bullet(arg1, packed_scene)
		new_bullet.add_to_group(group)
		if arg2.has("random_color"):
			if arg2.random_color:
				randomize()
				new_bullet.foreground_color = Color(randf(), randf(), randf(), 1.0)
		if bernkastel_parent:
			bernkastel.add_child(new_bullet)
		else:
			add_child(new_bullet)
		yield(get_tree().create_timer(time_between_bullets), "timeout")
	timer.queue_free()
	emit_signal("pattern_end", group)
	return group
