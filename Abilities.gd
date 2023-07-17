extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	match arena:
		1: get_tree().root.get_child(0).play_music(load("res://unknown.wav"))
		2: get_tree().root.get_child(0).play_music(load("res://dungeon.wav"))
		3: get_tree().root.get_child(0).play_music(load("res://sky.wav"))
		4: get_tree().root.get_child(0).play_music(load("res://prepare.wav"))
		5: get_tree().root.get_child(0).play_music(load("res://finalbattle.wav"))
	
	var arenaInstance = load("res://arenas/Arena{num}.tscn".format({"num": arena})).instantiate()
	arenaInstance.position = Vector2(0, 0)
	add_child(arenaInstance)
	move_child(arenaInstance, 0)

	types = [typesString[0], typesString[1], typesString[2]]
	updateSelected()

	if not "h" in types:
		$Node2D7.visible = false
		$Node2D8.visible = false
		$Node2D9.visible = false

	if not "m" in types:
		$Node2D4.visible = false
		$Node2D5.visible = false
		$Node2D6.visible = false

	pass # Replace with function body.

var selected_attacks = []

var arena = 0
var typesString = "emm"
var types = ["e", "m", "h"]
@onready var slot1 = $AbilityIcon2
@onready var slot2 = $AbilityIconMid
@onready var slot3 = $AbilityIcon3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func remove_last():
	pass

func get_type_by_name(name):
	match name:
		"slam": return "e"
		"lazers": return "e"
		"disk": return "e"
		"axes": return "m"
		"electric_field": return "m"
		"explosion": return "m"
		"bounce": return "h"
		"spikes": return "h"
		"roll": return "h"

func updateSelected():
	slot1.ability_name = types[0]
	slot2.ability_name = types[1]
	slot3.ability_name = types[2]
	if (len(selected_attacks) >= 1): slot1.ability_name = selected_attacks[0]
	if (len(selected_attacks) >= 2): slot2.ability_name = selected_attacks[1]
	if (len(selected_attacks) >= 3): slot3.ability_name = selected_attacks[2]

func move(ability_icon):
	if (len(selected_attacks) > 2 or ability_icon.ability_name in selected_attacks): return
	var name = ability_icon.ability_name
	if (get_type_by_name(name) == types[len(selected_attacks)]):
		selected_attacks.append(name)
		updateSelected()
	
	if len(selected_attacks) == 3:
		await get_tree().create_timer(1).timeout # waits for 1 second
		print(selected_attacks)

		get_tree().root.get_child(0).goto_level(selected_attacks)
func _on_area_2d_input_event(viewport, event, shape_idx):
	if "pressed" in event && event.pressed:
		selected_attacks.pop_back()
		updateSelected()
