extends Node2D

var peer = ENetMultiplayerPeer.new()
@export var player_scene: PackedScene
var spawn_points = []
var player_spawn_data = {}  # Track player spawn positions

func _ready():
	# Add your bullet scene to the spawnable scenes
	$MultiplayerSpawner._spawnable_scenes.append("res://scenes/Bullet.tscn")
	
	# Get spawn points (after a short delay to ensure Game scene is ready)
	call_deferred("_get_spawn_points")

func _get_spawn_points():
	var spawn_points_node = get_node_or_null("/root/Game/SpawnPoints")
	if spawn_points_node:
		for point in spawn_points_node.get_children():
			if point is SpawnPoint:
				spawn_points.append(point)

func _on_host_pressed():
	peer.create_server(135)
	multiplayer.multiplayer_peer = peer
	multiplayer.peer_connected.connect(_add_player)
	_add_player()

func _add_player(id = 1):
	# If this player has respawned before, use their last position
	var spawn_position = Vector2.ZERO
	var spawn_rotation = 0
	
	if player_spawn_data.has(id):
		# Player is respawning
		spawn_position = player_spawn_data[id].position
		spawn_rotation = player_spawn_data[id].rotation
	else:
		# New player, choose a random spawn point
		spawn_position = _get_random_spawn_position()
		
	# Create the player
	var player = player_scene.instantiate()
	player.name = str(id)
	
	# Set the initial position
	player.position = spawn_position
	player.rotation = spawn_rotation
	
	# Save this spawn data
	player_spawn_data[id] = {
		"position": spawn_position,
		"rotation": spawn_rotation
	}
	
	call_deferred("add_child", player)

func _on_join_pressed():
	peer.create_client("localhost", 135)
	multiplayer.multiplayer_peer = peer

func _get_random_spawn_position() -> Vector2:
	if spawn_points.size() > 0:
		var random_point = spawn_points[randi() % spawn_points.size()]
		return random_point.global_position
	else:
		# Fallback if no spawn points are defined
		return Vector2(
			randf_range(100, 900),  # Random X between 100 and 900
			randf_range(100, 500)   # Random Y between 100 and 500
		)

# Called by the player when they die
func handle_player_death(player_id):
	if multiplayer.is_server():
		# Choose a new spawn point
		var new_spawn = _get_random_spawn_position()
		
		# Update spawn data
		player_spawn_data[player_id] = {
			"position": new_spawn,
			"rotation": 0  # Reset rotation on respawn
		}
		
		# Schedule respawn with short delay
		get_tree().create_timer(2.0).timeout.connect(
			func(): _respawn_player(player_id)
		)

func _respawn_player(player_id):
	if multiplayer.is_server():
		_add_player(player_id)
