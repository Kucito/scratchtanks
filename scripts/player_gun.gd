extends Node2D 

const ROTATION_SPEED = 2.0 
var can_shoot = true 
var cooldown_timer = 0.0 
var bullet_spawn_distance = 212 

func _process(delta):
	if is_multiplayer_authority():
		look_at(get_global_mouse_position())
		
		if Input.is_action_pressed("shoot") and can_shoot:
			
			spawn_bullet.rpc(global_position, global_rotation)
			can_shoot = false
			cooldown_timer = 0.0
		
		if not can_shoot:
			cooldown_timer += delta
			if cooldown_timer >= 0.2: 
				can_shoot = true

@rpc("any_peer", "call_local")
func spawn_bullet(pos, rot):
	var bullet_scene = load("res://scenes/Bullet.tscn")
	var bullet_instance = bullet_scene.instantiate()
	
	var spawn_position = pos + Vector2.RIGHT.rotated(rot) * bullet_spawn_distance
	bullet_instance.global_position = spawn_position
	bullet_instance.global_rotation = rot
	
	get_node("/root/Game/Multiplayer").add_child(bullet_instance)
