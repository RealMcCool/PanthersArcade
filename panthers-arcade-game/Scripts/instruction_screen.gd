extends Control


func _ready() -> void:
	$VBoxContainer/PlayButton.grab_focus()


func _on_play_button_pressed() -> void:
	ButtonSounds.play()
	get_tree().get_first_node_in_group("root").switch_scene("res://Scenes/game.tscn")


func _on_quit_button_pressed() -> void:
	ButtonSounds.play()
	get_tree().get_first_node_in_group("root").switch_scene("res://Scenes/title_screen.tscn")
