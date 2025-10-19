extends Node

# RoomSizeGenerator - Singleton para cálculo de tamaños de habitaciones
# Utiliza Linear Congruential Generator para generación determinística

# Implementación del Linear Congruential Generator
class LCGRandom:
	var seed: int
	var current: int
	
	func _init(initial_seed: int):
		seed = initial_seed
		current = seed
	
	func next_int() -> int:
		current = (GameConstants.SEED_SYSTEM.lcg_multiplier * current + 
				  GameConstants.SEED_SYSTEM.lcg_increment) % GameConstants.SEED_SYSTEM.lcg_modulus
		return current
	
	func next_range(min_val: int, max_val: int) -> int:
		return min_val + (next_int() % (max_val - min_val + 1))

# Cache de habitaciones pre-calculadas
var room_cache: Dictionary = {}  # Vector2i -> Vector2i
var is_pregenerated: bool = false

func _ready():
	print("RoomSizeGenerator initialized")

# Calcula el tamaño de una habitación específica
func calculate_room_size(room_position: Vector2i, seed: int) -> Vector2i:
	# Crear un seed único para esta habitación combinando posición y seed base
	var room_seed = seed + (room_position.x * 1000) + (room_position.y * 100000)
	var rng = LCGRandom.new(room_seed)
	
	# Generar dimensiones dentro del rango permitido
	var min_size = GameConstants.ROOM_GENERATION.min_size
	var max_size = GameConstants.ROOM_GENERATION.max_size
	
	var width = rng.next_range(min_size.x, max_size.x)
	var height = rng.next_range(min_size.y, max_size.y)
	
	var room_size = Vector2i(width, height)
	
	# Validar el tamaño generado
	if not validate_room_size(room_size):
		print("Warning: Invalid room size generated, using fallback")
		room_size = Vector2i(200, 200)  # Tamaño por defecto
	
	return room_size

# Pre-genera todas las habitaciones del dungeon
func pregenerate_all_rooms(dungeon_grid: Array, seed: int) -> Dictionary:
	room_cache.clear()
	
	print("Pre-generating rooms with seed: ", seed)
	
	for row in range(dungeon_grid.size()):
		for col in range(dungeon_grid[row].size()):
			if dungeon_grid[row][col] != GameState.RoomType.EMPTY:
				var room_pos = Vector2i(col, row)
				var room_size = calculate_room_size(room_pos, seed)
				room_cache[room_pos] = room_size
				
				print("Room at ", room_pos, " size: ", room_size)
	
	is_pregenerated = true
	print("Pre-generation complete. ", room_cache.size(), " rooms generated")
	
	return room_cache

# Obtiene el tamaño de una habitación del cache
func get_room_size(room_position: Vector2i) -> Vector2i:
	if room_cache.has(room_position):
		return room_cache[room_position]
	
	# Si no está en cache, calcular usando el seed actual
	var current_seed = SeedManager.get_current_seed()
	var room_size = calculate_room_size(room_position, current_seed)
	room_cache[room_position] = room_size
	
	return room_size

# Valida que el tamaño de habitación esté dentro de los rangos permitidos
func validate_room_size(size: Vector2i) -> bool:
	var min_size = GameConstants.ROOM_GENERATION.min_size
	var max_size = GameConstants.ROOM_GENERATION.max_size
	return (size.x >= min_size.x and size.x <= max_size.x and
			size.y >= min_size.y and size.y <= max_size.y)

# Obtiene estadísticas de las habitaciones generadas
func get_generation_stats() -> Dictionary:
	if not is_pregenerated:
		return {"error": "Rooms not pregenerated yet"}
	
	var total_rooms = room_cache.size()
	var small_rooms = 0
	var medium_rooms = 0
	var large_rooms = 0
	
	for room_size in room_cache.values():
		var area = room_size.x * room_size.y
		if area < 15000:  # < 150x100
			small_rooms += 1
		elif area < 50000:  # < 250x200
			medium_rooms += 1
		else:
			large_rooms += 1
	
	return {
		"total_rooms": total_rooms,
		"small_rooms": small_rooms,
		"medium_rooms": medium_rooms,
		"large_rooms": large_rooms,
		"cache_size": room_cache.size()
	}

# Limpia el cache de habitaciones
func clear_cache():
	room_cache.clear()
	is_pregenerated = false
	print("Room cache cleared")

# Obtiene información de debugging
func get_debug_info() -> Dictionary:
	return {
		"cache_size": room_cache.size(),
		"is_pregenerated": is_pregenerated,
		"cached_positions": room_cache.keys()
	}
