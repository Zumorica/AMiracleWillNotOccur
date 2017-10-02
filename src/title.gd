extends TextureRect

export(Texture) var normal_texture
export(Texture) var other_texture

func _ready():
	$AnimationPlayer.play("clock")
	
func _process(dt):
	if randf() < 0.25:
		texture = normal_texture
		randomize()
	if randf() < 0.01:
		texture = other_texture
		randomize()
	randomize()
	var mult = randf()
	if mult > 0.3:
		$AnimatedSprite.material.set_shader_param("scanline_modifier", mult)

func new_game():
	miracle.reset_values()
	miracle.load_scene("res://src/RPG_title.tscn")

func _on_Button3_pressed():
	get_tree().quit()


func website():
	OS.shell_open("https://zumo.itch.io/amwno")
