extends Area2D

var circleRadius = 400
var time = 3.0
var explosionIncreaseTimer = 1.0 # Dummy value

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.shape.radius = circleRadius
	explosionIncreaseTimer = time
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if explosionIncreaseTimer > 0:
		explosionIncreaseTimer -= delta

		if explosionIncreaseTimer <= 0:
			explosionIncreaseTimer = 0
			for body in get_overlapping_bodies():
				body.damage(1)
			queue_free()
		else:
			queue_redraw()

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 32
	var points_arc = PackedVector2Array()

	for i in range(nb_points + 1):
			var angle_point = deg_to_rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
			points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
			draw_line(points_arc[index_point], points_arc[index_point + 1], color)

func _draw():
	var center = Vector2.ZERO
	var angle_from = 0
	var angle_to = 360
	var color = Color(1.0, 0.0, 0.0)
	var rad = circleRadius * (1 - explosionIncreaseTimer / time)
	if explosionIncreaseTimer > 0.02:
		draw_circle_arc(center, rad, angle_from, angle_to, color)
	else:
		draw_circle(center, rad, color)
	pass # Replace with function body.
