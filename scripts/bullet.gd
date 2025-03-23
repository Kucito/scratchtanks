extends Node2D

@export var speed: float = 1500.0
@export var DAMAGE: int = 10
var lifetime: float = 0.0

func _physics_process(delta: float) -> void:
	
	position += Vector2.RIGHT.rotated(global_rotation) * speed * delta
	lifetime += delta
	if lifetime >= 1.0:
		 
		if multiplayer.is_server():
			queue_free()

func _on_body_entered(body):
	if multiplayer.is_server():
		print("server hit")
	else:	
		print("client hit")
	if body.is_in_group("player") and body.has_method("take_damage"):
		body.take_damage(DAMAGE)
		queue_free()
	else:
		queue_free()
