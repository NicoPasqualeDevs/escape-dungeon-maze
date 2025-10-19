extends Node

const POOL_SIZE = 20

var projectile_pool: Array = []
var active_projectiles: Array = []

func _ready():
	_initialize_pool()

func _initialize_pool():
	for i in range(POOL_SIZE):
		var projectile = _create_projectile()
		projectile.visible = false
		projectile_pool.append(projectile)

func _create_projectile() -> ColorRect:
	var projectile = ColorRect.new()
	projectile.size = Vector2(8, 8)
	return projectile

func get_projectile(color: Color, start_pos: Vector2, target_pos: Vector2, parent: Node) -> void:
	var projectile: ColorRect
	
	if projectile_pool.size() > 0:
		projectile = projectile_pool.pop_back()
	else:
		projectile = _create_projectile()
	
	projectile.color = color
	projectile.global_position = start_pos
	projectile.visible = true
	
	parent.add_child(projectile)
	active_projectiles.append(projectile)
	
	var tween = parent.create_tween()
	tween.tween_property(projectile, "global_position", target_pos, 0.2)
	tween.tween_callback(func(): _return_to_pool(projectile))

func _return_to_pool(projectile: ColorRect):
	if not is_instance_valid(projectile):
		return
	
	active_projectiles.erase(projectile)
	
	if projectile.get_parent():
		projectile.get_parent().remove_child(projectile)
	
	projectile.visible = false
	projectile_pool.append(projectile)

func clear_active():
	for projectile in active_projectiles:
		_return_to_pool(projectile)
	active_projectiles.clear()

