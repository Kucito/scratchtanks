extends CharacterBody2D

@export var SPEED = 300
@export var ROTATION_SPEED = 3
@export var MAX_HEALTH = 100
var health = MAX_HEALTH

@onready var health_bar = $HealthBar/ProgressBar

func _ready():
	health = MAX_HEALTH
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health
	
	# Make health bar ignore parent rotation
	$HealthBar.top_level = true

func _process(delta):
	var direction = Vector2.ZERO
	var forward = Vector2(cos(rotation), sin(rotation))

	if Input.is_action_pressed("ui_right"):
		rotation += ROTATION_SPEED * delta
	if Input.is_action_pressed("ui_left"):
		rotation -= ROTATION_SPEED * delta
	if Input.is_action_pressed("ui_up"):
		direction += forward * SPEED * delta 
	if Input.is_action_pressed("ui_down"):
		direction -= forward * SPEED * delta  

	velocity = direction.normalized() * SPEED
	
	move_and_slide()
	
	# Update health bar position to follow player but ignore rotation
	$HealthBar.global_position = global_position + Vector2(-100, 100)

func take_damage(amount):
	health -= amount
	health_bar.value = health
	if health <= 0:
		die()
		
func die():
	queue_free() 
