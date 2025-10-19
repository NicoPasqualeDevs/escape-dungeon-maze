extends Node

# SeedManager - Singleton para gestión de seeds únicos
# Genera y mantiene el seed único por partida para generación procedimental

var current_seed: int = 0
var is_seed_initialized: bool = false

# Señales para notificar cambios de seed
signal seed_generated(new_seed: int)
signal seed_changed(new_seed: int)

func _ready():
	print("SeedManager initialized")

# Genera un nuevo seed único basado en el timestamp actual
func generate_new_seed() -> int:
	var timestamp = Time.get_unix_time_from_system()
	var microseconds = Time.get_ticks_usec()
	
	# Combinar timestamp y microsegundos para mayor unicidad
	current_seed = int(timestamp * 1000000 + microseconds) % 9223372036854775807  # Max int64
	is_seed_initialized = true
	
	print("New seed generated: ", current_seed)
	seed_generated.emit(current_seed)
	
	return current_seed

# Obtiene el seed actual
func get_current_seed() -> int:
	if not is_seed_initialized:
		generate_new_seed()
	return current_seed

# Establece un seed personalizado (útil para testing)
func set_custom_seed(seed: int) -> void:
	current_seed = seed
	is_seed_initialized = true
	
	print("Custom seed set: ", current_seed)
	seed_changed.emit(current_seed)

# Verifica si el seed ha sido inicializado
func has_seed() -> bool:
	return is_seed_initialized

# Reinicia el seed (para nueva partida)
func reset_seed() -> void:
	current_seed = 0
	is_seed_initialized = false
	print("Seed reset")

# Obtiene información del seed para debugging
func get_seed_info() -> Dictionary:
	return {
		"seed": current_seed,
		"initialized": is_seed_initialized,
		"timestamp": Time.get_unix_time_from_system()
	}
