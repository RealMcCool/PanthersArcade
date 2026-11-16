extends Control

@onready var root : Root = get_tree().get_first_node_in_group("root")
@onready var names = [$Names/Name1, $Names/Name2, $Names/Name3, $Names/Name4, $Names/Name5]
@onready var nums = [$Nums/Num1, $Nums/Num2, $Nums/Num3, $Nums/Num4, $Nums/Num5]
@onready var box1 = $Nums
@onready var box2 = $Names
@onready var list
@onready var okay := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_high_score()
	$PlayButton.grab_focus()


func update_high_score():
	okay = true
	list = root.save_data.high_score_list.duplicate()
	#print(list)
	if(list.has("")):
		list.erase("")
	var maxim := 0
	var max_name := ""
	for i in range(5):
		maxim = 0
		max_name = ""
		if(list.size() <= 0):
			names[i].text = "NA"
			nums[i].text = "0"
		else:
			for j in range(list.values().size()):
				if(list.values()[j] >= maxim):
					maxim = list.values()[j]
					max_name = list.keys()[j]
			names[i].text = max_name
			nums[i].text = str(maxim)
			list.erase(max_name)


func _input(event: InputEvent) -> void:
	if is_visible_in_tree() and event is InputEventKey and event.pressed and event.keycode == KEY_SPACE:
		_on_play_button_pressed()


func _on_play_button_pressed() -> void:
	ButtonSounds.play()
	get_tree().get_first_node_in_group("root").switch_scene("res://Scenes/title_screen.tscn")
