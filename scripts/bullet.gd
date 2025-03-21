extends Node2D

@export var speed: float = 1500.0  # Bullet speed in pixels per second
var lifetime: float = 0.0  # Track how long the bullet has existed

func _physics_process(delta: float) -> void:
    # Move forward based on the object's global rotation
    position += Vector2.RIGHT.rotated(global_rotation) * speed * delta
    
    # Update lifetime
    lifetime += delta
    if lifetime >= 1.0:  # Destroy after 1 second
        queue_free()

func _on_area_2d_body_entered(_body: Node2D) -> void:
    # Destroy the bullet when it hits something
    queue_free()
