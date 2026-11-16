extends Control

var uilife_scene = preload("res://Scenes/ui_life.tscn")
var uilife_2_scene = preload("res://Scenes/ui_life_2.tscn")
var uilife_3_scene = preload("res://Scenes/ui_life_3.tscn")
var uilife_4_scene = preload("res://Scenes/ui_life_4.tscn")

@onready var lives = $Lives
var default_lives
var list_to_remove : Array[Node]

func _ready() -> void:
	default_lives = get_tree().get_first_node_in_group("game").default_lives


 # INFO: Sets the number of lives displayed in the UI to be equal to a new amount
func init_lives(amount:int):
	for u in lives.get_children():
		u.queue_free()
	fill_by_amount(amount)


func fill_by_amount(amount:int) -> void:
	var amount_of_1 := 0
	var amount_of_2 := 0
	var amount_of_3 := 0
	var amount_of_4 := 0
	if amount <= 5:
		amount_of_1 = amount
	elif amount > 5 and amount < 11:
		amount_of_2 = amount-5
		amount_of_1 = 5-amount_of_2
	elif amount > 10 and amount < 16:
		amount_of_3 = amount-10
		amount_of_2 = 5-amount_of_3
	elif amount > 15:
		amount_of_4 = amount-15
		amount_of_3 = 5-amount_of_4
	for i in amount_of_4:
		var ul = uilife_4_scene.instantiate()
		lives.add_child(ul)
	for i in amount_of_3:
		var ul = uilife_3_scene.instantiate()
		lives.add_child(ul)
	for i in amount_of_2:
		var ul = uilife_2_scene.instantiate()
		lives.add_child(ul)
	for i in amount_of_1:
		var ul = uilife_scene.instantiate()
		lives.add_child(ul)
	
