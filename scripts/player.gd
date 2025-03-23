extends CharacterBody2D

@export var SPEED = 300
@export var ROTATION_SPEED = 3
@export var MAX_HEALTH = 100
var health = MAX_HEALTH

@onready var health_bar = $HealthBar/ProgressBar

func _enter_tree():
	set_multiplayer_authority(name.to_int())

func _ready():
	health = MAX_HEALTH
	health_bar.max_value = MAX_HEALTH
	health_bar.value = health
	
	
	$HealthBar.top_level = true
	
	
	$Camera2D.enabled = is_multiplayer_authority()

func _physics_process(delta):
	if is_multiplayer_authority():
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

func _process(_delta):
	$HealthBar.global_position = global_position + Vector2(-100, 100)

func take_damage(amount):
	health -= amount
	
	sync_health.rpc(health)
	
	if health <= 0:
		die()

func die():
	
	if multiplayer.is_server():
		var multiplayer_node = get_node_or_null("/root/Game/Multiplayer")
		if multiplayer_node:
			multiplayer_node.handle_player_death(name.to_int())
	
	await get_tree().create_timer(0.5).timeout
	queue_free()

@rpc("authority", "call_local")
func sync_health(new_health):
	health = new_health
	health_bar.value = health
