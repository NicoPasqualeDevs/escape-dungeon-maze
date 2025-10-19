extends CharacterBody2D

@export var damage: float = 5.0
@export var xp_reward: float = 10.0
@export var is_boss: bool = false

var player = null
var attack_cooldown: float = 0.0
var detection_range: float = 150.0
var chase_range: float = 200.0
var is_chasing: bool = false
var idle_position: Vector2

@onready var health_component: HealthComponent = $HealthComponent
@onready var movement_component: MovementComponent = $MovementComponent

func _ready():
	add_to_group("enemy")
	idle_position = global_position
	
	if not health_component:
		health_component = HealthComponent.new()
		add_child(health_component)
	
	if not movement_component:
		movement_component = MovementComponent.new()
		add_child(movement_component)
	
	_setup_stats()
	health_component.died.connect(_on_died)
	
	detection_range = GameConstants.ENEMY.detection_range
	chase_range = GameConstants.ENEMY.chase_range

func _setup_stats():
	if is_boss:
		health_component.max_health = GameConstants.ENEMY.base_health * GameConstants.BOSS.health_multiplier
		health_component.current_health = health_component.max_health
		damage = GameConstants.ENEMY.base_damage * GameConstants.BOSS.damage_multiplier
		movement_component.base_speed = GameConstants.ENEMY.base_speed * GameConstants.BOSS.speed_multiplier
		xp_reward = GameConstants.ENEMY.base_xp * GameConstants.BOSS.xp_multiplier
	else:
		health_component.max_health = GameConstants.ENEMY.base_health
		health_component.current_health = health_component.max_health
		damage = GameConstants.ENEMY.base_damage
		movement_component.base_speed = GameConstants.ENEMY.base_speed
		xp_reward = GameConstants.ENEMY.base_xp

func _physics_process(delta):
	if player and is_instance_valid(player):
		var distance_to_player = global_position.distance_to(player.global_position)
		
		if distance_to_player <= detection_range:
			is_chasing = true
		elif distance_to_player > chase_range and is_chasing:
			is_chasing = false
		
		if is_chasing:
			movement_component.chase_target(player.global_position)
		else:
			_return_to_idle()
	
	move_and_slide()
	
	if attack_cooldown > 0:
		attack_cooldown -= delta

func _return_to_idle():
	var distance_to_idle = global_position.distance_to(idle_position)
	if distance_to_idle > 5.0:
		movement_component.chase_target(idle_position, 0.5)
	else:
		movement_component.stop()

func take_damage(amount: float, is_crit: bool = false):
	health_component.take_damage(amount)
	
	DamageTextComponent.create_damage_text(amount, is_crit, global_position, self)
	
	_flash_damage()

func _flash_damage():
	var sprite = get_child(0)
	if sprite is Sprite2D or sprite is ColorRect:
		sprite.modulate = GameConstants.COLORS.damage_flash
		await get_tree().create_timer(GameConstants.COMBAT.damage_flash_duration).timeout
		if is_instance_valid(sprite):
			sprite.modulate = Color(1, 1, 1)

func _on_died():
	_give_experience()
	_drop_loot()
	queue_free()

func _give_experience():
	GameState.add_experience(xp_reward)

func _drop_loot():
	if randf() < GameConstants.LOOT.drop_chance:
		var item = _get_random_drop()
		if item:
			Inventory.add_item(item)
			DamageTextComponent.create_loot_text(item.name, Inventory.get_rarity_color(item.rarity), global_position, self)

func _get_random_drop() -> Inventory.Item:
	if is_boss:
		return ItemDatabase.get_random_unique_item()
	
	var rand = randf()
	
	if rand < 0.5:
		return ItemDatabase.get_random_item_for_slot(Equipment.EquipSlot.HELMET + (randi() % 9))
	else:
		return ItemDatabase.get_random_weapon()

func try_attack_player():
	if attack_cooldown <= 0 and player and player.has_method("take_damage"):
		player.take_damage(damage)
		attack_cooldown = GameConstants.ENEMY.attack_cooldown

