extends TextureRect

export(NodePath) var bernkastel_hp_progressbar
export(NodePath) var highscore_label
export(NodePath) var score_label
export(NodePath) var lives_label
export(NodePath) var bomb_label
export(NodePath) var power_label
export(NodePath) var power_progressbar
export(NodePath) var spellcard_textbox
export(NodePath) var bonus_label
export(NodePath) var misc_text
export(NodePath) var textbox

export(NodePath) var point_parent

export(NodePath) var bernkastel
export(NodePath) var player

export(Texture) var live_texture
export(Texture) var bomb_texture

export(PackedScene) var power_scene
export(PackedScene) var point_scene

var spawn_collectibles = true
var high_score = 2578917000
var score = 0
var lives = 3
var bomb = 3
var power = 0

var died_during_spellcard = false

var game_started = true
var can_control = false

func _ready():
	miracle.game_root = self
	miracle.current_game = miracle.game.danmaku
	bernkastel_hp_progressbar = get_node(bernkastel_hp_progressbar)
	highscore_label = get_node(highscore_label)
	score_label = get_node(score_label)
	lives_label = get_node(lives_label)
	bomb_label = get_node(bomb_label)
	power_label = get_node(power_label)
	power_progressbar = get_node(power_progressbar)
	spellcard_textbox = get_node(spellcard_textbox)
	bonus_label = get_node(bonus_label)
	bernkastel = get_node(bernkastel)
	player = get_node(player)
	misc_text = get_node(misc_text)
	point_parent = get_node(point_parent)
	textbox = get_node(textbox)
	set_process(true)

func gameover():
	get_tree().quit()

func _process(delta):
	if spawn_collectibles:
		if randf() < 0.0020:
			randomize()
			var power_instance = power_scene.instance()
			power_instance.position = Vector2(randi()%598, 0)
			power_instance.power = (randi()%63) + 1
			power_instance.add_to_group("power")
			point_parent.add_child(power_instance)
		if randf() < 0.0025:
			randomize()
			var point_instance = point_scene.instance()
			point_instance.position = Vector2(randi()%598, 0)
			point_instance.point = randi()%600
			point_instance.add_to_group("point")
			point_parent.add_child(point_instance)
	if lives < 0:
		gameover()
	if score > high_score:
		high_score = score
	if power > 255:
		power = 255
	if power < 0:
		power = 0
	if bomb < 0:
		bomb = 0
	highscore_label.clear()
	score_label.clear()
	lives_label.clear()
	bomb_label.clear()
	power_label.clear()
	highscore_label.push_align(1)
	score_label.push_align(1)
	lives_label.push_align(0)
	bomb_label.push_align(0)
	power_label.push_align(1)
	highscore_label.add_text(str(high_score).pad_zeros(10))
	score_label.add_text(str(score).pad_zeros(10))
	power_label.add_text(str(power).pad_zeros(3))
	power_progressbar.value = power
	bernkastel_hp_progressbar.value = bernkastel.health
	bernkastel_hp_progressbar.max_value = bernkastel.maxhealth
	for i in range(lives):
		if i >= 0:
			lives_label.add_image(live_texture)
	for i in range(bomb):
		if i >= 0:
			bomb_label.add_image(bomb_texture)