extends Node2D

@onready var hero = get_node("../Hero")

# Called when the node enters the scene tree for the first time.
func _ready():
	hero.connect("got_hit", Callable(self, "_hero_got_hit"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _hero_got_hit():
	for x in range(1,4):
		get_node("Heart"+str(x)).visible = hero.hp >= x

