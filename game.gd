extends Node2D

var abilities = [ ]

var arena = 0 # 0 to 5
var demon = 0 # 0 to 5

var demonScene = preload("res://character.tscn")
var heroScene = preload("res://hero.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	var demonInstance = demonScene.instantiate()
	demonInstance.activated_abilities = abilities
	demonInstance.position = Vector2(150, 280)
	demonInstance.demon = demon
	print(demonInstance.name)
	add_child(demonInstance)

	var heroInstance = heroScene.instantiate()
	heroInstance.position = Vector2(826, 293)
	add_child(heroInstance)

	demonInstance.hero = heroInstance

	var heroHpInstance = load("res://HeroHealth.tscn").instantiate()
	heroHpInstance.position = Vector2(942, 27)
	heroHpInstance.scale = Vector2(-1, 1)
	add_child(heroHpInstance)

	var arenaInstance = load("res://arenas/Arena{num}.tscn".format({"num": demon})).instantiate()
	arenaInstance.position = Vector2(0, 0)
	add_child(arenaInstance)
	move_child(arenaInstance, 0)

  
	match arena:
		3: get_tree().root.get_child(0).play_music(load("res://sky.wav"))
		5: get_tree().root.get_child(0).play_music(load("res://finalbattle.wav"))



	# var heroInstance = demonScene.instantiate()
	# heroInstance.position = Vector2(826, 293)
	# add_child(heroInstance)
	pass # Replace with function body.

func heroWin():
	# $Demon.queue_free()
	$YouWin.visible = true
	await get_tree().create_timer(2).timeout

	get_tree().root.get_child(0).arena = arena + 1
	get_tree().root.get_child(0).goto_abilities_selction()

func heroLost():
	# $Hero.queue_free()
	$YouLost.visible = true
	await get_tree().create_timer(2).timeout
	if (arena == 0):
		get_tree().root.get_child(0).start()
	else:
		get_tree().root.get_child(0).goto_abilities_selction()
	# get_tree().root.get_child(0).transition_to("res://path/to/Play.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
