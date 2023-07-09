extends Control

# Path to the next scene to transition to
@export_file("*.tscn") var next_scene_path

# Reference to the _AnimationPlayer_ node
@onready var _anim_player := $AnimationPlayer

var gameScene = preload("res://game.tscn")
var currentScene = null

func _ready():
	transition_to(gameScene.instantiate())
	pass
	# Plays the animation backward to fade in

func transition_to_game():
	get_tree().change_scene()

func transition_to(next_scene) -> void:
	# Plays the Fade animation and wait until it finishes
	if currentScene != null:
		_anim_player.play_backwards("Fade")
		await _anim_player.animation_finished

	if currentScene != null:
		currentScene.queue_free()
		currentScene = null

	if next_scene != null:
		currentScene = next_scene
		$Scene.add_child(currentScene)

	_anim_player.play("Fade")
	await _anim_player.animation_finished
	
