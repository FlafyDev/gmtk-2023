extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():

	get_tree().root.get_child(0).play_music(load("res://music1.wav"))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().root.get_child(0).start()
	pass
