extends Node2D

var timePassed = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	timePassed += delta
	if timePassed >= 0.3:
		queue_free()
