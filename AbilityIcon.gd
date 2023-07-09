@tool
extends Node2D

@export var ability_name = "spikes"
@export var clickable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match ability_name:
		"e":
			$Sprite2D.texture = load("res://abilities/frame.png")
		"m":
			$Sprite2D.texture = load("res://abilities/frame_m.png")
		"h":
			$Sprite2D.texture = load("res://abilities/frame_h.png")
		_:
			$Sprite2D.texture = load("res://abilities/attack_{name}.png".format({"name": ability_name}))	
	pass


func _on_input_event(viewport, event, shape_idx):
	if "pressed" in event && event.pressed && clickable:
		print("1")
		get_node("../../../Abilities").move(self)
