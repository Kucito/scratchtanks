extends Node2D  # Or KinematicBody2D, CharacterBody2D, etc.

const ROTATION_SPEED = 2.0  # Radians per second

func _process(delta):
	look_at(get_global_mouse_position())
