extends Control

@onready var root : Root = get_tree().get_first_node_in_group("root")
@onready var letter1 = $VBoxContainer/Letters/Letter1
@onready var letter2 = $VBoxContainer/Letters/Letter2
@onready var letter3 = $VBoxContainer/Letters/Letter3
var alph := ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
var letters := []
var letter_selected := 0
var censor_list = [[0, 0, 0],[0, 18, 18], [5, 20, 2], [5, 20, 10], [5, 0, 6], [5, 20, 23], [13, 8, 6], [4, 5, 13], [21, 0, 6], [2, 20, 12], [18, 7, 19], [18, 7, 8]] # [22, 3, 6]
var current_index := [0,0,0]
var player_name := ""
var not_done := true

func _ready() -> void:
	letter_selected = 0
	letters = [letter1, letter2, letter3]
	current_index = [0,0,0]
	self.get_node("VBoxContainer/Score").text = str(root.score)
	self.visible = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if(is_visible()):
		var count = 0
		for i in letters:
			i.text = alph[current_index[count]]
			if(letter_selected == count):
				letters[letter_selected].add_theme_color_override("font_color", Color(0.039, 1.0, 0.322, 1.0))
			else:
				i.add_theme_color_override("font_color", Color(255, 255, 255))
			count += 1
		if(Input.is_action_just_pressed("left")):
			if(letter_selected == 0):
				letter_selected = 2
			else:
				letter_selected = letter_selected - 1
		if(Input.is_action_just_pressed("right")):
			if(letter_selected == 2):
				letter_selected = 0
			else:
				letter_selected = letter_selected + 1
		if(Input.is_action_just_pressed("up")):
			if(current_index[letter_selected] == 0):
				current_index[letter_selected] = 25
			else:
				current_index[letter_selected] = current_index[letter_selected] - 1
			letters[letter_selected].text = alph[current_index[letter_selected]]
		if(Input.is_action_just_pressed("down")):
			if(current_index[letter_selected] == 25):
				current_index[letter_selected] = 0
			else:
				current_index[letter_selected] = current_index[letter_selected] + 1
			letters[letter_selected].text = alph[current_index[letter_selected]]
		if(not_done && Input.is_action_just_pressed("rewind")):
			var censor_check = [false, false, false]
			var good := true
			for word in censor_list:
				for i in range(3):
					if(word[i] == current_index[i]):
						censor_check[i] = true
				if(censor_check[0] && censor_check[1] && censor_check[2]):
					good = false
					break
				censor_check = [false, false, false]
			if(good):
				player_name = alph[current_index[0]] + alph[current_index[1]] + alph[current_index[2]]
				if (current_index[0] == 22 and current_index[1] == 3 and current_index[2] == 6):
					player_name = "???"
				root.save_score()
				not_done = false
				
				root.switch_scene("res://Scenes/high_score_display.tscn")
