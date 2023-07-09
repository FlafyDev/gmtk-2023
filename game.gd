extends Node2D

var abilitiles = [
	""
]

var arena = 0 # 0 to 5
var demon = 0 # 0 to 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func heroWin():
	$Demon.queue_free()
	$YouWin.visible = true
	await get_tree().create_timer(2).timeout
	# get_tree().root.get_child(0)

func heroLost():
	# $Hero.queue_free()
	$YouLost.visible = true
	await get_tree().create_timer(2).timeout
	# get_tree().root.get_child(0).transition_to("res://path/to/Play.tscn")
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
