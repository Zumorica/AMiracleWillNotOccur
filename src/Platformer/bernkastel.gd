extends AnimatedSprite

export(NodePath) var bulletmanager
var end_vector = Vector2(0, 0)
var is_moving = false
var velocity = Vector2(160, 160)

var is_deadly = true
var is_dead = false

var is_active = true

export(NodePath) var textbox
export(NodePath) var background

var health = 160
onready var maxhealth = health

signal stopped_moving()

func _ready():
	bulletmanager = get_node(bulletmanager)
	textbox = get_node(textbox)
	background = get_node(background)

func trigger():
	miracle.game_root.player.can_move = false
	miracle.game_root.player.can_shoot = false
	miracle.game_root.player.can_restart = false
	yield(get_tree().create_timer(1), "timeout")
	background.get_node("AnimationPlayer").play("SlowlyAppear")
	yield(background.get_node("AnimationPlayer"), "animation_finished")
	move(Vector2(1800, 500))
	yield(self, "stopped_moving")
	yield(get_tree().create_timer(0.5), "timeout")
	textbox.show()
	textbox.set_name("Bernkastel")
	if not miracle.platformer_dialogue_read:
		textbox.add_to_queue("\"Well, you found me. ")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(1.5), "timeout")
		textbox.add_to_queue("Congratulations.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
		textbox.clear()
		textbox.add_to_queue("\"Did you enjoy looking exactly like one of my kitties...? *giggle*\"")
		yield(textbox.label, "on_queue_end")
		$Giggle.play()
		animation = "laugh"
		yield(self, "animation_finished")
		animation = "laugh_reversed"
		yield(self, "animation_finished")
		animation = "idle"
		yield(get_tree().create_timer(4), "timeout")
		textbox.clear()
		textbox.add_to_queue("\"The only reason you are allowed to be here is because of that, you know.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
		textbox.clear()
		if miracle.platformer_deaths == 0:
			textbox.add_to_queue("\"It seems you're really good at this kind of game...\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(4), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"You haven't even died once!\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"But anyway...\"")
			yield(textbox.label, "on_queue_end")
		elif miracle.platformer_deaths <= 10:
			textbox.add_to_queue("\"Ah... You've died a few times, eh?\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"I know very well how dying feels.\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"...I threw you into this hell so I could feel......\n Really feel...\n That I escaped my own hell...\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"...\"")
			yield(textbox.label, "on_queue_end")
		else:
			textbox.add_to_queue("\"You've died %s times...\""%miracle.platformer_deaths)
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"Why don't you just give up?\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			$CrazyLaugh.play()
			yield(get_tree().create_timer(1.25), "timeout")
			textbox.add_to_queue("\"The look on your face is wonderful!\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(3), "timeout")
			textbox.clear()
			textbox.add_to_queue("\"But anyway...\"")
			yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
		textbox.clear()
		textbox.add_to_queue("\"Enough talk. This ends here.\"")
		miracle.platformer_dialogue_read = true
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
	else:
		textbox.clear()
		textbox.add_to_queue("\"You want a rematch...? *giggle*\"")
		yield(textbox.label, "on_queue_end")
		$Giggle.play()
		animation = "laugh"
		yield(self, "animation_finished")
		animation = "laugh_reversed"
		yield(self, "animation_finished")
		animation = "idle"
		yield(get_tree().create_timer(1.5), "timeout")
	textbox.clear()
	textbox.hide()
	miracle.game_root.get_node("BGM").volume_db = 0
	miracle.game_root.get_node("BGM").play()
	miracle.game_root.player.can_move = true
	miracle.game_root.player.can_shoot = true
	miracle.game_root.player.can_restart = true
	miracle.game_root.bern_boss_started = true
	bernkastel_battle()

func bernkastel_battle():
	yield(get_tree().create_timer(2.5), "timeout")
	if not is_dead and not miracle.game_root.player.is_dead:
		move(Vector2(1800, 400))
		yield(self, "stopped_moving")
		animation = "hand_raise2"
		yield(self, "animation_finished")
		animation = "hand_raise_loop"
		for i in range(10):
			bulletmanager.spinning({"position" : Vector2(16 * i, 64 * 12), "velocity" : Vector2(10 * (i+1), -2000)})
		bulletmanager.multibeam({"position" : bulletmanager.to_local(global_position) + Vector2(-100, 0), "time_between_rays" : 0.025}, {"group" : "beam1", "beam_step_start" : 170})
		yield(get_tree().create_timer(2), "timeout")
		get_tree().set_group("beam1", "angular_velocity", -0.2)
		yield(get_tree().create_timer(5), "timeout")
		get_tree().set_group("beam1", "angular_velocity", 2)
		yield(get_tree().create_timer(3.25), "timeout")
		get_tree().set_group("beam1", "angular_velocity", 0)
		yield(get_tree().create_timer(1.25), "timeout")
		get_tree().call_group("beam1", "destroy")
		yield(get_tree().create_timer(0.75), "timeout")
		animation = "idle"
		yield(get_tree().create_timer(0.75), "timeout")

	if not is_dead and not miracle.game_root.player.is_dead:
		bulletmanager.multibeam({"position" : Vector2(64 * 16, 64  * 12), "time_between_rays" : 0.025, "delete_if_offscreen" : false, "time_before_deleting" : false}, {"group" : "beam1", "beam_step_start" : 180})
		velocity *= 2
		move(Vector2(1800, 700))
		yield(self, "stopped_moving")
		$Trap.play()
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 3, 64 * -1)}, {"time_before_trigger" : 0})
		move(Vector2(1100, 700))
		yield(self, "stopped_moving")
		$Trap.play()
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 4, 64 * -1)}, {"time_before_trigger" : 0})
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 3, 64 * -1)}, {"time_before_trigger" : 0})
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 2, 64 * -1)}, {"time_before_trigger" : 0})
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 1, 64 * -1)}, {"time_before_trigger" : 0})
		move(Vector2(1100, 700))
		yield(self, "stopped_moving")
		move(Vector2(1800, 400))
		yield(self, "stopped_moving")
		$Trap.play()
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 4, 64 * -1)}, {"time_before_trigger" : 0})
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 3, 64 * -1)}, {"time_before_trigger" : 0})
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 2, 64 * -1)}, {"time_before_trigger" : 0})
		bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * 1, 64 * -1)}, {"time_before_trigger" : 0})
		move(Vector2(1100, 720))
		yield(self, "stopped_moving")
		move(Vector2(1800, 400))
		yield(self, "stopped_moving")
		velocity /= 2

	if not is_dead and not miracle.game_root.player.is_dead:
		$Laugh.play()
		for i in [12, 9, [7, 6], [8, 12], [9, 11], 10, [8, 12], 11, 10, [6, 9, 10], [7, 12], 8, [9, 11], 10, 11]:
			$Trap.play()
			if typeof(i) == TYPE_INT:
				bulletmanager.spike({"rotation_degrees" : 270, "position" : Vector2(64 * 17, 64 * i)}, {"time_before_trigger" : 0})
			elif typeof(i) == TYPE_ARRAY:
				for s in i:
					bulletmanager.spike({"rotation_degrees" : 270, "position" : Vector2(64 * 17, 64 * s)}, {"time_before_trigger" : 0})
			yield(get_tree().create_timer(0.75), "timeout")
			if typeof(i) == TYPE_INT:
				if i == 10:
					get_tree().call_group("beam1", "destroy")

	if not is_dead and not miracle.game_root.player.is_dead:
		move(Vector2(1800, 400))
		yield(self, "stopped_moving")
		animation = "laugh"
		yield(self, "animation_finished")
		animation = "laugh_loop"
		$CrazyLaugh.play()
		bulletmanager.scythe({"position" : Vector2(-300, 800), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(3000, 800)})
		yield(get_tree().create_timer(1.75), "timeout")
		bulletmanager.scythe({"position" : Vector2(64 * 20, 800), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(-1500, 800)})
		yield(get_tree().create_timer(1.75), "timeout")
		bulletmanager.scythe({"position" : Vector2(64 * -2, 64 * -2), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(64 * 20, 64 * 20)})
		yield(get_tree().create_timer(1.75), "timeout")
		bulletmanager.scythe({"position" : Vector2(64 * 20, 64 * -2), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(64 * -20, 64 * 20)})
		yield(get_tree().create_timer(1.75), "timeout")
		bulletmanager.scythe({"position" : Vector2(64 * -2, 64 * 8), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(64 * 20, 64 * 8)})
		yield(get_tree().create_timer(1.75), "timeout")
		bulletmanager.scythe({"position" : Vector2(64 * 20, 64 * 8), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(64 * -20, 64 * 8)})
		bulletmanager.scythe({"position" : Vector2(-300, 800), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(3000, 800)})
		yield(get_tree().create_timer(2), "timeout")
		$Kusuga.play()
		bulletmanager.scythe({"position" : Vector2(64 * -2, 64 * 19), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(64 * 20, 64 * -3)})
		yield(get_tree().create_timer(1.75), "timeout")
		bulletmanager.scythe({"position" : Vector2(64 * 20, 64 * 20), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(64 * -20, 64 * -20)})

	if not is_dead and not miracle.game_root.player.is_dead:
		animation = "laugh_reversed"
		yield(self, "animation_finished")
		animation = "idle"
		yield(get_tree().create_timer(1), "timeout")
		animation = "spin_prior_loop"
		yield(self, "animation_finished")
		animation = "spin_loop"
		yield(get_tree().create_timer(0.25), "timeout")
		for i in [1, 4, 7, "scythe", 10, 13, 16]:
			if typeof(i) == TYPE_INT:
				bulletmanager.spinning({"position" : Vector2(64 * i, 64 * -1), "velocity" : Vector2(100, 100)})
			else:
				$CrazyLaugh.play()
				bulletmanager.scythe({"position" : Vector2(-300, 800), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(3000, 800)})
			yield(get_tree().create_timer(0.75), "timeout")
		for i in [2, "scythe", 5, 8, 11, 14, 17]:
			if typeof(i) == TYPE_INT:
				bulletmanager.spinning({"position" : Vector2(64 * i, 64 * -1), "velocity" : Vector2(-100, 100)})
			else:
				$CrazyLaugh.play()
				bulletmanager.scythe({"position" : Vector2(64 * 20, 800), "mas_enabled" : false, "is_moving" : true, "end_vector" : Vector2(-1500, 800)})
			yield(get_tree().create_timer(0.75), "timeout")

	if not is_dead and not miracle.game_root.player.is_dead:
		$Laugh.play()
		move(Vector2(1800, 400))
		for i in [12, [1, 3, 4], [7, 6], [8, 13, 12, 1, 4, 5], [9, 11, 4, 6, 5, 7, 1, 16, 15], 14, 10, [8, 12, 10, 6, 7, 16], 11, [10, 16], [6, 9, 10], [7, 12], 8, [9, 11], 10, 11]:
			$Trap.play()
			if typeof(i) == TYPE_INT:
				bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * i, 64 * -1)}, {"time_before_trigger" : 0})
			elif typeof(i) == TYPE_ARRAY:
				for s in i:
					bulletmanager.spike({"rotation_degrees" : 180, "position" : Vector2(64 * s, 64 * -1)}, {"time_before_trigger" : 0})
			yield(get_tree().create_timer(1.25), "timeout")

	if is_dead:
		if not miracle.game_root.player.is_dead:
			miracle.game_root.player.can_move = false
			miracle.game_root.player.can_shoot = false
			miracle.game_root.player.can_restart = false
			textbox.show()
			textbox.set_name("Bernkastel")
			miracle.game_root.get_node("BGM").volume_db = -50
			yield(get_tree().create_timer(1.5), "timeout")
			miracle.game_root.get_node("BGM").stop()
			if not miracle.asked_for_mercy and not miracle.asked_for_mercy_twice and not miracle.tried_to_run_away\
			and miracle.defeated_bernkastel_danmaku and miracle.platformer_deaths == 0 and miracle.defeated_bernkastel_rpg:
				textbox.clear()
				textbox.add_to_queue("\"I have been utterly defeated...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I... understand it now...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"A miracle cannot occur... And this is not a miracle.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"This is fate...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I have lost against fate once again......\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(10), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I will grant your wish as we agreed.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"However...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I would like to keep in contact with you.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"You've proven yourself to be a very interesting\nhuman... Perhaps we could be what you mortals call 'friends'.\"")
				yield(textbox.label, "on_queue_end")
				$Giggle.play()
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"So, until next time...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.set_name("")
				textbox.clear()
				textbox.set_color(Color(1, 0, 0, 1))
				$RedTruth.play()
				textbox.add_text("TRUE ENDING")
				miracle.ending = miracle.ending_score.true_ending
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
			elif not miracle.asked_for_mercy and not miracle.asked_for_mercy_twice and not miracle.tried_to_run_away\
			and miracle.defeated_bernkastel_danmaku and miracle.platformer_deaths <= 10 and miracle.defeated_bernkastel_rpg:
				textbox.add_to_queue("\"I have been defeated...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I understand it now.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"A miracle still cannot occur...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"This is fate.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(10), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I will honor our agreement and grant your wish...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.set_name("")
				textbox.clear()
				textbox.set_color(Color(1, 0, 0, 1))
				$RedTruth.play()
				textbox.add_text("GOOD ENDING")
				miracle.ending = miracle.ending_score.good_ending
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
			elif not miracle.asked_for_mercy and not miracle.asked_for_mercy_twice and not miracle.tried_to_run_away\
			and not miracle.defeated_bernkastel_danmaku and miracle.platformer_deaths <= 10:
				textbox.add_to_queue("\"I have been defeated... By you?\nBy the one who only evaded my attacks during our second fight?!\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I felt slightly humilliated... \nWere you trying to spare my life?! Ugh.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I will honor our agreement and grant your wish...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.set_name("")
				textbox.clear()
				textbox.set_color(Color(1, 0, 0, 1))
				$RedTruth.play()
				textbox.add_text("...GOOD ENDING?")
				miracle.ending = miracle.ending_score.good_ending
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
			elif not miracle.asked_for_mercy and not miracle.asked_for_mercy_twice and not miracle.tried_to_run_away and not miracle.defeated_bernkastel_rpg:
				textbox.add_to_queue("\"I have been defeated... By you!\nEven though you're not good at any game!\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I understand it now.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"This wasn't fate...\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"You were just lucky.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(10), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I will honor our agreement and grant your wish...\nHowever, I'll have you know that there's no glory in your win.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.set_name("")
				textbox.clear()
				textbox.set_color(Color(1, 0, 0, 1))
				$RedTruth.play()
				textbox.add_text("NEUTRAL ENDING")
				miracle.ending = miracle.ending_score.neutral_ending
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
			elif miracle.asked_for_mercy and not miracle.asked_for_mercy_twice and not miracle.tried_to_run_away:
				textbox.add_to_queue("\"I have been defeated... By you?!\nThe one who asked for mercy during our first fight?!\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"There's no glory in your victory.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"In fact, I think I can't call this a victory.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"You stupid piece.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(10), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I will NOT honor our agreement...\nInstead, I'll have you entertain me for a thousand years.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.set_name("")
				textbox.clear()
				textbox.set_color(Color(1, 0, 0, 1))
				$RedTruth.play()
				textbox.add_text("...BAD ENDING?")
				miracle.ending = miracle.ending_score.bad_ending
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
			else:
				textbox.add_to_queue("\"I have been defeated... By you?!\nThe one who asked for mercy during our first fight?!\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"There's no glory in your victory.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"In fact, I think I can't call this a victory.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"You stupid piece.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(10), "timeout")
				textbox.clear()
				textbox.add_to_queue("\"I will NOT honor our agreement...\nInstead, I'll have you entertain me for all eternity.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				textbox.set_name("")
				textbox.clear()
				textbox.set_color(Color(1, 0, 0, 1))
				$RedTruth.play()
				textbox.add_text("BAD ENDING!")
				miracle.ending = miracle.ending_score.worst_ending
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(5), "timeout")
				$CrazyLaugh.play()
				yield(get_tree().create_timer(5), "timeout")
			yield(get_tree().create_timer(4), "timeout")
			miracle.game_root.player.get_node("Camera2D").active = false
			miracle.game_root.player.get_node("Camera2D").reset()
			miracle.load_scene("res://src/Credits.tscn")
			return
	else:
		bernkastel_battle()

func stop():
	is_active = false
	bulletmanager.queue_free()
	animation = "idle"

func die():
	if not miracle.game_root.player.is_dead:
		is_dead = true

func get_angle_to_player(from=null):
	if from:
		assert typeof(from) == TYPE_VECTOR2
		return rad2deg(miracle.game_root.player.get_position().angle_to_point(from))
	else:
		return rad2deg(miracle.game_root.player.get_position().angle_to_point(get_position()))

func move(point):
	is_moving = true
	end_vector = point

func hide_circles(play_anim=false):
	$YellowCircle.hide(play_anim)
	$WhiteCircle.hide(play_anim)
	$GreenCircle.hide(play_anim)
	$BlackCircle.hide(play_anim)
	$RedCircle.hide(play_anim)
	$BlueCircle.hide(play_anim)

func _physics_process(delta):
	if miracle.game_root:
		if miracle.game_root.bern_boss_started:
			if health <= 0 and not is_dead:
				health = 0
				die()

			if $Area2D.get_overlapping_bodies().size():
				for i in $Area2D.get_overlapping_bodies():
					if i.get("is_player_bullet"):
						health -= 1
						$AnimationPlayer.play("hit")
						i.queue_free()
					elif i.has_method("die"):
						i.die()
		if is_moving:
			if position.distance_to(end_vector) < 100:
				is_moving = false
				animation = "idle"
				emit_signal("stopped_moving")
			else:
				var direction = rad2deg(end_vector.angle_to_point(position))
				if direction > 90 and direction < 270:
					if flip_h:
						animation = "move_backwards"
					else:
						animation = "move_forwards"
				else:
					if flip_h:
						animation = "move_forwards"
					else:
						animation = "move_backwards"
				position += Vector2(cos(deg2rad(direction)), sin(deg2rad(direction))) * velocity * delta
