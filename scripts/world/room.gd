extends Node2D

@onready var room_label = $CanvasLayer/RoomLabel
@onready var info_label = $CanvasLayer/InfoLabel
@onready var player = $Player
@onready var exit_area = $ExitArea
@onready var exit_sprite = $ExitArea/ExitSprite
@onready var exit_label = $ExitArea/ExitLabel
@onready var walls = $Walls

# Referencias a las barras UI
@onready var dash_cooldown_bar = $CanvasLayer/DashCooldownBar
@onready var dash_label = $CanvasLayer/DashLabel
@onready var health_bar = $CanvasLayer/HealthBar
@onready var health_label = $CanvasLayer/HealthLabel
@onready var mana_bar = $CanvasLayer/ManaBar
@onready var mana_label = $CanvasLayer/ManaLabel
@onready var xp_bar = $CanvasLayer/XPBar
@onready var xp_label = $CanvasLayer/XPLabel

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
	# Posicionar la salida en la esquina superior derecha del área de juego
	# Floor está en (200, 100, 400, 300), así que la esquina superior derecha sería (580, 120)
	exit_area.position = Vector2(580, 120)
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

func _process(delta):
	update_ui_bars()

func update_ui_bars():
	if not GameState.player_stats or not player:
		return
	
	# Actualizar barra de vida
	if health_bar and health_label:
		var current_health = GameState.player_stats.current_health
		var max_health = GameState.player_stats.get_max_health()
		health_bar.max_value = max_health
		health_bar.value = current_health
		health_label.text = "Health: %d/%d" % [int(current_health), int(max_health)]
	
	# Actualizar barra de maná
	if mana_bar and mana_label:
		var current_mana = GameState.player_stats.current_mana
		var max_mana = GameState.player_stats.get_max_mana()
		mana_bar.max_value = max_mana
		mana_bar.value = current_mana
		mana_label.text = "Mana: %d/%d" % [int(current_mana), int(max_mana)]
	
	# Actualizar barra de dash
	if dash_cooldown_bar and dash_label:
		var dash_cooldown = player.DASH_COOLDOWN
		var remaining_cooldown = player.dash_cooldown_timer
		dash_cooldown_bar.max_value = dash_cooldown
		dash_cooldown_bar.value = dash_cooldown - remaining_cooldown
		
		if remaining_cooldown <= 0:
			dash_label.text = "Dash Ready"
		else:
			dash_label.text = "Dash: %.1fs" % remaining_cooldown
	
	# Actualizar barra de XP
	if xp_bar and xp_label:
		var current_xp = GameState.current_xp
		var xp_to_next = GameState.xp_to_next_level
		var player_level = GameState.player_level
		
		xp_bar.max_value = xp_to_next
		xp_bar.value = current_xp
		xp_label.text = "Level %d | XP: %d/%d" % [player_level, current_xp, xp_to_next]

func _on_exit_area_body_entered(body):
	if body == player:
		# Limpiar enemigos antes de cambiar de escena
		for enemy in spawned_enemies:
			if is_instance_valid(enemy):
				enemy.queue_free()
		spawned_enemies.clear()
		
		# Otorgar experiencia y completar habitación
		GameState.add_experience(50)  # 50 XP por completar habitación
		GameState.complete_room()     # +1 stat point por completar habitación
		
		GameState.rooms_completed += 1
		
		# Verificar si hay puntos de estadística disponibles
		if GameState.pending_stat_points > 0:
			# Mostrar menú de selección de estadísticas
			get_tree().change_scene_to_file("res://scenes/ui/stat_upgrade_menu.tscn")
		else:
			# Regresar al mapa principal
			get_tree().change_scene_to_file("res://scenes/world/main.tscn")
