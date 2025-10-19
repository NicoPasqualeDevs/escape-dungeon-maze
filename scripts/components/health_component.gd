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

func _ready():
	current_health = max_health
	if show_health_bar:
		create_health_bar()

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
		died.emit()

func heal(amount: float) -> void:
	current_health = min(max_health, current_health + amount)
	health_changed.emit(current_health, max_health)
	update_health_bar()

func set_invulnerable(duration: float) -> void:
	invulnerability_timer = duration

func is_alive() -> bool:
	return current_health > 0

func get_health_percent() -> float:
	return current_health / max_health if max_health > 0 else 0.0

func create_health_bar():
	health_bar = ProgressBar.new()
	health_bar.size = Vector2(20, 2)
	health_bar.position = Vector2(-10, -16)
	health_bar.max_value = max_health
	health_bar.value = current_health
	health_bar.show_percentage = false
	health_bar.visible = false
	
	var style_bg = ResourceManager.get_stylebox_flat(Color(0.2, 0.2, 0.2))
	health_bar.add_theme_stylebox_override("background", style_bg)
	
	var style_fill = ResourceManager.get_stylebox_flat(Color(0.8, 0.2, 0.2))
	health_bar.add_theme_stylebox_override("fill", style_fill)
	
	get_parent().add_child(health_bar)

func update_health_bar():
	if not health_bar:
		return
	
	health_bar.value = current_health
	health_bar.visible = true
	health_bar_timer = GameConstants.ENEMY.health_bar_display_time
	
	var health_percent = get_health_percent()
	var style_fill = ResourceManager.get_health_bar_style(health_percent)
	health_bar.add_theme_stylebox_override("fill", style_fill)

