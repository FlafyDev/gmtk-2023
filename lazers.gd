extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.



var deathTimeout = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deathTimeout -= delta
	if deathTimeout <= 0:
		queue_free()
	pass


# body will always be hero
func _on_body_entered(body):
	body.damage(2)
	queue_free()
	
