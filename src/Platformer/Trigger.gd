extends Area2D

export(AudioStream) var trigger_sound
export(GDScript) var player
export var group = "trigger_group"
export var trigger_once = true

var triggered = false
var stream_player

signal triggered(who)

func _ready():
	stream_player = AudioStreamPlayer.new()
	stream_player.stream = trigger_sound
	add_child(stream_player)

func trigger(who):
	if not triggered or not trigger_once:
		if trigger_sound:
			stream_player.play()
		emit_signal("triggered", who)
		triggered = true
		get_tree().call_group(group, "trigger")
		var keep_loop = true
		while stream_player.playing:
			yield(get_tree().create_timer(5), "timeout")
		if trigger_once:
			queue_free()

func _process(delta):
	for body in get_overlapping_bodies():
		if body is player:
			trigger(body)