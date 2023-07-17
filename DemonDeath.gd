extends CharacterBody2D


var demon = 0
var swapTimeout = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0, -500)
	$Sprite2D.texture = load("res://demons/boss_{num}.png".format({"num": demon}))
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if swapTimeout > 0:
		swapTimeout -= delta
		if swapTimeout <= 0:
			$Sprite2D.texture = load("res://demons/boss_{num}.png".format({"num": demon+1}))
	
	rotation += 2 * PI * delta
	velocity.y += 500 * delta
	move_and_slide()
	pass
