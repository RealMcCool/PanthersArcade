extends Control


#var button_grabbed := 0

func _ready() -> void:
	$VBoxContainer/PlayButton.grab_focus()
	#button_grabbed = 0


func _on_play_button_pressed() -> void:
	ButtonSounds.play()
	#get_tree().change_scene_to_file("res://Scenes/game.tscn")
	get_tree().get_first_node_in_group("root").switch_scene("res://Scenes/game.tscn")


func _on_quit_button_pressed() -> void:
	ButtonSounds.play()
	#get_tree().change_scene_to_file("res://Scenes/title_screen.tscn")
	get_tree().get_first_node_in_group("root").switch_scene("res://Scenes/title_screen.tscn")

#func _physics_process(delta: float) -> void:
	#if Input.is_action_just_pressed("down") or Input.is_action_just_pressed("up"):
		#button_grabbed+=1
		#if button_grabbed>1:
			#button_grabbed = 0
		#if button_grabbed == 1:
			#$VBoxContainer/QuitButton.grab_focus()
		#else:
			#$VBoxContainer/PlayButton.grab_focus()
	#if Input.is_action_just_pressed("rewind"):
		#if button_grabbed == 1:
			#$VBoxContainer/QuitButton.pressed.emit()
		#else:
			#$VBoxContainer/PlayButton.pressed.emit()
