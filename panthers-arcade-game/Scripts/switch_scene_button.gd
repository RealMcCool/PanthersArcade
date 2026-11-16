extends Button

@export_file("*.tscn") var scene : String

func _on_pressed() -> void:
	ButtonSounds.play()
	get_tree().get_first_node_in_group("root").switch_scene(scene)
