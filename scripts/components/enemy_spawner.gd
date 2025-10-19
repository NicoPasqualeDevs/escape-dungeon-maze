extends Node
class_name EnemySpawner

static func spawn_enemy(position: Vector2, parent: Node, player: Node, is_boss: bool = false) -> CharacterBody2D:
	var enemy = CharacterBody2D.new()
	enemy.position = position
	enemy.set_script(load("res://scripts/world/enemy.gd"))
	
	var health_comp = HealthComponent.new()
	health_comp.name = "HealthComponent"
	enemy.add_child(health_comp)
	
	var movement_comp = MovementComponent.new()
	movement_comp.name = "MovementComponent"
	enemy.add_child(movement_comp)
	
	var sprite_size = Vector2(16, 16)
	var collision_size = Vector2(14, 14)
	
	if is_boss:
		sprite_size = Vector2(32, 32)
		collision_size = Vector2(28, 28)
	
	var sprite = ColorRect.new()
	sprite.size = sprite_size
	sprite.position = -sprite_size / 2
	sprite.color = Color(0.6, 0.1, 0.1) if is_boss else Color(0.8, 0.2, 0.2)
	enemy.add_child(sprite)
	
	var collision = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	shape.size = collision_size
	collision.shape = shape
	enemy.add_child(collision)
	
	enemy.is_boss = is_boss
	enemy.player = player
	parent.add_child(enemy)
	
	return enemy

static func spawn_enemies_in_pattern(count: int, parent: Node, player: Node, pattern: String = "line") -> Array:
	var enemies = []
	var base_pos = Vector2(200, 200)
	
	match pattern:
		"line":
			for i in range(count):
				var pos = base_pos + Vector2(i * 100, 0)
				enemies.append(spawn_enemy(pos, parent, player))
		"circle":
			var radius = 150.0
			for i in range(count):
				var angle = (2.0 * PI / count) * i
				var pos = base_pos + Vector2(cos(angle), sin(angle)) * radius
				enemies.append(spawn_enemy(pos, parent, player))
		"random":
			for i in range(count):
				var pos = Vector2(
					randf_range(100, 700),
					randf_range(100, 500)
				)
				enemies.append(spawn_enemy(pos, parent, player))
	
	return enemies

static func spawn_default_enemies(parent: Node, player: Node, room_bounds: Rect2 = Rect2(220, 120, 360, 260)) -> Array:
	var enemies = []
	var player_pos = player.global_position
	var min_radius = 200.0
	var max_radius = 400.0
	var enemy_count = 50
	var max_attempts = 100
	
	# Lista para verificar colisiones entre enemigos
	var enemy_positions = []
	var min_enemy_distance = 30.0
	
	for i in range(enemy_count):
		var valid_position = false
		var attempts = 0
		var spawn_pos = Vector2.ZERO
		
		while not valid_position and attempts < max_attempts:
			# Generar posición aleatoria en anillo alrededor del jugador
			var angle = randf() * 2.0 * PI
			var radius = randf_range(min_radius, max_radius)
			spawn_pos = player_pos + Vector2(cos(angle), sin(angle)) * radius
			
			# Verificar que esté dentro de los límites de la sala
			if room_bounds.has_point(spawn_pos):
				# Verificar que no esté muy cerca de otros enemigos
				var too_close = false
				for existing_pos in enemy_positions:
					if spawn_pos.distance_to(existing_pos) < min_enemy_distance:
						too_close = true
						break
				
				if not too_close:
					valid_position = true
			
			attempts += 1
		
		# Si encontramos una posición válida, crear el enemigo
		if valid_position:
			enemy_positions.append(spawn_pos)
			var enemy = spawn_enemy(spawn_pos, parent, player)
			enemies.append(enemy)
		else:
			# Si no encontramos posición válida, usar una posición de respaldo
			var fallback_angle = (float(i) / float(enemy_count)) * 2.0 * PI
			var fallback_radius = min_radius + (i % 3) * 50.0
			spawn_pos = player_pos + Vector2(cos(fallback_angle), sin(fallback_angle)) * fallback_radius
			
			# Asegurar que esté dentro de los límites
			spawn_pos.x = clamp(spawn_pos.x, room_bounds.position.x + 20, room_bounds.position.x + room_bounds.size.x - 20)
			spawn_pos.y = clamp(spawn_pos.y, room_bounds.position.y + 20, room_bounds.position.y + room_bounds.size.y - 20)
			
			var enemy = spawn_enemy(spawn_pos, parent, player)
			enemies.append(enemy)
	
	return enemies

