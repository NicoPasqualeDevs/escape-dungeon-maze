extends Node2D

@onready var room_label = $CanvasLayer/RoomLabel
@onready var info_label = $CanvasLayer/InfoLabel
@onready var player = $Player
@onready var exit_area = $ExitArea
@onready var exit_sprite = $ExitArea/ExitSprite
@onready var exit_label = $ExitArea/ExitLabel
@onready var walls = $Walls

var room_type: GameState.RoomType
var room_completed: bool = false
var spawned_enemies: Array = []

func _ready():
	room_type = GameState.current_room_type
	setup_room()
	setup_exit()
	player.room_node = self
	# Spawn enemigos después de que todo esté configurado
	call_deferred("spawn_default_enemies")

func setup_room():
	match room_type:
		GameState.RoomType.ENTRANCE:
			room_label.text = "Entrance"
			info_label.text = "WASD: Move | SPACE: Dash | Find the exit"
		_:
			room_label.text = "Room"
			info_label.text = "WASD: Move | SPACE: Dash | Find the exit"

func setup_exit():
	exit_area.position = Vector2(400, 120)
	exit_area.body_entered.connect(_on_exit_area_body_entered)

func spawn_default_enemies():
	# Definir los límites de la sala basados en el Floor ColorRect
	var room_bounds = Rect2(220, 120, 360, 260)  # Basado en el Floor del .tscn
	
	# Spawn 50 enemigos usando el EnemySpawner
	spawned_enemies = EnemySpawner.spawn_default_enemies(self, player, room_bounds)
	
	# Agregar los enemigos al grupo "enemies" para fácil gestión
	for enemy in spawned_enemies:
		enemy.add_to_group("enemies")
	
	print("Spawned ", spawned_enemies.size(), " enemies in the room")

func _on_exit_area_body_entered(body):
	if body == player:
		# Limpiar enemigos antes de cambiar de escena
		for enemy in spawned_enemies:
			if is_instance_valid(enemy):
				enemy.queue_free()
		spawned_enemies.clear()
		
		GameState.rooms_completed += 1
		get_tree().change_scene_to_file("res://scenes/world/main.tscn")
