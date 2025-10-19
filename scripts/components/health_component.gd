extends Node
class_name HealthComponent

signal health_changed(current, maximum)
signal died

@export var max_health: float = 50.0
@export var regeneration_rate: float = 0.0
@export var show_health_bar: bool = true

var current_health: float
var health_bar: ProgressBar = null
var health_bar_timer: float = 0.0
var invulnerability_timer: float = 0.0
var enemy_node: Node2D = null

func _ready():
	current_health = max_health
	enemy_node = get_parent() as Node2D
	if show_health_bar:
		call_deferred("create_health_bar")

func _process(delta: float):
	if regeneration_rate > 0:
		heal(regeneration_rate * delta)
	
	if invulnerability_timer > 0:
		invulnerability_timer -= delta
	
	if health_bar_timer > 0:
		health_bar_timer -= delta
		if health_bar_timer <= 0 and health_bar:
			health_bar.visible = false

func take_damage(amount: float, ignore_invulnerability: bool = false) -> void:
	if invulnerability_timer > 0 and not ignore_invulnerability:
		return
	
	current_health = max(0, current_health - amount)
	health_changed.emit(current_health, max_health)
	
	update_health_bar()
	
	if current_health <= 0:
		_on_enemy_died()
		died.emit()

func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)
	update_health_bar()

func set_invulnerability(duration: float) -> void:
	invulnerability_timer = duration

func is_alive() -> bool:
	return current_health > 0

func get_health_percent() -> float:
	return current_health / max_health if max_health > 0 else 0.0

func create_health_bar():
	if not enemy_node:
		print("Warning: No se encontró enemy_node para crear la barra de vida")
		return
	
	health_bar = ProgressBar.new()
	health_bar.size = Vector2(32, 4)  # Barra más grande y visible
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.show_percentage = false
	health_bar.visible = false
	health_bar.z_index = 100  # Z-index alto para aparecer por encima de todo
	
	# Posición relativa al enemigo (encima del goblin)
	health_bar.position = Vector2(-16, -30)
	
	# Fondo con borde para mejor visibilidad
	var style_bg = ResourceManager.get_stylebox_flat(Color(0.1, 0.1, 0.1), 1, Color(0.4, 0.4, 0.4))
	health_bar.add_theme_stylebox_override("background", style_bg)
	
	# Color inicial basado en la salud actual
	var health_percent = get_health_percent()
	var style_fill = ResourceManager.get_health_bar_style(health_percent)
	health_bar.add_theme_stylebox_override("fill", style_fill)
	
	# Añadir como hijo directo del enemigo
	enemy_node.add_child(health_bar)

func update_health_bar():
	if not health_bar:
		return
	
	health_bar.value = current_health
	health_bar.visible = true
	health_bar_timer = GameConstants.ENEMY.health_bar_display_time
	
	# Actualizar color según el porcentaje de vida
	var health_percent = get_health_percent()
	var style_fill = ResourceManager.get_health_bar_style(health_percent)
	health_bar.add_theme_stylebox_override("fill", style_fill)

func _on_enemy_died():
	# Limpiar la barra de vida cuando el enemigo muere
	if health_bar and is_instance_valid(health_bar):
		health_bar.queue_free()
	health_bar = null
