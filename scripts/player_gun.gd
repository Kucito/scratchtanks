extends Node2D 

const ROTATION_SPEED = 2.0 
var can_shoot = true 
var cooldown_timer = 0.0 
var bullet_spawn_distance = 212 

func _process(delta):
	look_at(get_global_mouse_position())
	
	if Input.is_action_pressed("shoot") and can_shoot:
		shoot()
		can_shoot = false
		cooldown_timer = 0.0
	
	if not can_shoot:
		cooldown_timer += delta
		if cooldown_timer >= 0.2: 
			can_shoot = true

func shoot():
	
	var bullet_scene = preload("res://scenes/bullet.tscn")
	var bullet_instance = bullet_scene.instantiate()
	
	
	var spawn_position = global_position + Vector2.RIGHT.rotated(global_rotation) * bullet_spawn_distance
	bullet_instance.global_position = spawn_position
	bullet_instance.global_rotation = global_rotation
	
	
	get_tree().current_scene.add_child(bullet_instance)
