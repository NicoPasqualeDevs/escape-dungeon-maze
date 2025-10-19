extends Node

signal equipment_changed

enum EquipSlot {
	HELMET,
	CHEST,
	LEGS,
	BOOTS,
	GLOVES,
	BELT,
	NECKLACE,
	RING1,
	RING2,
	WEAPON
}

var equipped_items: Dictionary = {
	EquipSlot.HELMET: null,
	EquipSlot.CHEST: null,
	EquipSlot.LEGS: null,
	EquipSlot.BOOTS: null,
	EquipSlot.GLOVES: null,
	EquipSlot.BELT: null,
	EquipSlot.NECKLACE: null,
	EquipSlot.RING1: null,
	EquipSlot.RING2: null,
	EquipSlot.WEAPON: null
}

func equip_item(item: Inventory.Item, slot: EquipSlot) -> Inventory.Item:
	var previous_item = equipped_items[slot]
	equipped_items[slot] = item
	equipment_changed.emit()
	return previous_item

func unequip_item(slot: EquipSlot) -> Inventory.Item:
	var item = equipped_items[slot]
	equipped_items[slot] = null
	equipment_changed.emit()
	return item

func get_equipped_item(slot: EquipSlot) -> Inventory.Item:
	return equipped_items[slot]

func is_slot_empty(slot: EquipSlot) -> bool:
	return equipped_items[slot] == null

func get_slot_name(slot: EquipSlot) -> String:
	match slot:
		EquipSlot.HELMET:
			return "Helmet"
		EquipSlot.CHEST:
			return "Chest"
		EquipSlot.LEGS:
			return "Legs"
		EquipSlot.BOOTS:
			return "Boots"
		EquipSlot.GLOVES:
			return "Gloves"
		EquipSlot.BELT:
			return "Belt"
		EquipSlot.NECKLACE:
			return "Necklace"
		EquipSlot.RING1:
			return "Ring 1"
		EquipSlot.RING2:
			return "Ring 2"
		EquipSlot.WEAPON:
			return "Weapon"
	return "Unknown"

func get_weapon() -> Inventory.Item:
	return equipped_items[EquipSlot.WEAPON]

func get_weapon_damage() -> float:
	var weapon = get_weapon()
	if weapon:
		return weapon.damage
	return 5.0

func get_weapon_attack_speed() -> float:
	var weapon = get_weapon()
	if weapon:
		return weapon.attack_speed
	return 1.0

func get_weapon_range() -> float:
	var weapon = get_weapon()
	if weapon:
		return weapon.range
	return 100.0

func get_total_stats() -> Dictionary:
	var total_stats = {
		"physical_damage": 0,
		"resistance": 0,
		"health": 0,
		"mana": 0,
		"magic_damage": 0
	}
	
	for slot in equipped_items.keys():
		var item = equipped_items[slot]
		if item != null and item.stats != null:
			for stat_key in item.stats.keys():
				if total_stats.has(stat_key):
					total_stats[stat_key] += item.stats[stat_key]
	
	return total_stats

func clear_equipment() -> void:
	for slot in equipped_items.keys():
		equipped_items[slot] = null
	equipment_changed.emit()
