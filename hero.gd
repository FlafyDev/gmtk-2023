extends CharacterBody2D


const SPEED = 150.0
const JUMP_VELOCITY = -400.0

signal got_hit

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var state = "idle"
var stateTimeout = 0;
var rng = RandomNumberGenerator.new();
var direction = 0;
var canAttackTimer = 0

@onready var attackArea = $AttackArea

# var invincibilityTimeout = 0;
var hp = 3;

@onready var demon = get_node("../Demon")

func _ready():
	attackArea.visible = false
	got_hit.emit()

func set_dir(new_dir):
	if direction != new_dir:
		direction = new_dir 
		if (direction == 1):
			scale.y = 2
			rotation = 0
		elif (direction == -1):
			scale.y = -2
			rotation = PI

func damage(amount):
	if state != "invinc" && state != "dead":
		hp -= amount
		$AnimP.play("hurt")
		print(hp)		
		if hp <= 0:
			state = "dead"
			stateTimeout = 1000
			visible = true
			get_node("../../Level").heroLost()
		
		else:
			state = "invinc"
			canAttackTimer = 0
			attackArea.visible = false
			velocity = Vector2(500 * -( 1 if direction == 0 else direction ), -500)
			set_dir(0)
			stateTimeout = 2

		got_hit.emit()

func _process(delta):
	if stateTimeout > 0:
		stateTimeout -= delta
		if stateTimeout <= 0:
			if state == "attacking":
				canAttackTimer = 0.5
				await get_tree().create_timer(0.5).timeout # waits for 1 second
				if state != "attacking": return
			state = "idle"
			$AnimP.play("idle")
			set_dir(0)


	if canAttackTimer > 0:
		canAttackTimer -= delta
		attackArea.visible = true
		if canAttackTimer <= 0:
			attackArea.visible = false

	
	if state == "invinc":
		visible = int(floor(stateTimeout*1000/50)) % 2 == 0


func _physics_process(delta):
	if state == "idle" && stateTimeout <= 0:
		visible = true
		if rng.randf_range(0.0, 1.0) > 0.8:
			state = "walking"
			$AnimP.play("running")
			stateTimeout = rng.randf_range(1.0, 2.0)
			set_dir(1 if demon.position.x > self.position.x else -1)
		elif rng.randf_range(0.0, 1.0) > 0.2:
			state = "attacking"
			$AnimP.play("attacking")
			set_dir(1 if demon.position.x > self.position.x else -1)
			stateTimeout = 2
		else:
			stateTimeout = 1
	
	if state == "idle" or state == "walking":
		if rng.randf_range(0.0, 1.0) < 0.3 * delta && is_on_floor():
			velocity.y += JUMP_VELOCITY
	
	if is_on_wall():
		set_dir(-direction)

	if direction != 0 && state != "attacking" && canAttackTimer <= 0 && state != "dead":
		velocity.x = direction * SPEED
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if not is_on_floor():
		velocity.y += gravity * delta

	move_and_slide()

	if canAttackTimer > 0:
		var hit = false

		for body in attackArea.get_overlapping_bodies():
			hit = true
			
		for area in attackArea.get_overlapping_areas():
			hit = false
		
		if hit:
			demon.damage(1)


		

# func _on_attack_area_body_entered(body):
# 	if canAttackTimer > 0:
# 		canAttackTimer = 0
# 		damage(1)


