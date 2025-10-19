extends Node

signal inventory_changed

enum WeaponType {
	MELEE,
	RANGED,
	MAGIC
}

enum ItemRarity {
	NORMAL,
	COMMON,
	UNCOMMON,
	RARE,
	LEGENDARY,
	UNIQUE
}

var items: Array = []
var max_slots: int = 24

class Item:
	var id: String
	var name: String
	var description: String
	var icon_path: String
	var icon: String
	var quantity: int
	var max_stack: int
	var item_type: String
	var equipment_slot = null
	var attributes: Dictionary = {}
	var stats: Dictionary = {}
	var damage: float = 0.0
	var attack_speed: float = 1.0
	var range: float = 100.0
	var weapon_type = null
	var rarity: ItemRarity = ItemRarity.NORMAL
	
	func _init(p_id: String, p_name: String, p_desc: String = "", p_icon: String = "", p_type: String = "misc", p_max_stack: int = 99):
		id = p_id
		name = p_name
		description = p_desc
		icon_path = p_icon
		icon = p_icon
		item_type = p_type
		max_stack = p_max_stack
		quantity = 1

static func get_rarity_color(rarity: ItemRarity) -> Color:
	match rarity:
		ItemRarity.NORMAL:
			return Color(0.6, 0.6, 0.6)
		ItemRarity.COMMON:
			return Color(1.0, 1.0, 1.0)
		ItemRarity.UNCOMMON:
			return Color(0.3, 1.0, 0.3)
		ItemRarity.RARE:
			return Color(0.3, 0.6, 1.0)
		ItemRarity.LEGENDARY:
			return Color(1.0, 0.5, 0.0)
		ItemRarity.UNIQUE:
			return Color(1.0, 0.0, 1.0)
	return Color(1, 1, 1)

static func get_rarity_name(rarity: ItemRarity) -> String:
	match rarity:
		ItemRarity.NORMAL:
			return "Normal"
		ItemRarity.COMMON:
			return "Common"
		ItemRarity.UNCOMMON:
			return "Uncommon"
		ItemRarity.RARE:
			return "Rare"
		ItemRarity.LEGENDARY:
			return "Legendary"
		ItemRarity.UNIQUE:
			return "Unique"
	return "Unknown"

func _ready():
	max_slots = GameConstants.UI.inventory_slots
	for i in range(max_slots):
		items.append(null)

func add_item(item: Item) -> bool:
	for i in range(items.size()):
		if items[i] != null and items[i].id == item.id and items[i].quantity < items[i].max_stack:
			var space_left = items[i].max_stack - items[i].quantity
			var amount_to_add = min(item.quantity, space_left)
			items[i].quantity += amount_to_add
			item.quantity -= amount_to_add
			
			if item.quantity <= 0:
				inventory_changed.emit()
				return true
	
	for i in range(items.size()):
		if items[i] == null:
			items[i] = item
			inventory_changed.emit()
			return true
	
	return false

func remove_item(slot_index: int, amount: int = 1) -> void:
	if slot_index < 0 or slot_index >= items.size():
		return
	
	if items[slot_index] == null:
		return
	
	items[slot_index].quantity -= amount
	
	if items[slot_index].quantity <= 0:
		items[slot_index] = null
	
	inventory_changed.emit()

func get_item(slot_index: int) -> Item:
	if slot_index < 0 or slot_index >= items.size():
		return null
	return items[slot_index]

func has_item(item_id: String) -> bool:
	for item in items:
		if item != null and item.id == item_id:
			return true
	return false

func get_item_count(item_id: String) -> int:
	var count = 0
	for item in items:
		if item != null and item.id == item_id:
			count += item.quantity
	return count

func clear_inventory() -> void:
	for i in range(items.size()):
		items[i] = null
	inventory_changed.emit()

func move_item(from_slot: int, to_slot: int) -> void:
	if from_slot < 0 or from_slot >= items.size():
		return
	if to_slot < 0 or to_slot >= items.size():
		return
	
	var temp = items[from_slot]
	items[from_slot] = items[to_slot]
	items[to_slot] = temp
	
	inventory_changed.emit()

