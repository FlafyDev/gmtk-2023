extends Area2D

var direction = 1
var velocity = Vector2.ZERO;

# Called when the node enters the scene tree for the first time.

func _ready():
	velocity = Vector2(0, -20);
	pass # Replace with function body.

var timePassed = 0;

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	velocity.x = 500 * delta * direction
	velocity.y += 50 * delta
  
	rotation += direction * delta * 2 * PI * 2
	position += velocity

	timePassed += delta
	if timePassed >= 10:
		queue_free()

	var bodies = get_overlapping_bodies();
	for body in bodies:
			body.damage(1)
