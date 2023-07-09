extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



var deathTimeout = 0.4
var section = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deathTimeout -= delta
	
	if deathTimeout > section:
		for body in get_overlapping_bodies():
			body.damage(1)
	if deathTimeout < section:
		$Sprite2D.modulate = Color(1, 1 , 1, deathTimeout/section)
		$Sprite2D2.modulate = Color(1, 1 , 1, deathTimeout/section)
		$Sprite2D3.modulate = Color(1, 1 , 1, deathTimeout/section)
		$Sprite2D4.modulate = Color(1, 1 , 1, deathTimeout/section)
	if deathTimeout <= 0:
		queue_free()
	pass

