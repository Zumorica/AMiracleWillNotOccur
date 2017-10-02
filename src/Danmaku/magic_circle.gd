extends Sprite

var tween = Tween.new()
var should_appear = false

func _ready():
	modulate.a = 0
	add_child(tween)

func appear():
	show()
	tween.stop_all()
	tween.remove_all()
	tween.interpolate_property(get_node("."), "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()
	should_appear = true
	
func _process(delta):
	if not is_visible() and should_appear:
		show()

func hide(play_anim=false):
	print("I HAVE BEEN CALLED.", " ", modulate.a)
	if play_anim:
		tween.stop_all()
		tween.remove_all()
		tween.interpolate_property(get_node("."), "modulate", Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()
		yield(get_tree().create_timer(1), "timeout")
		should_appear = false
	.hide()