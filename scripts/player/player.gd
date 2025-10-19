extends CharacterBody2D

const BASE_SPEED = 100.0
const DASH_SPEED = 300.0
const DASH_DURATION = 0.2
const DASH_COOLDOWN = 2.0

@onready var sprite = $Sprite2D
@onready var detection_area = $DetectionArea
@onready var weapon_sprite = $WeaponSprite
@onready var attack_animation = $AttackAnimation

var room_node = null
var nearby_enemies: Array = []
var attack_timer: float = 0.0
var is_attacking: bool = false

var dash_cooldown_timer: float = 0.0
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

var current_health: float = 20.0
var current_mana: float = 20.0
var invulnerability_timer: float = 0.0

func _ready():
	if sprite is Sprite2D:
		# Load character sprite based on selected character class
		var texture_path = ""
		match GameState.selected_character_class:
			"knight":
				texture_path = "res://assets/characters/knight_m_idle_anim_f0.png"
			"archer":
				texture_path = "res://assets/characters/elf_m_idle_anim_f0.png"
			"mage":
				texture_path = "res://assets/characters/wizzard_m_idle_anim_f0.png"
			"angel":
				texture_path = "res://assets/characters/angel_idle_anim_f0.png"
			_:
				texture_path = "res://assets/characters/knight_m_idle_anim_f0.png"
		
		var texture = load(texture_path)
		if texture:
			sprite.texture = texture
			sprite.scale = Vector2(1, 1)
	
	if detection_area:
		detection_area.body_entered.connect(_on_enemy_entered)
		detection_area.body_exited.connect(_on_enemy_exited)
		update_detection_range()
	
	Equipment.equipment_changed.connect(_on_equipment_changed)
	update_weapon_visual()
	
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
		weapon_sprite.texture = load(weapon.icon_path)
		weapon_sprite.visible = true
	else:
		weapon_sprite.visible = false

func _physics_process(delta):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	if invulnerability_timer > 0:
		invulnerability_timer -= delta
	
	regenerate_mana(delta)
	
	if is_dashing:
		handle_dash(delta)
	else:
		handle_normal_movement(delta)
	
	move_and_slide()
	handle_auto_attack(delta)
	check_enemy_collisions()

func regenerate_mana(delta):
	if GameState.player_stats:
		var mana_regen = GameState.player_stats.get_stat("mana_regen")
		var max_mana = GameState.player_stats.get_max_mana()
		current_mana = min(current_mana + mana_regen * delta, max_mana)
		GameState.player_stats.current_mana = current_mana
		
		var health_regen = GameState.player_stats.get_stat("health_regen")
		var max_health = GameState.player_stats.get_max_health()
		current_health = min(current_health + health_regen * delta, max_health)
		GameState.player_stats.current_health = current_health

func handle_normal_movement(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("move_up"):
		direction.y -= 1
	
	if Input.is_action_just_pressed("dash") and dash_cooldown_timer <= 0 and direction != Vector2.ZERO:
		start_dash(direction)
		return
	
	var speed_multiplier = 1.0
	if GameState.player_stats:
		speed_multiplier = GameState.player_stats.get_stat("movement_speed")
	
	var final_speed = BASE_SPEED * speed_multiplier
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
		velocity = direction * final_speed
	else:
		velocity = Vector2.ZERO

func start_dash(direction: Vector2):
	is_dashing = true
	dash_timer = DASH_DURATION
	dash_direction = direction.normalized()
	dash_cooldown_timer = DASH_COOLDOWN

func handle_dash(delta):
	dash_timer -= delta
	
	if dash_timer <= 0:
		is_dashing = false
		velocity = Vector2.ZERO
	else:
		velocity = dash_direction * DASH_SPEED

func update_detection_range():
	var weapon_range = Equipment.get_weapon_range()
	if detection_area and detection_area.get_child_count() > 0:
		var collision_shape = detection_area.get_child(0)
		if collision_shape is CollisionShape2D:
			var shape = collision_shape.shape
			if shape is CircleShape2D:
				shape.radius = weapon_range

func handle_auto_attack(delta: float):
	if nearby_enemies.size() == 0:
		return
	
	attack_timer -= delta
	
	if attack_timer <= 0:
		var attack_speed = Equipment.get_weapon_attack_speed()
		attack_timer = 1.0 / attack_speed
		
		attack_nearest_enemy()

func attack_nearest_enemy():
	if nearby_enemies.size() == 0:
		return
	
	var nearest_enemy = null
	var nearest_distance = INF
	
	for enemy in nearby_enemies:
		if not is_instance_valid(enemy):
			continue
		
		var distance = global_position.distance_to(enemy.global_position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy
	
	if nearest_enemy:
		var weapon = Equipment.get_weapon()
		if weapon:
			play_attack_animation(weapon.weapon_type, nearest_enemy)
		else:
			deal_damage_to_enemy(nearest_enemy)

func play_attack_animation(weapon_type, target_enemy):
	var mana_cost = get_mana_cost(weapon_type)
	
	if current_mana < mana_cost:
		return
	
	current_mana -= mana_cost
	if GameState.player_stats:
		GameState.player_stats.current_mana = current_mana
	
	is_attacking = true
	
	match weapon_type:
		Inventory.WeaponType.MELEE:
			animate_melee_attack(target_enemy)
		Inventory.WeaponType.RANGED:
			animate_ranged_attack(target_enemy)
		Inventory.WeaponType.MAGIC:
			animate_magic_attack(target_enemy)
	
	await get_tree().create_timer(0.2).timeout
	is_attacking = false

func get_mana_cost(weapon_type) -> float:
	match weapon_type:
		Inventory.WeaponType.MELEE:
			return 0.5
		Inventory.WeaponType.RANGED:
			return 2.0
		Inventory.WeaponType.MAGIC:
			return 4.0
	return 1.0

func animate_melee_attack(target_enemy):
	if weapon_sprite:
		var direction = (target_enemy.global_position - global_position).normalized()
		var original_pos = weapon_sprite.position if weapon_sprite is ColorRect else Vector2(15, 0)
		var tween = create_tween()
		tween.tween_property(weapon_sprite, "position" if weapon_sprite is Sprite2D else "offset", direction * 20, 0.1)
		tween.tween_property(weapon_sprite, "position" if weapon_sprite is Sprite2D else "offset", original_pos, 0.1)
	
	deal_damage_to_enemy(target_enemy)

func animate_ranged_attack(target_enemy):
	create_projectile(target_enemy, Color(0.8, 0.6, 0.2))
	deal_damage_to_enemy(target_enemy)

func animate_magic_attack(target_enemy):
	create_projectile(target_enemy, Color(0.5, 0.3, 0.9))
	deal_damage_to_enemy(target_enemy)

func create_projectile(target_enemy, color: Color):
	var projectile = ColorRect.new()
	projectile.size = Vector2(8, 8)
	projectile.color = color
	projectile.global_position = global_position
	get_parent().add_child(projectile)
	
	var tween = create_tween()
	tween.tween_property(projectile, "global_position", target_enemy.global_position, 0.2)
	tween.tween_callback(projectile.queue_free)

func deal_damage_to_enemy(enemy):
	if enemy and enemy.has_method("take_damage"):
		var weapon = Equipment.get_weapon()
		var base_damage = Equipment.get_weapon_damage()
		var bonus_damage = 0.0
		
		if GameState.player_stats:
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
		
		var total_damage = base_damage + bonus_damage
		var is_crit = roll_critical_hit()
		var final_damage = total_damage
		
		if is_crit:
			final_damage *= 2.0
		
		enemy.take_damage(final_damage, is_crit)

func roll_critical_hit() -> bool:
	var crit_chance = 0.0
	if GameState.player_stats:
		crit_chance = GameState.player_stats.get_stat("crit_chance")
	
	return randf() * 100.0 < crit_chance

func _on_enemy_entered(body):
	if body.is_in_group("enemy") and not nearby_enemies.has(body):
		nearby_enemies.append(body)

func _on_enemy_exited(body):
	if nearby_enemies.has(body):
		nearby_enemies.erase(body)

func check_enemy_collisions():
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider and collider.is_in_group("enemy") and collider.has_method("try_attack_player"):
			collider.try_attack_player()

func take_damage(amount: float):
	if invulnerability_timer > 0:
		return
	
	var resistance = 0.0
	if GameState.player_stats:
		resistance = GameState.player_stats.get_stat("resistance")
	
	var damage_reduction = resistance * 0.5
	var final_damage = max(1.0, amount - damage_reduction)
	
	current_health -= final_damage
	invulnerability_timer = 0.5
	
	show_player_damage_text(final_damage)
	
	if sprite:
		sprite.modulate = Color(1, 0.3, 0.3)
		await get_tree().create_timer(0.1).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color(1, 1, 1)
	
	if GameState.player_stats:
		GameState.player_stats.current_health = current_health
	
	if current_health <= 0:
		die()

func show_player_damage_text(damage: float):
	var room = get_parent()
	if not room or not room.has_node("DamageTextLayer"):
		return
	
	var damage_layer = room.get_node("DamageTextLayer")
	
	var damage_label = Label.new()
	damage_label.text = "-" + str(int(damage))
	damage_label.add_theme_font_size_override("font_size", 12)
	damage_label.modulate = Color(1, 0.2, 0.2)
	damage_label.position = global_position + Vector2(-8, -20)
	damage_label.z_index = 100
	
	damage_layer.add_child(damage_label)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(damage_label, "position:y", damage_label.position.y - 20, 1.0)
	tween.tween_property(damage_label, "modulate:a", 0.0, 1.0)
	tween.finished.connect(damage_label.queue_free)

func die():
	get_tree().change_scene_to_file("res://scenes/world/main.tscn")

