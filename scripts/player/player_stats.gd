extends Node
class_name PlayerStats

signal stats_changed

var base_attributes = {
	"brutality": 0,
	"spirit": 0,
	"intelligence": 0,
	"dexterity": 0,
	"agility": 0,
	"luck": 0
}

var derived_stats = {
	"physical_damage": 0,
	"resistance": 0,
	"health": 20,
	"health_regen": 0,
	"mana": 20,
	"mana_regen": 0,
	"magic_damage": 0,
	"precision": 0,
	"evasion": 0,
	"ranged_damage_bonus": 0,
	"loot_improvement": 0,
	"crit_chance": 0,
	"movement_speed": 1.0
}

var current_health: float = 20.0
var current_mana: float = 20.0

const ATTRIBUTE_FORMULAS = {
	"brutality": {
		"physical_damage": 3,
		"resistance": 2,
		"health": 1,
		"health_regen": 0.05,
		"mana": -1,
		"mana_regen": 0,
		"magic_damage": -3,
		"precision": -1,
		"evasion": -1,
		"ranged_damage_bonus": 0,
		"loot_improvement": 0,
		"crit_chance": 0,
		"movement_speed": 0
	},
	"spirit": {
		"physical_damage": 0,
		"resistance": -1,
		"health": 1,
		"health_regen": 0.025,
		"mana": 1,
		"mana_regen": 0.1,
		"magic_damage": 0,
		"precision": 0,
		"evasion": 0,
		"ranged_damage_bonus": 0,
		"loot_improvement": 0,
		"crit_chance": 0,
		"movement_speed": -0.05
	},
	"intelligence": {
		"physical_damage": 0,
		"resistance": -2,
		"health": -1,
		"health_regen": 0,
		"mana": 3,
		"mana_regen": 0.1,
		"magic_damage": 3,
		"precision": 0,
		"evasion": -0.025,
		"ranged_damage_bonus": 0,
		"loot_improvement": 0,
		"crit_chance": 0.5,
		"movement_speed": -0.025
	},
	"dexterity": {
		"physical_damage": -1,
		"resistance": 0,
		"health": 0,
		"health_regen": -0.025,
		"mana": 0,
		"mana_regen": 0,
		"magic_damage": -2,
		"precision": 2,
		"evasion": 0,
		"ranged_damage_bonus": 2,
		"loot_improvement": 0,
		"crit_chance": 1,
		"movement_speed": 0
	},
	"agility": {
		"physical_damage": 0,
		"resistance": 1,
		"health": -1,
		"health_regen": -0.025,
		"mana": -1,
		"mana_regen": -0.1,
		"magic_damage": -3,
		"precision": 1,
		"evasion": 1.5,
		"ranged_damage_bonus": 0,
		"loot_improvement": 0,
		"crit_chance": 1,
		"movement_speed": 0.05
	},
	"luck": {
		"physical_damage": -1,
		"resistance": 0,
		"health": 0,
		"health_regen": -0.025,
		"mana": 0,
		"mana_regen": 0,
		"magic_damage": -1,
		"precision": 0,
		"evasion": 0,
		"ranged_damage_bonus": -1,
		"loot_improvement": 3,
		"crit_chance": 1.5,
		"movement_speed": 0
	}
}

func _ready():
	calculate_derived_stats()
	Equipment.equipment_changed.connect(_on_equipment_changed)

func _on_equipment_changed():
	calculate_derived_stats()

func add_attribute_point(attribute_name: String):
	if base_attributes.has(attribute_name):
		base_attributes[attribute_name] += 1
		calculate_derived_stats()
		stats_changed.emit()

func calculate_derived_stats():
	for stat_key in derived_stats.keys():
		derived_stats[stat_key] = 0
	
	derived_stats["health"] = 20
	derived_stats["mana"] = 20
	derived_stats["movement_speed"] = 1.0
	derived_stats["health_regen"] = 1.0
	derived_stats["mana_regen"] = 2.0
	
	var total_attributes = base_attributes.duplicate()
	
	var equipment_stats = Equipment.get_total_stats()
	for equipment_slot in Equipment.equipped_items.keys():
		var item = Equipment.get_equipped_item(equipment_slot)
		if item != null and item.attributes != null:
			for attr_name in item.attributes.keys():
				if total_attributes.has(attr_name):
					total_attributes[attr_name] += item.attributes[attr_name]
	
	for attr_name in total_attributes.keys():
		var attr_value = total_attributes[attr_name]
		var formulas = ATTRIBUTE_FORMULAS[attr_name]
		
		for stat_key in formulas.keys():
			derived_stats[stat_key] += formulas[stat_key] * attr_value
	
	for stat_key in equipment_stats.keys():
		if derived_stats.has(stat_key):
			derived_stats[stat_key] += equipment_stats[stat_key]
	
	var max_health = max(1, derived_stats["health"])
	var max_mana = max(0, derived_stats["mana"])
	
	if current_health > max_health:
		current_health = max_health
	if current_mana > max_mana:
		current_mana = max_mana
	
	stats_changed.emit()

func get_max_health() -> float:
	return max(1, derived_stats["health"])

func get_max_mana() -> float:
	return max(0, derived_stats["mana"])

func get_stat(stat_name: String) -> float:
	if derived_stats.has(stat_name):
		return derived_stats[stat_name]
	return 0.0

func get_attribute(attr_name: String) -> int:
	if base_attributes.has(attr_name):
		return base_attributes[attr_name]
	return 0

func reset_stats():
	for key in base_attributes.keys():
		base_attributes[key] = 0
	calculate_derived_stats()
	current_health = get_max_health()
	current_mana = get_max_mana()
	stats_changed.emit()

