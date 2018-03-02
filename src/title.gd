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
	$"Settings".popup_centered()


func website():
	OS.shell_open("https://zumo.itch.io/amwno")


func _on_Master_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_SFX_value_changed(value):
	AudioServer.set_bus_volume_db(1, value)

func _on_Music_value_changed(value):
	AudioServer.set_bus_volume_db(2, value)

func _on_CheckButton_toggled(button_pressed):
	miracle.direct = not button_pressed
