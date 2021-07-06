extends Panel

onready var label = $"./Dialogue/Text"
onready var name_label = $"./Name/Name"
onready var name_panel = $"./Name"
var blips = {"blip60"     : preload("res://res/snd/blip60.wav"), 
			 "blip60echo" : preload("res://res/snd/blip60echo.wav"),
			 "blip70"     : preload("res://res/snd/blip70.wav"),
			 "blip75"     : preload("res://res/snd/blip75.wav"),
			 "blip80"     : preload("res://res/snd/blip80.wav"),
			 "blip90"     : preload("res://res/snd/blip90.wav")}

func set_shake(vector):
	label.set_shake(vector)

func set_speed(delay: int, speed: int):
	label.delay = delay
	label.speed = speed

func set_random_color(boolean: bool):
	label.rainbow_color = boolean

func set_color(color: Color):
	label.push_color(color)
	label.color = color

func set_blip(stream: AudioStream):
	if stream == null:
		label.blip = null
		label.get_node("AudioStreamPlayer").set_stream(null)
		return
	label.blip = stream
	label.get_node("AudioStreamPlayer").set_stream(stream)

func add_to_queue(text):
	label.add_to_queue(text)

func add_text(text: String):
	label.add_text(text)

func set_name(text: String):
	if text.length():
		name_panel.show()
	else:
		name_panel.hide()
	name_label.set_text(text)

func newline():
	label.newline()

func clear():
	label.bbcode_text = ""
