extends AnimatedSprite

export(NodePath) var bulletmanager
export(NodePath) var background
var end_vector = Vector2(0, 0)
var is_moving = false
var velocity = Vector2(160, 160)
var _name = "The Witch of Miracles"

var is_deadly = true
var is_dead = false

var is_active = true

var textbox

var health = 300000
onready var maxhealth = health

signal stopped_moving()

func _ready():
	bulletmanager = get_node(bulletmanager)
	background = get_node(background)
	background.set_shader_enabled(false)
	yield(spellcard_init(_name, 1), "completed")
	textbox = miracle.game_root.textbox
	textbox.show()
	textbox.set_name("Bernkastel")
	if not miracle.danmaku_dialogue_read:
		textbox.add_to_queue("\"This is the Sea of Fragments...\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.clear()
		textbox.add_to_queue("\"Pitiful creatures such as you are not\nsupposed to be here, but I'll make an\nexception this time.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.clear()
		textbox.add_to_queue("\"We will play by the rules a certain shrine \nmaiden once decided.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		miracle.danmaku_dialogue_read = true
	else:
		textbox.add_to_queue("\"...Let's just do this already.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(1), "timeout")
	textbox.clear()
	textbox.hide()
	miracle.game_root.get_node("BGM").volume_db = 0
	miracle.game_root.get_node("BGM").play()
	miracle.game_root.can_control = true
	yield(bernkastel_battle(), "completed")
	stop()
	var animplayer = miracle.game_root.get_node("AnimationPlayer")
	animplayer.play("FadeMusic")
	textbox.clear()
	textbox.show()
	textbox.add_to_queue("\"I ran out of Spell Cards and you're\nstill alive...\"")
	yield(textbox.label, "on_queue_end")
	yield(get_tree().create_timer(3), "timeout")
	textbox.clear()
	textbox.add_to_queue("\"Ah, it doesn't matter. I'll just get\na new fragment.\"")
	yield(get_tree().create_timer(4), "timeout")
	animplayer.play("ScreenFadeToBlack3")
	yield(animplayer, "animation_finished")
	yield(get_tree().create_timer(4), "timeout")
	miracle.load_scene("res://src/Platformer_title.tscn")

func bernkastel_battle():
	miracle.game_root.spawn_collectibles = true
	yield(get_tree().create_timer(3), "timeout")
	attack_1()
	yield(get_tree().create_timer(15), "timeout")
	attack_3()
	yield(get_tree().create_timer(8), "timeout")
	attack_2()
	yield(get_tree().create_timer(15), "timeout")
	closed_room_spellcard()
	background.set_shader_enabled(true)
	background.set_shader_params(0.1, 0.35, 0.1)
	yield(get_tree().create_timer(30), "timeout")
	attack_1()
	yield(get_tree().create_timer(15), "timeout")
	attack_2()
	yield(get_tree().create_timer(15), "timeout")
	infinite_corridor_spellcard()
	yield(get_tree().create_timer(23.5), "timeout")
	attack_2()
	yield(get_tree().create_timer(15), "timeout")
	flower_of_hell_spellcard()
	background.set_shader_params(0.2, 0.35, 0.2)
	yield(get_tree().create_timer(30), "timeout")
	a_hundred_years_of_pain_spellcard()
	background.set_shader_params(0.25, 0.35, 0.25)
	yield(get_tree().create_timer(45), "timeout")
	attack_1()
	yield(get_tree().create_timer(15), "timeout")
	attack_2()
	yield(get_tree().create_timer(15), "timeout")
	blender_spellcard()
	background.set_shader_params(0.3, 0.35, 0.3)
	yield(get_tree().create_timer(30), "timeout")
	attack_3()
	yield(get_tree().create_timer(8), "timeout")
	background.set_shader_params(0.5, 1.0, 0.5)
	a_thousand_years_of_pain_spellcard()
	yield(get_tree().create_timer(45), "timeout")
	background.set_shader_params(1.5, 0.0, 1.5)

func stop():
	is_active = false
	bulletmanager.queue_free()
	animation = "idle"

func die():
	is_dead = true
	miracle.game_root.can_control = false
	miracle.defeated_bernkastel_danmaku = true
	miracle.game_root.player.is_invincible = true
	stop()
	textbox.clear()
	textbox.show()
	var animplayer = miracle.game_root.get_node("AnimationPlayer")
	animplayer.play("FadeMusic")
	if miracle.defeated_bernkastel_rpg:
		textbox.add_to_queue("\"I have lost... again?!\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
		textbox.add_to_queue("\"This is NOT right, NOT RIGHT!\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
	else:
		textbox.add_to_queue("\"Is this a miracle... or fate?\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(4), "timeout")
	textbox.clear()
	textbox.add_to_queue("\"Ugh... We will fight for the last time...\nIn a new fragment.\"")
	yield(textbox.label, "on_queue_end")
	yield(get_tree().create_timer(4), "timeout")
	animplayer.play("ScreenFadeToBlack3")
	yield(animplayer, "animation_finished")
	yield(get_tree().create_timer(4), "timeout")
	miracle.load_scene("res://src/Platformer_title.tscn")

func attack_1():
	if is_active:
		move(Vector2(250, 360))
		yield(self, "stopped_moving")
		animation = "laugh"
		yield(self, "animation_finished")
		animation = "laugh_loop"
		bulletmanager.random_bullets({"velocity" : Vector2(256, 256), "position" : position}, {"time_between_bullets" : 0.0125, "duration" : 10, "direction_vector" : Vector2(0, 360), "random_color" : true})
		yield(get_tree().create_timer(10), "timeout")
		animation = "laugh_reversed"
		yield(self, "animation_finished")
		animation = "idle"

func attack_2():
	if is_active:
		move(Vector2(300, 300))
		yield(self, "stopped_moving")
		bulletmanager.spiral({"position" : position + Vector2(24, -5), "velocity" : Vector2(300, 300)}, {"duration" : 10, "random_color" : true, "time_between_bullets" : 0.05})
		bulletmanager.circle({"position" : position, "velocity" : Vector2(128, 128)})
		yield(get_tree().create_timer(2.5), "timeout")
		bulletmanager.circle({"position" : position, "velocity" : Vector2(128, 128)})
		yield(get_tree().create_timer(2.5), "timeout")
		bulletmanager.circle({"position" : position, "velocity" : Vector2(128, 128)})
		yield(get_tree().create_timer(2.5), "timeout")
		bulletmanager.circle({"position" : position, "velocity" : Vector2(128, 128)})
		yield(get_tree().create_timer(5), "timeout")

func attack_3():
	if is_active:
		move(Vector2(300, 400))
		yield(self, "stopped_moving")
		bulletmanager.line({"velocity" : Vector2(512, 512), "position" : position, "direction" : get_angle_to_player()}, {"bullets" : 5, "random_color" : true})
		bulletmanager.line({"velocity" : Vector2(512, 512), "position" : Vector2(40, 40), "direction" : get_angle_to_player(Vector2(40, 40))}, {"bullets" : 5, "random_color" : true})
		bulletmanager.line({"velocity" : Vector2(512, 512), "position" : Vector2(540, 0), "direction" : get_angle_to_player(Vector2(540, 0))}, {"bullets" : 5, "random_color" : true})
		bulletmanager.line({"velocity" : Vector2(512, 512), "position" : Vector2(0, 720), "direction" : get_angle_to_player(Vector2(0, 720))}, {"bullets" : 5, "random_color" : true})
		bulletmanager.line({"velocity" : Vector2(512, 512), "position" : Vector2(540, 720), "direction" : get_angle_to_player(Vector2(540, 720))}, {"bullets" : 5, "random_color" : true})
		yield(get_tree().create_timer(3), "timeout")
		print("the end")

func flower_of_hell_spellcard():
	if is_active:
		yield(spellcard_init("Reborn Spirit 「Flower of hell」", 1), "completed")
		$WhiteCircle.appear()
		animation = "sit"
		yield(self, "animation_finished")
		animation = "sit_loop"
		bulletmanager.circle({"position" : position, "velocity" : Vector2(448, 256), "angular_velocity" : 0.75, "destroy_if_offscreen" : false, "can_be_destroyed" : false}, {"random_color" : true, "group" : "flower"})
		bulletmanager.circle({"position" : position, "velocity" : Vector2(448 * cos(15), 256 * sin(15)), "angular_velocity" : 0.75, "destroy_if_offscreen" : false, "can_be_destroyed" : false}, {"random_color" : true, "group" : "flower"})
		bulletmanager.circle({"position" : position, "velocity" : Vector2(256, 448), "angular_velocity" : 0.75, "destroy_if_offscreen" : false, "can_be_destroyed" : false}, {"random_color" : true, "group" : "flower"})
		bulletmanager.circle({"position" : position, "velocity" : Vector2(256 * cos(15), 448 * sin(15)), "angular_velocity" : 0.75, "destroy_if_offscreen" : false, "can_be_destroyed" : false}, {"random_color" : true, "group" : "flower"})
		yield(get_tree().create_timer(15), "timeout")
		get_tree().set_group("flower", "angular_velocity", 0)
		get_tree().set_group("flower", "destroy_if_offscreen", true)
		yield(get_tree().create_timer(5), "timeout")
		animation = "sit_reversed"
		yield(spellcard_end(80000, 1), "completed")

func infinite_corridor_spellcard():
	if is_active:
		spellcard_init("Fragment 「Infinite corridor」", 2)
		move(Vector2(400, 230))
		animation = "spin_prior_loop"
		yield(self, "animation_finished")
		animation = "spin_loop"
		bulletmanager.circle({"position" : position + Vector2(-150, 0), "velocity" : Vector2(64, 64)}, {"bullets" : 45, "random_color" : true})
		bulletmanager.circle({"position" : position + Vector2(125, 15), "velocity" : Vector2(64, 64)}, {"bullets" : 50, "random_color" : true})
		yield(get_tree().create_timer(1), "timeout")
		bulletmanager.circle({"position" : position + Vector2(-75, 15), "velocity" : Vector2(64, 64)}, {"bullets" : 45, "random_color" : true})
		bulletmanager.circle({"position" : position + Vector2(65, 26), "velocity" : Vector2(64, 64)}, {"bullets" : 45, "random_color" : true})
		bulletmanager.circle({"position" : position, "velocity" : Vector2(64, 64)}, {"bullets" : 60, "random_color" : true})
		yield(get_tree().create_timer(1), "timeout")
		bulletmanager.circle({"position" : position + Vector2(150, 0), "velocity" : Vector2(128, 128)}, {"bullets" : 85, "random_color" : true})
		yield(get_tree().create_timer(1.25), "timeout")
		yield(get_tree().create_timer(2.25), "timeout")
		bulletmanager.spiral({"position" : position, "velocity" : Vector2(256, 256)}, {"duration" : 10, "spirals" : 4, "spiral_step" : 90, "random_color" : true})
		yield(bulletmanager, "pattern_end")
		yield(get_tree().create_timer(1), "timeout")
		bulletmanager.multibeam({"position" : position + Vector2(0, -32), "angular_velocity" : 1, "time_before_deleting" : 10, "time_between_rays" : 0.05, "time_before_rays" : 1}, {"beams" : 2, "beam_step" : 180, "random_color" : true})
		yield(get_tree().create_timer(11), "timeout")
		spellcard_end(14144, 1)

func a_hundred_years_of_pain_spellcard():
	if is_active:
		spellcard_init("Fragment 「A hundred years of pain」")
		move(Vector2(100, 350))
		$BlueCircle.appear()
		yield(self, "stopped_moving")
		animation = "hand_unite"
		yield(self, "animation_finished")
		animation = "hand_unite_loop"
		bulletmanager.spiral({"position" : position+ Vector2(27, 0), "velocity" : Vector2(128, 128)}, {"spirals" : 2, "spiral_step" : 180, "duration" : 40, "group" : "spiral", "random_color" : true})
		yield(get_tree().create_timer(15), "timeout")
		bulletmanager.spiral({"position" : position+ Vector2(27, 0), "velocity" : Vector2(128, 128), "acceleration" : Vector2(64, 64)}, {"spirals" : 2, "spiral_step" : 180, "duration" : 25, "group" : "spiral", "random_color" : true})
		yield(get_tree().create_timer(10), "timeout")
		print(get_angle_to_player(position + Vector2(-32, 0)))
		bulletmanager.multibeam({"position" : position + Vector2(-32, 0), "time_before_deleting" : 10, "time_between_rays" : 0.05, "time_before_rays" : 1}, {"beam_step_start" : get_angle_to_player()})
		yield(get_tree().create_timer(2), "timeout")
		bulletmanager.multibeam({"position" : position + Vector2(32, 0), "time_before_deleting" : 10, "time_between_rays" : 0.05, "time_before_rays" : 1}, {"beam_step_start" : get_angle_to_player()})
		yield(get_tree().create_timer(8), "timeout")
		bulletmanager.line({"velocity" : Vector2(512, 512), "position" : position, "direction" : get_angle_to_player()}, {"bullets" : 5, "random_color" : true})
		yield(get_tree().create_timer(5), "timeout")
		spellcard_end(19832083)

func a_thousand_years_of_pain_spellcard():
	if is_active:
		spellcard_init("Fragment 「A thousand years of pain」", 0)
		$RedCircle.appear()
		animation = "idle"
		bulletmanager.circle({"position" : position, "velocity" : Vector2(128, 128)})
		move(Vector2(400, 350))
		yield(self, "stopped_moving")
		animation = "hand_raise"
		yield(self, "animation_finished")
		animation = "hand_raise_loop"
		spellcard_text("You don't know what it's like...", 6, Color(0.49, 0.49, 1, 1), Color(0, 0, 1, 1))
		bulletmanager.spiral({"position" : position + Vector2(-42, -115), "velocity" : Vector2(256, 256), "foreground_color" : Color8(0, 0, 0, 255)}, {"spirals" : 8, "duration" : 18, "initial_step" : 45, "spiral_step" : 45, "group" : "spiral1"})
		yield(get_tree().create_timer(6), "timeout")
		bulletmanager.spiral({"position" : position + Vector2(-42, -115), "velocity" : Vector2(256, 256), "foreground_color" : Color8(255, 255, 255, 255)}, {"spirals" : 8, "duration" : 12, "spiral_step" : 45, "group" : "spiral1"})
		spellcard_text("Having lived in pain for more than a thousand years.", 6)
		yield(get_tree().create_timer(12), "timeout")
		get_tree().set_group("spiral1", "velocity", Vector2(0, 0))
		spellcard_text("That's why I'm going to teach you right now...", 6)
		yield(get_tree().create_timer(3), "timeout")
		bulletmanager.multibeam({"position" : Vector2(32, 32), "foreground_color" : Color8(255, 0, 255, 255), "time_between_rays" : 0.025, "time_before_rays" : 3}, {"group" : "beam1", "beam_step_start" : 45})
		bulletmanager.multibeam({"position" : Vector2(568, 32), "foreground_color" : Color8(255, 0, 255, 255), "time_between_rays" : 0.025, "time_before_rays" : 3}, {"group" : "beam1", "beam_step_start" : 135})
		yield(get_tree().create_timer(7), "timeout")
		get_tree().set_group("spiral1", "acceleration", Vector2(-120, -30))
		get_tree().set_group("spiral1", "direction", 270)
		spellcard_text("HOW IT FEELS!", 6)
		yield(get_tree().create_timer(7), "timeout")
		get_tree().call_group("spiral1", "queue_free")
		get_tree().call_group("beam1", "destroy")
		yield(spellcard_end(10000000), "completed")
		yield(get_tree().create_timer(2), "timeout")
		if miracle.game_root.died_during_spellcard:
			spellcard_text("...You still don't get it, don't you?", 6, Color(0.49, 0.49, 1, 1), Color(0, 0, 1, 1))
		else:
			spellcard_text("That's right... That's how it felt.", 6, Color(0.49, 0.49, 1, 1), Color(0, 0, 1, 1))
		yield(get_tree().create_timer(2), "timeout")

func blender_spellcard():
	if is_active:
		move(Vector2(300, 400))
		yield(self, "stopped_moving")
		yield(spellcard_init("Future sign 「Beam-powered blender」", 1), "completed")
		animation = "faito_oh"
		yield(self, "animation_finished")
		animation = "faito_oh_loop"
		$YellowCircle.appear()
		miracle.game_root.get_node("Magic").play()
		bulletmanager.multibeam({"position" : position + Vector2(-32, -128), "time_before_rays" : 3, "destroy_if_offscreen" : false, "time_between_rays" : 0.025, "time_before_deleting" : false}, {"beams" : 4, "beam_step" : 90, "group" : "beam1"})
		yield(get_tree().create_timer(2.5), "timeout")
		miracle.game_root.get_node("AnimationPlayer").play("Spiral1")
		yield(get_tree().create_timer(2.5), "timeout")
		miracle.game_root.get_node("Ahaha").play()
		bulletmanager.random_bullets({"position" : position + Vector2(-32, -128), "velocity" : Vector2(256, 256)}, {"direction_vector" : Vector2(0, 360), "duration" : 19.5, "group" : "random_bullets1", "random_color" : true, "time_between_bullets" : 0.5})
		get_tree().set_group("beam1", "set_foreground_color", Color8(225, 15, 15, 255))
		get_tree().set_group("beam1", "angular_velocity", 1)
		yield(get_tree().create_timer(4), "timeout")
		get_tree().call_group("beam1", "set_foreground_color", Color8(225, 225, 225, 255))
		get_tree().set_group("beam1", "angular_velocity", 0)
		yield(get_tree().create_timer(5), "timeout")
		get_tree().call_group("beam1", "set_foreground_color", Color8(15, 255, 255, 255))
		get_tree().set_group("beam1", "angular_velocity", -1.25)
		yield(get_tree().create_timer(10), "timeout")
		get_tree().set_group("beam1", "angular_velocity", 0)
		get_tree().call_group("beam1", "set_foreground_colorcolor", Color8(15, 225, 15, 255))
		get_tree().set_group("beam1", "velocity", Vector2(300, 300))
		get_tree().set_group("beam1", "direction_affects_velocity", false)
		yield(get_tree().create_timer(0.5), "timeout")
		get_tree().set_group("beam1", "velocity", Vector2(0, 0))
		get_tree().call_group("beam1", "set_foreground_color", Color8(225, 225, 225, 255))
		get_tree().call_group("beam1", "destroy")
		miracle.game_root.get_node("AnimationPlayer").play_backwards("Spiral1")
		spellcard_end(5000, 1)

func closed_room_spellcard():
	if is_active:
		move(Vector2(300, -200))
		$YellowCircle.appear()
		animation = "idle"
		yield(self, "stopped_moving")
		hide()
		yield(spellcard_init("Mystery sign 「Closed room murder」", 1), "completed")
		bulletmanager.multibeam({"position" : Vector2(32, 705), "destroy_if_offscreen" : false, "time_between_rays" : 0.020, "direction_affects_velocity" : false}, {"group" : "beam2"})
		bulletmanager.multibeam({"position" : Vector2(32, 32), "destroy_if_offscreen" : false, "time_between_rays" : 0.020, "direction_affects_velocity" : false}, {"group" : "beam3"})
		bulletmanager.multibeam({"position" : Vector2(32, 32), "destroy_if_offscreen" : false, "time_between_rays" : 0.020, "direction_affects_velocity" : false}, {"group" : "beam4", "beam_step_start" : 90})
		bulletmanager.multibeam({"position" : Vector2(568, 32), "destroy_if_offscreen" : false, "time_between_rays" : 0.020, "direction_affects_velocity" : false}, {"group" : "beam5", "beam_step_start" : 90})
		miracle.game_root.get_node("AnimationPlayer").play("Spiral3")
		yield(get_tree().create_timer(2), "timeout")
		bulletmanager.random_bullets({"position" : Vector2(300, 0), "velocity" : Vector2(256, 256)}, {"direction_vector" : Vector2(0, 180), "duration" : 19, "group" : "random_bullets1", "random_color" : true, "time_between_bullets" : 0.025})
		get_tree().set_group("beam2", "foreground_color", Color8(255, 0, 0, 255))
		get_tree().set_group("beam2", "velocity", Vector2(0, -100))
		yield(get_tree().create_timer(3), "timeout")
		get_tree().set_group("beam2", "velocity", Vector2(0, 0))
		get_tree().set_group("beam2", "foreground_color", Color8(225, 225, 225, 255))
		yield(get_tree().create_timer(3), "timeout")
		get_tree().set_group("beam3", "velocity", Vector2(0, 64))
		get_tree().set_group("beam3", "foreground_color", Color8(255, 0, 0, 255))
		get_tree().set_group("beam2", "foreground_color", Color8(0, 255, 255, 255))
		get_tree().set_group("random_bullets1", "velocity", Vector2(-256, -256))
		get_tree().set_group("beam2", "velocity", Vector2(0, 64))
		yield(get_tree().create_timer(3), "timeout")
		get_tree().set_group("beam3", "velocity", Vector2(0, 0))
		get_tree().set_group("beam2", "velocity", Vector2(0, 0))
		get_tree().set_group("beam3", "foreground_color", Color8(225, 225, 225, 255))
		get_tree().set_group("beam2", "foreground_color", Color8(225, 225, 225, 255))
		get_tree().set_group("random_bullets1", "velocity", Vector2(256, 256))
		yield(get_tree().create_timer(4), "timeout")
		get_tree().set_group("beam4", "velocity", Vector2(78, 0))
		get_tree().set_group("beam4", "foreground_color", Color8(255, 0, 0, 255))
		get_tree().set_group("random_bullets1", "velocity", Vector2(-256, -256))
		yield(get_tree().create_timer(3), "timeout")
		get_tree().set_group("beam5", "velocity", Vector2(-62, 0))
		get_tree().set_group("beam5", "foreground_color", Color8(255, 0, 0, 255))
		get_tree().set_group("beam4", "velocity", Vector2(0, 0))
		get_tree().set_group("beam4", "foreground_color", Color8(255, 255, 255, 255))
		yield(get_tree().create_timer(3), "timeout")
		get_tree().set_group("random_bullets1", "velocity", Vector2(-256, -256))
		get_tree().set_group("beam5", "velocity", Vector2(0, 0))
		get_tree().set_group("beam5", "foreground_color", Color8(255, 255, 255, 255))
		get_tree().call_group("beam2", "destroy")
		get_tree().call_group("beam3", "destroy")
		get_tree().call_group("beam4", "destroy")
		get_tree().call_group("beam5", "destroy")
		yield(spellcard_end(10000, 3), "completed")
		show()
		miracle.game_root.get_node("AnimationPlayer").play_backwards("Spiral3")
		move(Vector2(300, 400))

func spellcard_init(n="Fragment 「Unknown」", delay_before_starting=1, physics_fps=60, force_fps=0):
	yield(get_tree().create_timer(delay_before_starting), "timeout")
	miracle.game_root.died_during_spellcard = false
	miracle.game_root.spellcard_textbox.clear()
	miracle.game_root.spellcard_textbox.add_text(n)
	miracle.game_root.spawn_collectibles = false
	ProjectSettings.set("physics/common/Fixed Fps", physics_fps)
	ProjectSettings.set("debug/fps/Force Fps", force_fps)

func spellcard_end(bonus_points=10000, delay_before_ending=1):
	yield(get_tree().create_timer(delay_before_ending), "timeout")
	miracle.game_root.spellcard_textbox.clear()
	miracle.game_root.spellcard_textbox.add_text(_name)
	miracle.game_root.spawn_collectibles = true
	miracle.game_root.get_node("Glassbreak").play()
	animation = "idle"
	hide_circles(true)
	ProjectSettings.set("physics/common/Fixed Fps", 60)
	ProjectSettings.set("fps/Force Fps", 0)
	if not miracle.game_root.died_during_spellcard:
		spellcard_bonus(bonus_points)

func spellcard_bonus(score=1000, time_shown=5):
	miracle.game_root.score += score
	miracle.game_root.bonus_label.set_text(str(score))
	miracle.game_root.bonus_label.get_node("../../").show()
	var extra_bomb = false
	var extra_life = false
	randomize()
	if randf() < 30:
		extra_bomb = true
		miracle.game_root.bomb += 1
	randomize()
	if randf() < 30:
		extra_life = true
		miracle.game_root.lives += 1
	if extra_bomb and extra_life:
		spellcard_text("Extra bomb! Extra life!", time_shown, Color(0.49, 0.5, 1, 1), Color(0.34, 0, 1, 1))
	elif extra_bomb and not extra_life:
		spellcard_text("Extra bomb!", time_shown, Color(0.49, 0.5, 1, 1), Color(0.34, 0, 1, 1))
	elif extra_life and not extra_bomb:
		spellcard_text("Extra life!", time_shown, Color(0.49, 0.5, 1, 1), Color(0.34, 0, 1, 1))
	get_tree().create_timer(time_shown).connect("timeout", miracle.game_root.bonus_label.get_node("../../"), "hide")


func spellcard_text(text, time_shown=5, color1=Color(1, 0.49, 0.49, 1), color2=Color(1, 0, 0, 1)):
	miracle.game_root.misc_text.set_text(str(text))
	miracle.game_root.misc_text.set("custom_colors/font_color", color1)
	miracle.game_root.misc_text.set("custom_colors/font_color_shadow", color2)
	miracle.game_root.misc_text.set_theme(miracle.game_root.misc_text.get_theme())
	miracle.game_root.misc_text.show()
	get_tree().create_timer(time_shown).connect("timeout", miracle.game_root.misc_text, "hide")

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
	#print(get_node("../..").get_mouse_position())
	if miracle.game_root:
		if miracle.game_root.game_started:
			if health <= 0 and not is_dead:
				health = 0
				die()

			if randi()%4000 >= 3999 and miracle.tried_to_run_away:
				var new_bullet = bulletmanager.create_bullet(get_position(), get_angle_to_player(), Vector2(400, 400))
				bulletmanager.add_child(new_bullet)
				randomize()
			if get_position().x > (get_viewport_rect().size.x / 2) and not is_moving:
				flip_h = false
			else:
				flip_h = true
			if $Area2D.get_overlapping_bodies().size():
				for i in $Area2D.get_overlapping_bodies():
					health -= 100
					miracle.game_root.score += 100
					i.queue_free()
			elif $Area2D.get_overlapping_areas().size():
				$Area2D.get_overlapping_areas()[0].get_parent().die()
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
