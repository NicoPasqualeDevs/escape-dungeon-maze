extends Node
class_name DamageTextComponent

static func create_damage_text(damage: float, is_crit: bool, world_position: Vector2, parent: Node) -> void:
	var enemy_node = _find_enemy_node(parent)
	if not enemy_node:
		return
	
	var damage_label = Label.new()
	damage_label.text = str(int(damage))
	
	var font_size = 10
	if is_crit:
		font_size = 14
		damage_label.text = "CRIT! " + damage_label.text
		damage_label.modulate = GameConstants.COLORS.damage_crit
	else:
		damage_label.modulate = GameConstants.COLORS.damage_enemy
	
	damage_label.add_theme_font_size_override("font_size", font_size)
	damage_label.position = Vector2(-8, -20)  # Posición relativa al enemigo
	damage_label.z_index = 100
	
	enemy_node.add_child(damage_label)
	
	var tween = enemy_node.create_tween()
	tween.set_parallel(true)
	tween.tween_property(damage_label, "position:y", 
		damage_label.position.y - GameConstants.UI.damage_text_rise_distance, 
		GameConstants.UI.damage_text_duration)
	tween.tween_property(damage_label, "modulate:a", 0.0, GameConstants.UI.damage_text_duration)
	tween.finished.connect(damage_label.queue_free)

static func create_player_damage_text(damage: float, world_position: Vector2, parent: Node) -> void:
	# Para el jugador, mantenemos el comportamiento original usando DamageTextLayer
	var damage_layer = _find_damage_layer(parent)
	if not damage_layer:
		return
	
	var damage_label = Label.new()
	damage_label.text = "-" + str(int(damage))
	damage_label.add_theme_font_size_override("font_size", 12)
	damage_label.modulate = GameConstants.COLORS.damage_player
	damage_label.position = world_position + Vector2(-8, -20)
	damage_label.z_index = 100
	
	damage_layer.add_child(damage_label)
	
	var tween = damage_layer.create_tween()
	tween.set_parallel(true)
	tween.tween_property(damage_label, "position:y", 
		damage_label.position.y - GameConstants.UI.damage_text_rise_distance, 
		GameConstants.UI.damage_text_duration)
	tween.tween_property(damage_label, "modulate:a", 0.0, GameConstants.UI.damage_text_duration)
	tween.finished.connect(damage_label.queue_free)

static func create_loot_text(item_name: String, rarity_color: Color, world_position: Vector2, parent: Node) -> void:
	var enemy_node = _find_enemy_node(parent)
	if not enemy_node:
		return
	
	var loot_label = Label.new()
	loot_label.text = "+" + item_name
	loot_label.add_theme_font_size_override("font_size", 20)
	loot_label.modulate = rarity_color
	loot_label.position = Vector2(-40, -70)  # Posición relativa al enemigo
	loot_label.z_index = 100
	
	enemy_node.add_child(loot_label)
	
	var tween = enemy_node.create_tween()
	tween.set_parallel(true)
	tween.tween_property(loot_label, "position:y", 
		loot_label.position.y - GameConstants.UI.loot_text_rise_distance, 
		GameConstants.UI.loot_text_duration)
	tween.tween_property(loot_label, "modulate:a", 0.0, GameConstants.UI.loot_text_duration)
	tween.finished.connect(loot_label.queue_free)

static func _find_enemy_node(node: Node) -> Node2D:
	# Si el nodo es un enemigo, devolverlo
	if node.is_in_group("enemy"):
		return node as Node2D
	
	# Buscar en los padres
	var current = node
	while current:
		if current.is_in_group("enemy"):
			return current as Node2D
		current = current.get_parent()
	
	return null

static func _find_damage_layer(node: Node) -> Node:
	# Buscar DamageTextLayer en la escena actual
	var scene_root = node.get_tree().current_scene
	if scene_root and scene_root.has_node("DamageTextLayer"):
		return scene_root.get_node("DamageTextLayer")
	
	# Fallback: buscar en el nodo padre
	var current = node
	while current:
		if current.has_node("DamageTextLayer"):
			return current.get_node("DamageTextLayer")
		current = current.get_parent()
	return null

