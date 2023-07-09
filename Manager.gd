extends Control

# Path to the next scene to transition to
@onready var _anim_player := $AnimationPlayer

var gameScene = preload("res://game.tscn")
var abilitiesScene = preload("res://Abilities.tscn")
var currentScene = null

var arena = 5
var arena_types = [
	"eee", # unused
	"eem",
	"emm",
	"emh",
	"mmh",
	"mhh",
]


func _ready():
	# goto_level([	"axes",
	# "spikes",
	# "electric_field",
	# "slam",
	
	# "lazers",
	# "roll",
	# "explosion",
	# "bounce",
	# "disk",])
	goto_level(["disk", "lazers", "slam"])
	# goto_abilities_selction("eee")
	# transition_to(gameScene.instantiate())
	pass
	# Plays the animation backward to fade in

func transition_to_game():
	get_tree().change_scene()

func goto_abilities_selction(type = null):
	if (arena == 6):
		transition_to(load("res://arenas/End.tscn").instantiate())
		return

	if (type == null):
		type = arena_types[arena]
	
	var instance = abilitiesScene.instantiate()
	instance.arena = arena
	instance.typesString = type
	transition_to(instance)
	
func goto_level(abilities, demon = null):
	if (demon == null):
		demon = arena
	
	var instance = gameScene.instantiate()
	instance.abilities = abilities
	instance.demon = arena
	instance.arena = arena
	transition_to(instance)

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
	
