class_name Root extends Node


var score := 0


func switch_scene(new_scene: String) -> void:
	for i in $ActiveScene.get_children():
		i.queue_free()
	var new_scene_loaded : PackedScene = load(new_scene)
	var new_scene_node : Node = new_scene_loaded.instantiate()
	$ActiveScene.add_child(new_scene_node)


#region Save and Load

#save_score() is called when the player dies and the game is over
#load_scores() is called in the _ready() function

@export_global_dir var save_data_path := "user://save_data.tres"
@export var save_data : SaveData

func save_score() -> void:
	ResourceSaver.save(save_data, save_data_path)


func load_scores() -> void:
	save_data = ResourceLoader.load(save_data_path)
	if save_data == null:
		save_data = load("res://Z - Other files/default_save_data.tres")
#endregion
