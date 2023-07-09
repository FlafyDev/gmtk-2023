extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	

var deathTimeout = 0.2

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	deathTimeout -= delta
	if deathTimeout <= 0:
		queue_free()
	pass

func _physics_process(delta):
	var bodies = get_overlapping_bodies();
	for body in bodies:
		if body.is_on_floor():
			body.velocity.y += body.JUMP_VELOCITY * 1
