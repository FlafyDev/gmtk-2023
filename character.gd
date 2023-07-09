extends CharacterBody2D

const SPEED = 180
const JUMP_SPEED = -1700
const GRAVITY = 6000
const DAMPING = 0.7

var ability_cycle = [
	# "lazers",
	# "roll",
	# "explosion",
	# "bounce",
	# "disk",
] 

var cycle_index = 0

var activated_abilities = [
	# "axes",
	# "spikes",
	# "electric_field",
	# "slam",
]

@onready var collision = $CollisionShape2D 
@onready var prelazers = $PreLazers
@onready var hero = get_node("../Hero")
@onready var camera = get_node("../Camera2D")

var lazersScene = preload("res://lazers.tscn")
var spikeScene = preload("res://DemonSpike.tscn")
var diskScene = preload("res://Disk.tscn")
var axeScene = preload("res://Axe.tscn")
var explosionScene = preload("res://Explosion.tscn")
var slamAttackScene = preload("res://SlamAttack.tscn")
var lightningScene = preload("res://Lightning.tscn")
var lastDirection = 1
var invincTimer = 0
var maxHp = 5
var hp = maxHp
var abilityMarginTime = 6
var abilityTimer = 1

func _ready():
	randomize()
	hp = maxHp
	prelazers.visible = false
	velocity.x = 10;
	velocity.y = 1;
	abilityTimer = abilityMarginTime
	$RollDust.visible = false
	if "spikes" in activated_abilities:
		regenerate_spikes()

		# PhysicsServer2D.body_set_param(get_rid(), PhysicsServer2D.BODY_PARAM_BOUNCE, 200)

func _physics_process(delta):
	if (bounceTimer <= 0):
		move_and_slide()

	_bounceTick(delta)

	_slamTick(delta)

	_rollingTick(delta)
	
	_onLazerTick(delta)

	_onElectricFieldTick(delta)

	if abilityTimer > 0 && len(ability_cycle) > 0:
		abilityTimer -= delta
		if abilityTimer <= 0:
			doAbility(ability_cycle[cycle_index % len(ability_cycle)])
			cycle_index += 1
			abilityTimer = abilityMarginTime


	if invincTimer > 0:
		invincTimer -= delta
		visible = int(floor(invincTimer*1000/50)) % 2 == 0
		if invincTimer <= 0:
			visible = true

	for herobody in $Area2D.get_overlapping_bodies():
		herobody.damage(1)

	if "spikes" in activated_abilities:
		for child in get_children():
			if child.name.contains("DemonSpike"):
				for herobody in child.get_overlapping_bodies():
					herobody.damage(1)

	if rolling <= 0 && bounceTimer <= 0:
		velocity.x += SPEED * Input.get_axis("left", "right");
		velocity.x *= pow(1.0 - DAMPING, delta * 10)


	if is_on_floor():
		rotation += velocity.x * delta / collision.shape.radius

	# if Input.is_action_just_pressed("ability1"):
		# shoot_disk()
		# explosion()
		# regenerate_spikes()
		# lazers()
		# roll()

	# Only allow jumping when on the ground
	if Input.is_action_just_pressed("up") and is_on_floor() && bounceTimer <= 0:
		if "axes" in activated_abilities:
			axes()
		velocity.y = JUMP_SPEED 
		if "slam" in activated_abilities:
			slamTimer = 0.3

	if velocity.x != 0:
		lastDirection = sign(velocity.x)
		$RollDust.flip_h = lastDirection == -1

	$RollDust.rotation = -rotation

	if (bounceTimer <= 0):
		velocity.y += GRAVITY * delta

func damage(amount):
	if invincTimer > 0: return
	hp -= amount
	invincTimer = 2
	get_node("../DemonHealth/ProgressBar").value = float(hp) / maxHp * 100.0

	if "spikes" in activated_abilities:
		regenerate_spikes()

func doAbility(name):
	match name:
		"lazers": lazers()
		"roll": roll()
		"explosion": explosion()
		"bounce": bounce()
		"disk": shoot_disk()
		"axes": axes()
		"spikes": 0
		"electric_field": 0
		"slam": 0

func roll():
	prerolling = 2

func explosion():
	var instance = explosionScene.instantiate()
	add_child(instance)
	await get_tree().create_timer(3).timeout # waits for 1 second
	camera.add_trauma(1)

func axes():
	var instance = axeScene.instantiate()
	instance.direction = 1
	instance.position = position;
	get_tree().root.get_child(0).add_child(instance)

	instance = axeScene.instantiate()
	instance.direction = -1
	instance.position = position;
	get_tree().root.get_child(0).add_child(instance)

func shoot_disk():
	$DiskDust.emitting = true
	await get_tree().create_timer(2).timeout # waits for 1 second
	$DiskDust.emitting = false
	for x in 3:
		var instance = diskScene.instantiate()
		instance.direction = lastDirection
		get_tree().root.get_child(0).add_child(instance)
		instance.position = position;
		await get_tree().create_timer(0.3).timeout # waits for 1 second

var regenerating_spikes = false
func regenerate_spikes():
	if (regenerating_spikes): return null

	for child in get_children():
		if child.name.contains("DemonSpike"):
			child.queue_free()

	regenerating_spikes = true
	await get_tree().create_timer(1.0).timeout # waits for 1 second
	regenerating_spikes = false

	_generate_spikes()

func lazers():
	lazersTimer = 4;

func bounce():
	$Springs.emitting = true
	await get_tree().create_timer(2).timeout # waits for 1 second
	$Springs.emitting = false
	bounceTimer = 4;
	slamTimer = 0;
	velocity = velocity.normalized() * 15
	if velocity == Vector2.ZERO:
		velocity = Vector2(15, 0).rotated(-PI/4)

var bounceTimer = 0;
func _bounceTick(delta):
	if (bounceTimer > 0):
		velocity = velocity.rotated(Input.get_axis("left", "right") * PI * 1.8 * delta);
		rotation += Input.get_axis("left", "right") * PI * delta
		bounceTimer -= delta;
		var collisioninfo = move_and_collide(velocity)
		if collisioninfo:
			velocity = velocity.bounce(collisioninfo.get_normal())
			camera.add_trauma(0.3)

var activeFieldTime = 0

func _onElectricFieldTick(delta):
	if "electric_field" in activated_abilities:
		$NaturalElectricField.visible = len($ElectricFieldArea.get_overlapping_bodies()) == 0
		$ActiveElectricField.visible = !$NaturalElectricField.visible
		if ($ActiveElectricField.visible):
			activeFieldTime += delta
			if activeFieldTime >= 2:
				activeFieldTime = 0
				hero.damage(1)
				var instance = lightningScene.instantiate()
				hero.add_child(instance)
		else:
			activeFieldTime = 0
	else:
		$NaturalElectricField.visible = false
		$ActiveElectricField.visible = false
	

var slamTimer = 0;
var slammed = false;
func _slamTick(delta):
	if slamTimer > 0:
		slamTimer -= delta;
		if slamTimer <= 0:
			velocity.y = 2000;
			slammed = true;
	
	if slammed && is_on_floor():
		camera.add_trauma(0.7)

		var instance = slamAttackScene.instantiate()
		get_tree().root.get_child(0).add_child(instance)
		instance.position = position;

		slammed = false

var prerolling = 0;
var rolling = 0;
func _rollingTick(delta):
	if prerolling > 0:
		prerolling -= delta
		rotation += (2.0 - prerolling)**2 * lastDirection
		if prerolling <= 0:
			rolling = 0.9

	if rolling > 0:
		rolling -= delta
		rotation += lastDirection * PI / 4
		$RollDust.visible = true

		if is_on_wall() && is_on_floor():
			lastDirection *= -1
			velocity.y = JUMP_SPEED / 2.0;

		velocity.x = 800 * lastDirection
		if rolling <= 0:
			$RollDust.visible = false


var lazersTimer = 0;
func _onLazerTick(delta):
	if lazersTimer > 0:
		lazersTimer -= delta;
		if lazersTimer <= 0:
			prelazers.visible = false
			var instance = lazersScene.instantiate()
			get_tree().root.get_child(0).add_child(instance)
			instance.position = position;
			instance.rotation = rotation;
		else:
			prelazers.visible = int(floor(sqrt(lazersTimer * 1000))) % 2 == 0
 
func _generate_spikes():
	var angle = randf_range(0, 2*PI)
	for x in 9:
		var instance = spikeScene.instantiate()
		add_child(instance)
		move_child(instance, 0)
		if x == 0 or x == 8:
			instance.get_child(1).queue_free()
		instance.rotation = angle + x * PI / 4 / 2
	
