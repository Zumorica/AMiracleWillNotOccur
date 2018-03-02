extends TextureRect

export(NodePath) var bernkastel_texture
export(NodePath) var textbox
export(NodePath) var gamepanel
export(NodePath) var hp_label
export(NodePath) var mp_label
export(NodePath) var status_label
export(NodePath) var bhp_label
export(NodePath) var bmp_label
export(NodePath) var bstatus_label

export(NodePath) var attack_button
export(NodePath) var defend_button
export(NodePath) var magic_button
export(NodePath) var acknowledge_button
export(NodePath) var mercy_button
export(NodePath) var runaway_button

export(NodePath) var minorheal_button
export(NodePath) var magicmissile_button
export(NodePath) var magicpunch_button
export(NodePath) var back_button

var turn = 0
var hp = 100
var mp = 0
var status = []
var bhp = 100
var bstatus = []

var bfinal_preparing = 0
var can_press = true

onready var bored_turn = round(rand_range(10, 30))

var mult
var bmult

func _ready():
	miracle.game_root = self
	miracle.current_game = miracle.game.RPG
	randomize()
	mult = rand_range(0.0, 2.0)
	bmult = rand_range(0.0, 2.0)
	if mult > 1.75 and bmult < 1.75:
		status.append("Lucky")
	if mult < 0.75 and bmult > 0.75:
		status.append("Unlucky")
	if bmult > 1.75 and mult < 1.75:
		bstatus.append("Lucky")
	if bmult < 0.75 and mult > 0.75:
		bstatus.append("Unlucky")
	assert textbox
	assert bernkastel_texture
	textbox = get_node(textbox)
	bernkastel_texture = get_node(bernkastel_texture)
	gamepanel = get_node(gamepanel)
	hp_label = get_node(hp_label)
	mp_label = get_node(mp_label)
	status_label = get_node(status_label)
	bhp_label = get_node(bhp_label)
	bmp_label = get_node(bmp_label)
	bstatus_label = get_node(bstatus_label)
	attack_button = get_node(attack_button)
	defend_button = get_node(defend_button)
	magic_button = get_node(magic_button)
	acknowledge_button = get_node(acknowledge_button)
	mercy_button = get_node(mercy_button)
	runaway_button = get_node(runaway_button)
	minorheal_button = get_node(minorheal_button)
	magicmissile_button = get_node(magicmissile_button)
	magicpunch_button = get_node(magicpunch_button)
	back_button = get_node(back_button)
	set_process(true)
	gamepanel.hide()
	textbox.show()
	bernkastel_texture.FullBody.texture = load("res://res/spr/VN/Ep5_1_ber_EP5_1_ber.png")
	textbox.set_name("Bernkastel")
	if not miracle.rpg_dialogue_read:
		textbox.set_color(Color(1, 0, 0, 1))
		textbox.set_shake(Vector2(1, 1))
		$Redtruth.play()
		textbox.add_text("\"As the witch of miracles, I hereby declare that a miracle will not occur.\"")
		yield(get_tree().create_timer(3), "timeout")
		bernkastel_texture.FullBody.texture = load("res://res/spr/VN/Ep5_1_ber_d_EP5_1_ber_d.png")
		textbox.clear()
		textbox.set_blip(textbox.blips.blip70)
		textbox.set_color(Color(1, 1, 1, 1))
		textbox.set_shake(Vector2(0, 0))
		textbox.add_to_queue("\"...And now there's no way for you to avoid your death.\"")
		miracle.rpg_dialogue_read = true
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
	else:
		textbox.add_to_queue("\"You again? Fine, let's just get this over with.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(1.5), "timeout")
	textbox.hide()
	textbox.clear()
	new_turn()

func new_turn():
	randomize()
	turn += 1
	can_press = false
	gamepanel.hide()
	if bhp <= 0:
		miracle.defeated_bernkastel_rpg = true
		$AnimationPlayer.play("BernBlack")
		yield($AnimationPlayer, "animation_finished")
		yield(get_tree().create_timer(4), "timeout")
		textbox.set_name("Bernkastel")
		textbox.set_blip(textbox.blips.blip70)
		textbox.clear()
		textbox.show()
		textbox.set_shake(Vector2(1, 1))
		$AnimationPlayer.play("FadeMusic")
		yield($AnimationPlayer, "animation_finished")
		textbox.add_to_queue("\"How is this even possible...?\"")
		textbox.newline()
		yield(textbox.label, "on_queue_end")
		$Glassbreak.play()
		yield(get_tree().create_timer(3), "timeout")
		textbox.add_to_queue("\"I said it in red before.\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.clear()
		textbox.set_color(Color(1, 0, 0, 1))
		$Redtruth.play()
		textbox.add_text("\"A miracle will not occur! A MIRACLE CANNOT HAVE OCCURED!\"")
		yield(get_tree().create_timer(4), "timeout")
		textbox.clear()
		textbox.set_color(Color(1, 1, 1, 1))
		textbox.set_shake(Vector2(0, 0))
		textbox.add_to_queue("\"Wait... Maybe that was not a miracle...\"")
		yield(textbox.label, "on_queue_end")
		textbox.newline()
		yield(get_tree().create_timer(2), "timeout")
		textbox.add_to_queue("\"Is this... ")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.add_to_queue("fate?\"")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.clear()
		textbox.add_to_queue("\"Fine. Let us continue our fight elsewhere.\"")
		yield(get_tree().create_timer(2), "timeout")
		$AnimationPlayer.play("FadeToBlack3")
		yield(get_tree().create_timer(4), "timeout")
		miracle.load_scene("res://src/Danmaku_title.tscn")

	if bstatus.has("Defending"):
		bstatus.remove(bstatus.find("Defending"))
	if status.has("Silenced"):
		status.remove(status.find("Silenced"))
	if bstatus.has("Shocked...."):
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		textbox.add_to_queue("Bernkastel is shocked!")
		bstatus.remove(bstatus.find("Shocked...."))
		bstatus.append("Shocked...")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		can_press = true
		textbox.hide()
		gamepanel.show()
		return
	elif bstatus.has("Shocked..."):
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		textbox.add_to_queue("Bernkastel is shocked!")
		bstatus.remove(bstatus.find("Shocked..."))
		bstatus.append("Shocked..")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		can_press = true
		textbox.hide()
		gamepanel.show()
		return
	elif bstatus.has("Shocked.."):
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		textbox.add_to_queue("Bernkastel is shocked!")
		bstatus.remove(bstatus.find("Shocked.."))
		bstatus.append("Shocked.")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		can_press = true
		textbox.hide()
		gamepanel.show()
		return
	elif bstatus.has("Shocked."):
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		textbox.add_to_queue("Bernkastel is shocked!")
		bstatus.remove(bstatus.find("Shocked."))
		bstatus.append("Shocked")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		can_press = true
		textbox.hide()
		gamepanel.show()
		return
	elif bstatus.has("Shocked"):
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		textbox.add_to_queue("Bernkastel stopped being shocked.")
		bstatus.remove(bstatus.find("Shocked"))
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		can_press = true
		textbox.hide()
		gamepanel.show()
		return
	if randf() > 0.6:
		bernkastel_texture.FullBody.texture = load("res://res/spr/VN/Ep5_1_ber_EP5_1_ber.png")
	else:
		bernkastel_texture.FullBody.texture = load("res://res/spr/VN/Ep5_1_ber_d_EP5_1_ber_d.png")
	if turn >= bored_turn and not bfinal_preparing:
		gamepanel.hide()
		textbox.clear()
		textbox.show()
		$AnimationPlayer.play("FadeMusic")
		yield($AnimationPlayer, "animation_finished")
		textbox.set_name("Bernkastel")
		textbox.set_blip(textbox.blips.blip60)
		bernkastel_texture.FullBody.texture = load("res://res/spr/VN/Ep5_1_ber_EP5_1_ber.png")
		textbox.add_to_queue("\"This is starting to become really boring...\"")
		textbox.newline()
		yield(get_tree().create_timer(5), "timeout")
		textbox.set_blip(textbox.blips.blip70)
		bernkastel_texture.FullBody.texture = load("res://res/spr/VN/Ep5_1_ber_d_EP5_1_ber_d.png")
		textbox.add_to_queue("\"I have a better idea... I know a fragment where we can continue our fight.\"")
		yield(get_tree().create_timer(4), "timeout")
		$AnimationPlayer.play("FadeToBlack3")
		yield(get_tree().create_timer(5), "timeout")
		miracle.load_scene("res://src/Danmaku_title.tscn")
	else:
		textbox.set_name("")
		if not bfinal_preparing:
			if (hp <= 15 or rand_range(0, 100) <= 5) and turn >= (bored_turn / 2):
				textbox.clear()
				textbox.show()
				textbox.set_blip(null)
				textbox.set_name("")
				$Flange.play()
				textbox.add_to_queue("Bernkastel began preparing her final attack!")
				bfinal_preparing = (randi()%4) + 1
				status.append("Doomed")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(4), "timeout")
				textbox.set_blip(textbox.blips.blip60)
				textbox.hide()
				gamepanel.show()
				can_press = true
				return
			else:
				randomize()
				var action = randi()%5
				randomize()
				if action == 0:
					textbox.set_name("")
					textbox.set_blip(null)
					textbox.clear()
					textbox.show()

					var dmg = randi()%15

					if status.has("Defending"):
						dmg = round((dmg * bmult) / 2)

					textbox.add_to_queue("Bernkastel attacks!")
					textbox.newline()
					yield(textbox.label, "on_queue_end")
					hp -= dmg
					yield(get_tree(), "idle_frame")
					textbox.add_to_queue("You took %s damage." %str(dmg))
					if dmg > 0:
						$AnimationPlayer.play("Shake")
					yield(textbox.label, "on_queue_end")
					yield(get_tree().create_timer(3), "timeout")

					textbox.clear()
					textbox.hide()
					textbox.set_name("Bernkastel")
					textbox.set_blip(textbox.blips.blip60)
				elif action == 1:
					textbox.set_name("")
					textbox.set_blip(null)
					textbox.clear()
					textbox.show()

					textbox.add_to_queue("Bernkastel adopts a defensive stance!")
					bstatus.append("Defending")

					yield(textbox.label, "on_queue_end")
					yield(get_tree().create_timer(3), "timeout")

					textbox.clear()
					textbox.hide()
					textbox.set_name("Bernkastel")
					textbox.set_blip(textbox.blips.blip60)
				elif action == 2:
					textbox.set_name("Bernkastel")
					textbox.set_blip(textbox.blips.blip80)
					textbox.show()
					if bhp < 50 or turn == 1:
						textbox.add_to_queue("\"Major heal!\"")
						var hl = (randi()%10) + 10
						bhp += hl
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
						textbox.hide()
						textbox.clear()
						textbox.set_name("")
						textbox.set_blip(null)
						textbox.show()
						textbox.add_to_queue("Bernkastel recovers %s HP." %hl)
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
						textbox.hide()
						textbox.clear()
					elif bhp < 90:
						textbox.add_to_queue("\"Minor heal!\"")
						var hl = (randi()%9) + 1
						bhp += hl
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
						textbox.hide()
						textbox.clear()
						textbox.set_name("")
						textbox.set_blip(null)
						textbox.show()
						textbox.add_to_queue("Bernkastel recovers %s HP." %hl)
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
						textbox.hide()
						textbox.clear()
					else:
						textbox.set_blip(textbox.blips.blip60echo)
						textbox.add_to_queue("\"A pitiful being such as you shouldn't be able to use magic...\"")
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
						textbox.hide()
						textbox.clear()
						textbox.set_name("")
						textbox.set_blip(null)
						textbox.show()
						textbox.add_to_queue("You can't use magic spells for a turn!")
						if not status.has("Silenced"):
							status.append("Silenced")
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
						textbox.hide()
						textbox.clear()

				elif action == 3:
					textbox.clear()
					textbox.set_name("")
					textbox.set_blip(null)
					textbox.show()
					$Wind.play()
					randomize()
					if randf() > 0.5:
						textbox.add_to_queue("You cannot grasp the true form of Bernkastel's attack!")
					else:
						textbox.add_to_queue("?! ...What did Bernkastel do?!")
					$AnimationPlayer.play("Shake")
					$AnimationPlayer.queue("Shake")
					yield(textbox.label, "on_queue_end")
					yield(get_tree().create_timer(2), "timeout")
					textbox.newline()
					var dmg = round(((randi()%10) + 10) * bmult)
					var lmp = round(((randi()%5) + 1) * bmult)
					if status.has("Defending"):
						dmg = round(dmg / 2)
					hp -= dmg
					mp -= lmp
					textbox.add_to_queue("You lose %s HP and %s MP." % [dmg, lmp])
					yield(textbox.label, "on_queue_end")
					yield(get_tree().create_timer(3), "timeout")
					textbox.hide()
					textbox.clear()

				elif action == 4:
					textbox.clear()
					textbox.set_name("")
					textbox.set_blip(null)
					textbox.show()
					if (randf() > 0.8) or miracle.asked_for_mercy_twice:
						$Magic.play()
						textbox.add_to_queue("Bernkastel traps you inside a fragment!")
						$AnimationPlayer.play("FadeToBlack3")
						yield($AnimationPlayer, "animation_finished")
						$Ahaha.play()
						yield(get_tree().create_timer(1.25), "timeout")
						textbox.clear()
						$Boom.play()
						textbox.add_to_queue("...!")
						randomize()
						var dmg = round(((randi()%25) + 5) * bmult)
						hp -= dmg
						textbox.newline()
						textbox.add_to_queue("You lose %s HP." %dmg)
						$AnimationPlayer.play("Shake")
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(2), "timeout")
						$Glassbreak.play()
						$AnimationPlayer.play_backwards("FadeToBlack3")
						yield($AnimationPlayer, "animation_finished")
					else:
						textbox.add_to_queue("Bernkastel spawns some fragments. All of them fly towards you quickly!")
						yield(textbox.label, "on_queue_end")
						var num = randi()%5 + 2
						for i in range(num):
							$Glassbreak.play()
							$AnimationPlayer.queue("Shake")
							yield(get_tree().create_timer(1.13), "timeout")
						var dmg = round((3 * num) * bmult)
						hp -= dmg
						textbox.newline()
						textbox.add_to_queue("You lose %s HP." %dmg)
						yield(textbox.label, "on_queue_end")
						yield(get_tree().create_timer(3), "timeout")
					textbox.clear()
					textbox.hide()
				can_press = true
				if status.has("Defending"):
					status.remove(status.find("Defending"))
				randomize()
				if hp > 0:
					textbox.hide()
					gamepanel.show()
					return
				else:
					textbox.clear()
					textbox.set_name("")
					textbox.set_blip(null)
					$AnimationPlayer.play("FadeMusic")
					yield($AnimationPlayer, "animation_finished")
					textbox.show()
					textbox.set_speed(1, 8)
					textbox.label.push_align(1)
					textbox.add_to_queue("You have no more energy to keep going...")
					yield(textbox.label, "on_queue_end")
					yield(get_tree().create_timer(3), "timeout")
					textbox.set_color(Color(1, 0, 0, 1))
					textbox.newline()
					textbox.label.push_align(1)
					$AnimationPlayer.play("FadeToBlack5")
					yield($AnimationPlayer, "animation_finished")
					yield(get_tree().create_timer(3), "timeout")
					$Redtruth.play()
					textbox.add_text("You have lost to the witch of miracles.")
					yield(get_tree().create_timer(2), "timeout")
					$Ahaha.play()
					yield(get_tree().create_timer(6), "timeout")
					miracle.load_scene("res://src/gameover.tscn")
		else:
			bfinal_preparing -= 1
			if bfinal_preparing <= 0:
				textbox.clear()
				textbox.set_name("Bernkastel")
				textbox.set_blip(textbox.blips.blip60echo)
				$AnimationPlayer.play("FadeMusic")
				yield($AnimationPlayer, "animation_finished")
				$AnimationPlayer.play("FadeToBlack3")
				yield($AnimationPlayer, "animation_finished")
				$Bernkastel.hide()
				$BernkastelOugon.show()
				$Ahaha.play()
				yield(get_tree().create_timer(1.25), "timeout")
				$AnimationPlayer.play_backwards("FadeToBlack3")
				yield($AnimationPlayer, "animation_finished")
				yield(get_tree().create_timer(3), "timeout")
				textbox.show()
				$Redtruth.play()
				textbox.set_color(Color(1, 0, 0, 1))
				textbox.add_text("\"This is when you die...\"")
				yield(get_tree().create_timer(3), "timeout")
				textbox.set_color(Color(1, 1, 1, 1))
				textbox.newline()
				textbox.add_to_queue("\"Kill that pitiful being, kitties.\"")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(3), "timeout")
				textbox.hide()
				$AnimationPlayer.play("FadeToBlack3")
				yield($AnimationPlayer, "animation_finished")
				$Flange.play()
				yield(get_tree().create_timer(1.25), "timeout")
				$AnimationPlayer.play("CatDeath")
				yield($AnimationPlayer, "animation_finished")
				yield(get_tree().create_timer(2), "timeout")
				miracle.load_scene("res://src/gameover.tscn")

			else:
				textbox.clear()
				textbox.set_name("")
				textbox.set_blip(null)
				textbox.show()
				$Flange.play()
				textbox.add_to_queue("Bernkastel is still preparing her final attack... %s turn(s) left." %bfinal_preparing)
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(4), "timeout")
				textbox.hide()
				textbox.clear()
				gamepanel.show()
				can_press = true
	if status.has("Defending"):
		status.remove(status.find("Defending"))
	randomize()

func _on_Attack_pressed():
	if can_press:
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		gamepanel.hide()
		textbox.show()

		var dmg = randi()%15

		if bstatus.has("Defending"):
			dmg = round((dmg * mult) / 2)

		textbox.add_to_queue("You attack Bernkastel!")
		textbox.newline()
		yield(textbox.label, "on_queue_end")
		bhp -= dmg
		yield(get_tree(), "idle_frame")
		textbox.add_to_queue("Bernkastel took %s damage." %str(dmg))
		if dmg > 0:
			$AnimationPlayer.play("BernAttacked")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.hide()
		textbox.clear()
		new_turn()

func _on_Defend_pressed():
	if can_press:
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		gamepanel.hide()
		textbox.show()

		textbox.add_to_queue("You adopt a defensive stance.")
		status.append("Defending")

		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")

		textbox.hide()
		textbox.clear()
		new_turn()

func _on_Magic_pressed():
	if can_press:
		$"GamePanel/HBoxContainer/Panel".set_current_tab(1)

func _on_Acknowledge_pressed():
	if can_press:
		can_press = false
		gamepanel.hide()
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		var rmp = round(((randi()%5) + 1) * mult)
		textbox.add_to_queue("You acknowledge the existence of magic and recover %s MP." % rmp)
		mp += rmp
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.hide()
		textbox.clear()
		gamepanel.show()
		can_press = true
		new_turn()

func _on_Mercy_pressed():
	if can_press:
		can_press = false
		if not miracle.asked_for_mercy:
			miracle.asked_for_mercy = true
			gamepanel.hide()
			textbox.clear()
			textbox.set_name("Bernkastel")
			textbox.show()
			textbox.set_blip(textbox.blips.blip60)
			if not bfinal_preparing:
				textbox.add_to_queue("\"Don't worry, your death will be quick and painless...\"")
			else:
				textbox.add_to_queue("\"......Oh. So you're scared. ")
				yield(textbox.label, "on_queue_end")
				yield(get_tree().create_timer(2), "timeout")
				$Giggle.play()
				textbox.add_to_queue("*giggle* How pitiful...\"")
			yield(textbox.label, "on_queue_end")
			yield(get_tree().create_timer(2), "timeout")
			textbox.clear()
			textbox.hide()
			can_press = true
			gamepanel.show()
		else:
			miracle.asked_for_mercy_twice = true
			gamepanel.hide()
			textbox.clear()
			textbox.set_name("Bernkastel")
			textbox.show()
			textbox.set_blip(textbox.blips.blip60)
			textbox.add_to_queue("\"You are... VERY annoying.\"")
			yield(textbox.label, "on_queue_end")
			textbox.newline()
			yield(get_tree().create_timer(3), "timeout")
			textbox.set_color(Color(1, 0, 0, 1))
			$Redtruth.play()
			if not bfinal_preparing:
				textbox.add_text("\"I will NOT have mercy!\"")
			else:
				textbox.add_text("\"This is when you die!\"")
				yield(get_tree().create_timer(2), "timeout")
				$Blood.play()
				yield(get_tree().create_timer(1), "timeout")
				$Flange.play()
				$AnimationPlayer.play("FadeToBlack5")
				for i in range(0, 5):
					i = i+1
					yield(get_tree().create_timer(1), "timeout")
					$Blood.play()
					if i <= 2:
						yield(get_tree().create_timer(0.15), "timeout")
						$Blood.play()
					$ColorRect.show()
					$ColorRect.set_frame_color(Color8(0, 0, 0, (255/i)))
				$ColorRect.set_frame_color(Color(0, 0, 0, 1))
				yield(get_tree().create_timer(2), "timeout")
				miracle.load_scene("res://src/gameover.tscn")
			yield(get_tree().create_timer(4), "timeout")
			textbox.hide()
			textbox.clear()
			textbox.set_color(Color(1, 1, 1, 1))
			gamepanel.show()
			yield(get_tree().create_timer(1), "timeout")
			$Glassbreak.play()
			mercy_button.set_disabled(true)
			yield(get_tree().create_timer(2), "timeout")
			can_press = true

func _on_Runaway_pressed():
	if can_press and not runaway_button.is_disabled():
		can_press = false
		miracle.tried_to_run_away = true
		gamepanel.hide()
		textbox.clear()
		textbox.set_name("Bernkastel")
		textbox.show()
		textbox.set_color(Color(1, 0, 0, 1))
		$Redtruth.play()
		textbox.add_text("\"You cannot run away!\"")
		yield(get_tree().create_timer(4), "timeout")
		textbox.hide()
		textbox.set_color(Color(1, 1, 1, 1))
		gamepanel.show()
		yield(get_tree().create_timer(1), "timeout")
		$Glassbreak.play()
		runaway_button.set_disabled(true)
		yield(get_tree().create_timer(2), "timeout")
		can_press = true

func _on_MinorHeal_pressed():
	if can_press and mp >= 2:
		mp -= 2
		$"GamePanel/HBoxContainer/Panel".set_current_tab(0)
		gamepanel.hide()
		var hl = (randi()%9) + 1
		hp += hl
		textbox.hide()
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		textbox.add_to_queue("You recover %s HP." %hl)
		$AnimationPlayer.play("ScreenGreen")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.hide()
		textbox.clear()
		new_turn()

func _on_MagicMissile_pressed():
	if can_press and mp >= 5:
		mp -= 5
		can_press = false
		$"GamePanel/HBoxContainer/Panel".set_current_tab(0)
		gamepanel.hide()
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		randomize()
		var dmg = (randi()%15) + 1
		if bstatus.has("Defending"):
			dmg = round((dmg * mult) / 2)
		var missiles = (randi()%3) + 1
		dmg = dmg * missiles
		match missiles:
			3:
				textbox.add_to_queue("You summon three magic missiles!")
			2:
				textbox.add_to_queue("You summon two magic missiles!")
			1:
				textbox.add_to_queue("You summon a magic missile.")
			_:
				assert typeof(missiles) == TYPE_INT
				assert missiles <= 3
				assert missiles > 0
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(2), "timeout")
		textbox.newline()
		textbox.add_to_queue("Bernkastel took %s damage." %str(dmg))
		if dmg > 0:
			$AnimationPlayer.play("BernAttacked")
			$Boom.play()
		bhp -= dmg
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.hide()
		textbox.clear()
		new_turn()

func _on_MagicPunch_pressed():
	if can_press and mp == 15:
		mp -= 15
		can_press = false
		$"GamePanel/HBoxContainer/Panel".set_current_tab(0)
		gamepanel.hide()
		textbox.clear()
		textbox.set_name("")
		textbox.set_blip(null)
		textbox.show()
		randomize()
		var dmg = round(((randi()%30) + 1) * mult)
		var shock = (randi()%5) + 1
		match shock:
			4:
				bstatus.append("Shocked....")
			3:
				bstatus.append("Shocked...")
			2:
				bstatus.append("Shocked..")
			1:
				bstatus.append("Shocked.")
			_:
				assert typeof(shock) == TYPE_INT
				assert shock <= 4
				assert shock > 0
		textbox.add_to_queue("You concentrate all your energy in your fist...")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.clear()
		textbox.set_shake(Vector2(1, 1))
		textbox.add_to_queue("...And you PUNCH Bernkastel in the face!")
		textbox.newline()
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(2), "timeout")
		for i in range(shock):
			$Glassbreak.play()
			yield(get_tree().create_timer(0.25), "timeout")
			textbox.add_to_queue("...")
			yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.clear()
		textbox.set_shake(Vector2(0, 0))
		bhp -= dmg
		textbox.add_to_queue("Bernkastel took %s damage." %str(dmg))
		textbox.newline()
		if dmg > 0:
			$AnimationPlayer.play("BernAttacked")
		yield(textbox.label, "on_queue_end")
		textbox.add_to_queue("Bernkastel is shocked and cannot move!")
		yield(textbox.label, "on_queue_end")
		yield(get_tree().create_timer(3), "timeout")
		textbox.hide()
		textbox.clear()
		new_turn()

func _on_Back_pressed():
	if can_press:
		$"GamePanel/HBoxContainer/Panel".set_current_tab(0)

func _process(delta):
	if hp < 0:
		hp = 0
	if hp > 100:
		hp = 100
	if bhp < 0:
		bhp = 0
	if bhp > 100:
		bhp = 100
	if mp < 0:
		mp = 0
	if mp > 15:
		mp = 15
	hp_label.set_text("HP %s/100" %str(hp))
	mp_label.set_text("MP %s/15" %str(mp))
	var statuses = "no status"
	for st in status:
		if statuses == "no status":
			statuses = ""
		statuses += "[%s] " %st
	status_label.set_text(statuses)
	bhp_label.set_text("HP %s/100" %str(bhp))
	var bstatuses = "no status"
	for st in bstatus:
		if bstatuses == "no status":
			bstatuses = ""
		bstatuses += "[%s] " %st
	bstatus_label.set_text(bstatuses)
	magic_button.set_disabled(status.has("Silenced") or mp == 0)
	acknowledge_button.set_disabled(status.has("Silenced") or mp == 15)
	minorheal_button.set_disabled(not (mp >= 2))
	magicmissile_button.set_disabled(not (mp >= 5))
	magicpunch_button.set_disabled(not (mp == 15))
