extends Node
class_name CombatComponent

signal attack_performed(target, damage, is_crit)

var owner_node: Node
var is_attacking: bool = false
var attack_timer: float = 0.0

func _ready():
	owner_node = get_parent()

func _process(delta: float):
	if attack_timer > 0:
		attack_timer -= delta

func can_attack() -> bool:
	return attack_timer <= 0 and not is_attacking

func attack(target, weapon_damage: float, bonus_damage: float, attack_speed: float, weapon_type = null, mana_cost: float = 0.0) -> bool:
	if not can_attack():
		return false
	
	if mana_cost > 0.0 and not _consume_mana(mana_cost):
		return false
	
	attack_timer = 1.0 / attack_speed
	is_attacking = true
	
	var total_damage = weapon_damage + bonus_damage
	var is_crit = _roll_critical_hit()
	var final_damage = total_damage
	
	if is_crit:
		final_damage *= GameConstants.COMBAT.crit_damage_multiplier
	
	if target and target.has_method("take_damage"):
		target.take_damage(final_damage, is_crit)
	
	attack_performed.emit(target, final_damage, is_crit)
	
	await get_tree().create_timer(GameConstants.COMBAT.attack_animation_duration).timeout
	is_attacking = false
	
	return true

func get_mana_cost(weapon_type) -> float:
	if weapon_type == null:
		return 0.0
	
	match weapon_type:
		Inventory.WeaponType.MELEE:
			return GameConstants.COMBAT.melee_mana_cost
		Inventory.WeaponType.RANGED:
			return GameConstants.COMBAT.ranged_mana_cost
		Inventory.WeaponType.MAGIC:
			return GameConstants.COMBAT.magic_mana_cost
	return 0.0

func _consume_mana(amount: float) -> bool:
	if not GameState.player_stats:
		return true
	
	var current_mana = GameState.player_stats.current_mana
	if current_mana < amount:
		return false
	
	GameState.player_stats.current_mana -= amount
	return true

func _roll_critical_hit() -> bool:
	var crit_chance = 0.0
	if GameState.player_stats:
		crit_chance = GameState.player_stats.get_stat("crit_chance")
	
	return randf() * 100.0 < crit_chance

