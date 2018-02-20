extends RichTextLabel

signal on_queue_end
signal on_queue_next

var queue = []
var delay = 0.025
var speed = 8
var shake = Vector2(0, 0) setget set_shake
onready var origpos = rect_position
var timer = 0
var rainbow_color = false
var color = Color(1, 1, 1, 1)
var blip = load("res://res/snd/blip60.wav")

func _ready():
	connect("on_queue_next", self, "_on_queue_next")
	connect("on_queue_end", self, "_on_queue_end")

	var player = AudioStreamPlayer.new()
	player.set_volume_db(-15)
	if typeof(blip) == TYPE_OBJECT:
		if blip is AudioStream:
			player.set_stream(blip)
	add_child(player, true)

	push_color(color)

func _on_queue_next():
	var r
	var g
	var b
	if rainbow_color:
		randomize()
		r = randf()
		randomize()
		g = randf()
		randomize()
		b = randf()
		color = Color(r, g, b)
	push_color(color)
	if blip != null:
		get_node("AudioStreamPlayer").play()

func _on_queue_end():
	pass

func add_to_queue(text):
	for character in text:
		queue.push_back(character)

func newline():
	add_to_queue("\n")

func set_shake(vector):
	assert typeof(vector) == TYPE_VECTOR2
	if vector.length() == 0:
		rect_position = origpos
	else:
		origpos = rect_position
	shake = vector

func _process(delta):
	if timer < delay:
		timer += (delta * speed)
	else:
		var character = queue.pop_front()
		if typeof(character) == TYPE_STRING:
			add_text(character)
			if queue.size() == 0:
				emit_signal("on_queue_end")
			else:
				emit_signal("on_queue_next")
		timer = 0
	if shake.length() != 0:
		randomize()
		var mult = randf()
		randomize()
		var num = Vector2(1, 1)
		if randi()%2:
			num.x = -1
		randomize()
		if randi()%2:
			num.y = -1
		var deltashake = Vector2(mult * shake.x * num.x, mult * shake.y * num.y)
		rect_position = ((origpos + deltashake))
