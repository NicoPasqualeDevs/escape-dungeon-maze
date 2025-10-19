extends CharacterBody2D

@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea
@onready var weapon_sprite = $WeaponSprite
@onready var movement_component: MovementComponent = $MovementComponent
@onready var combat_component: CombatComponent = $CombatComponent

var room_node = null
var nearby_enemies: Array = []

var current_health: float
var current_mana: float

func _ready():
	_setup_components()
	_setup_sprite()
	_setup_detection_area()
	_setup_equipment()
	_initialize_stats()

func _setup_components():
	if not movement_component:
		movement_component = MovementComponent.new()
		movement_component.name = "MovementComponent"
		movement_component.can_dash = true
		movement_component.base_speed = GameConstants.PLAYER.base_speed
		movement_component.dash_speed = GameConstants.PLAYER.dash_speed
		movement_component.dash_duration = GameConstants.PLAYER.dash_duration
		movement_component.dash_cooldown = GameConstants.PLAYER.dash_cooldown
		add_child(movement_component)
	
	if not combat_component:
		combat_component = CombatComponent.new()
		combat_component.name = "CombatComponent"
		add_child(combat_component)
		combat_component.attack_performed.connect(_on_attack_performed)

func _setup_sprite():
	if sprite is Sprite2D:
		var texture = ResourceManager.get_texture("res://assets/characters/knight_m_idle_anim_f0.png")
		if texture:
			sprite.texture = texture
			sprite.scale = Vector2(1, 1)

func _setup_detection_area():
	if detection_area:
		detection_area.body_entered.connect(_on_enemy_entered)
		detection_area.body_exited.connect(_on_enemy_exited)
		update_detection_range()

func _setup_equipment():
	Equipment.equipment_changed.connect(_on_equipment_changed)
	update_weapon_visual()

func _initialize_stats():
	if GameState.player_stats:
		GameState.player_stats.calculate_derived_stats()
		current_health = GameState.player_stats.get_max_health()
		current_mana = GameState.player_stats.get_max_mana()
		GameState.player_stats.current_health = current_health
		GameState.player_stats.current_mana = current_mana

func _on_equipment_changed():
	update_weapon_visual()
	update_detection_range()

func update_weapon_visual():
	if not weapon_sprite:
		return
	
	var weapon = Equipment.get_weapon()
	if weapon_sprite is Sprite2D and weapon and weapon.icon_path != "":
		var texture = ResourceManager.get_texture(weapon.icon_path)
		if texture:
			weapon_sprite.texture = texture
		weapon_sprite.visible = true
	else:
		weapon_sprite.visible = true

func _physics_process(delta):
	_handle_regeneration(delta)
	_handle_movement()
	move_and_slide()
	_handle_auto_attack()
	_check_enemy_collisions()

func _handle_regeneration(delta: float):
	if not GameState.player_stats:
		return
	
	var mana_regen = GameState.player_stats.get_stat("mana_regen")
	var max_mana = GameState.player_stats.get_max_mana()
	current_mana = min(current_mana + mana_regen * delta, max_mana)
	GameState.player_stats.current_mana = current_mana
	
	var health_regen = GameState.player_stats.get_stat("health_regen")
	var max_health = GameState.player_stats.get_max_health()
	current_health = min(current_health + health_regen * delta, max_health)
	GameState.player_stats.current_health = current_health

func _handle_movement():
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	if Input.is_action_just_pressed("dash"):
		movement_component.start_dash(direction)
	
	var speed_multiplier = 1.0
	if GameState.player_stats:
		speed_multiplier = GameState.player_stats.get_stat("movement_speed")
	
	movement_component.move(direction, speed_multiplier)

func update_detection_range():
	var weapon_range = Equipment.get_weapon_range()
	if detection_area and detection_area.get_child_count() > 0:
		var collision_shape = detection_area.get_child(0)
		if collision_shape is CollisionShape2D:
			var shape = collision_shape.shape
			if shape is CircleShape2D:
				shape.radius = weapon_range

func _handle_auto_attack():
	if nearby_enemies.size() == 0:
		return
	
	if combat_component.can_attack():
		_attack_nearest_enemy()

func _attack_nearest_enemy():
	var nearest_enemy = _find_nearest_enemy()
	if not nearest_enemy:
		return
	
	var weapon = Equipment.get_weapon()
	var weapon_damage = Equipment.get_weapon_damage()
	var attack_speed = Equipment.get_weapon_attack_speed()
	var bonus_damage = _calculate_bonus_damage(weapon)
	var mana_cost = combat_component.get_mana_cost(weapon.weapon_type if weapon else null)
	
	var success = combat_component.attack(
		nearest_enemy,
		weapon_damage,
		bonus_damage,
		attack_speed,
		weapon.weapon_type if weapon else null,
		mana_cost
	)
	
	if success and weapon:
		_play_attack_animation(weapon.weapon_type, nearest_enemy)

func _find_nearest_enemy():
	var nearest_enemy = null
	var nearest_distance = INF
	
	for enemy in nearby_enemies:
		if not is_instance_valid(enemy):
			continue
		
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
	
	return nearest_enemy

func _calculate_bonus_damage(weapon) -> float:
	if not GameState.player_stats:
		return 0.0
	
	var bonus_damage = 0.0
	var physical_dmg = GameState.player_stats.get_stat("physical_damage")
	var magic_dmg = GameState.player_stats.get_stat("magic_damage")
	var ranged_bonus = GameState.player_stats.get_stat("ranged_damage_bonus")
	
	if weapon:
		match weapon.weapon_type:
			Inventory.WeaponType.MELEE:
				bonus_damage = physical_dmg
			Inventory.WeaponType.RANGED:
				bonus_damage = physical_dmg + ranged_bonus
			Inventory.WeaponType.MAGIC:
				bonus_damage = magic_dmg
	else:
		bonus_damage = physical_dmg + magic_dmg
	
	return bonus_damage

func _on_attack_performed(target, damage, is_crit):
	pass

func _play_attack_animation(weapon_type, target_enemy):
	match weapon_type:
		Inventory.WeaponType.MELEE:
			_animate_melee_attack(target_enemy)
		Inventory.WeaponType.RANGED:
			_animate_ranged_attack(target_enemy)
		Inventory.WeaponType.MAGIC:
			_animate_magic_attack(target_enemy)

func _animate_melee_attack(target_enemy):
	if weapon_sprite:
		var direction = (target_enemy.global_position - global_position).normalized()
		var original_pos = weapon_sprite.position if weapon_sprite is ColorRect else Vector2(15, 0)
		var tween = create_tween()
		tween.tween_property(weapon_sprite, "position" if weapon_sprite is Sprite2D else "offset", direction * 20, 0.1)
		tween.tween_property(weapon_sprite, "position" if weapon_sprite is Sprite2D else "offset", original_pos, 0.1)

func _animate_ranged_attack(target_enemy):
	ProjectilePool.get_projectile(Color(0.8, 0.6, 0.2), global_position, target_enemy.global_position, get_parent())

func _animate_magic_attack(target_enemy):
	ProjectilePool.get_projectile(Color(0.5, 0.3, 0.9), global_position, target_enemy.global_position, get_parent())

func _on_enemy_entered(body):
	if body.is_in_group("enemy") and not nearby_enemies.has(body):
		nearby_enemies.append(body)

func _on_enemy_exited(body):
	if nearby_enemies.has(body):
		nearby_enemies.erase(body)

func _check_enemy_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("enemy") and collider.has_method("try_attack_player"):
			collider.try_attack_player()

func take_damage(amount: float):
	var resistance = 0.0
	if GameState.player_stats:
		resistance = GameState.player_stats.get_stat("resistance")
	
	var damage_reduction = resistance * GameConstants.COMBAT.resistance_multiplier
	var final_damage = max(1.0, amount - damage_reduction)
	
	current_health -= final_damage
	
	DamageTextComponent.create_player_damage_text(final_damage, global_position, self)
	
	_flash_damage()
	
	if GameState.player_stats:
		GameState.player_stats.current_health = current_health
	
	if current_health <= 0:
		die()

func _flash_damage():
	if sprite:
		sprite.modulate = GameConstants.COLORS.damage_flash
		await get_tree().create_timer(GameConstants.COMBAT.damage_flash_duration).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color(1, 1, 1)

func die():
	get_tree().change_scene_to_file("res://scenes/world/main.tscn")

