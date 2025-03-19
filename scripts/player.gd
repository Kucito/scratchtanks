extends CharacterBody2D

@export var SPEED = 300
@export var ROTATION_SPEED = 3

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
