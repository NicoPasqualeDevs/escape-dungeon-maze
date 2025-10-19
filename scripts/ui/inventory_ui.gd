extends Control

@onready var grid_container = $Panel/MarginContainer/VBoxContainer/MainContainer/InventoryPanel/ScrollContainer/GridContainer
@onready var item_name_label = $Panel/MarginContainer/VBoxContainer/ItemInfo/NameLabel
@onready var item_description_label = $Panel/MarginContainer/VBoxContainer/ItemInfo/DescriptionLabel
@onready var close_button = $Panel/MarginContainer/VBoxContainer/TopBar/CloseButton
@onready var player_image = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/PlayerImage

@onready var helmet_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/HelmetSlot
@onready var chest_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/ChestSlot
@onready var legs_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/LegsSlot
@onready var boots_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/BootsSlot
@onready var gloves_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/GlovesSlot
@onready var belt_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/BeltSlot
@onready var necklace_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/NecklaceSlot
@onready var ring1_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/Ring1Slot
@onready var ring2_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/Ring2Slot
@onready var weapon_slot = $Panel/MarginContainer/VBoxContainer/MainContainer/EquipmentPanel/EquipmentContainer/WeaponSlot

var slot_buttons: Array = []
var equipment_slot_buttons: Dictionary = {}
var selected_slot: int = -1

func _ready():
	close_button.pressed.connect(_on_close_button_pressed)
	Inventory.inventory_changed.connect(_on_inventory_changed)
	Equipment.equipment_changed.connect(_on_equipment_changed)
	
	setup_player_image()
	setup_equipment_slots()
	create_inventory_slots()
	update_inventory_display()
	update_equipment_display()
	hide()

func setup_player_image():
	var texture = load("res://assets/characters/knight_m_idle_anim_f0.png")
	if texture and player_image:
		player_image.texture = texture

func setup_equipment_slots():
	equipment_slot_buttons[Equipment.EquipSlot.HELMET] = helmet_slot
	equipment_slot_buttons[Equipment.EquipSlot.CHEST] = chest_slot
	equipment_slot_buttons[Equipment.EquipSlot.LEGS] = legs_slot
	equipment_slot_buttons[Equipment.EquipSlot.BOOTS] = boots_slot
	equipment_slot_buttons[Equipment.EquipSlot.GLOVES] = gloves_slot
	equipment_slot_buttons[Equipment.EquipSlot.BELT] = belt_slot
	equipment_slot_buttons[Equipment.EquipSlot.NECKLACE] = necklace_slot
	equipment_slot_buttons[Equipment.EquipSlot.RING1] = ring1_slot
	equipment_slot_buttons[Equipment.EquipSlot.RING2] = ring2_slot
	equipment_slot_buttons[Equipment.EquipSlot.WEAPON] = weapon_slot
	
	for slot in equipment_slot_buttons.keys():
		var button = equipment_slot_buttons[slot]
		button.pressed.connect(_on_equipment_slot_pressed.bind(slot))
		style_equipment_slot(button, slot)

func create_inventory_slots():
	for i in range(Inventory.max_slots):
		var slot_button = Button.new()
		slot_button.custom_minimum_size = Vector2(GameConstants.UI.slot_size, GameConstants.UI.slot_size)
		slot_button.pressed.connect(_on_slot_pressed.bind(i))
		
		var style_box = ResourceManager.get_button_stylebox(Color(0.2, 0.2, 0.25))
		
		slot_button.add_theme_stylebox_override("normal", style_box)
		slot_button.add_theme_stylebox_override("hover", style_box)
		slot_button.add_theme_stylebox_override("pressed", style_box)
		
		grid_container.add_child(slot_button)
		slot_buttons.append(slot_button)

func update_inventory_display():
	for i in range(slot_buttons.size()):
		var item = Inventory.get_item(i)
		var button = slot_buttons[i]
		
		if item != null:
			if item.icon_path != "" and ResourceLoader.exists(item.icon_path):
				button.icon = load(item.icon_path)
			else:
				button.icon = null
			
			if item.quantity > 1:
				button.text = str(item.quantity)
			else:
				button.text = ""
			
			var rarity_color = Inventory.get_rarity_color(item.rarity)
			button.modulate = rarity_color
		else:
			button.icon = null
			button.text = ""
			button.modulate = Color(1, 1, 1)

func _on_slot_pressed(slot_index: int):
	selected_slot = slot_index
	var item = Inventory.get_item(slot_index)
	
	if item != null:
		var rarity_name = Inventory.get_rarity_name(item.rarity)
		var rarity_color = Inventory.get_rarity_color(item.rarity)
		item_name_label.text = item.name + " [" + rarity_name + "]"
		item_name_label.modulate = rarity_color
		item_description_label.text = item.description
	else:
		item_name_label.text = "Empty Slot"
		item_name_label.modulate = Color(1, 1, 1)
		item_description_label.text = ""

func style_equipment_slot(button: Button, slot: Equipment.EquipSlot):
	var style_box = ResourceManager.get_button_stylebox(Color(0.15, 0.15, 0.2), Color(0.6, 0.5, 0.3), 3)
	
	button.add_theme_stylebox_override("normal", style_box)
	button.add_theme_stylebox_override("hover", style_box)
	button.add_theme_stylebox_override("pressed", style_box)

func update_equipment_display():
	for slot in equipment_slot_buttons.keys():
		var button = equipment_slot_buttons[slot]
		var item = Equipment.get_equipped_item(slot)
		
		if item != null:
			if item.icon_path != "" and ResourceLoader.exists(item.icon_path):
				button.icon = load(item.icon_path)
			else:
				button.icon = null
			button.text = ""
			
			var rarity_color = Inventory.get_rarity_color(item.rarity)
			button.modulate = rarity_color
		else:
			button.icon = null
			button.text = Equipment.get_slot_name(slot)
			button.modulate = Color(1, 1, 1)

func _on_equipment_slot_pressed(slot: Equipment.EquipSlot):
	var item = Equipment.get_equipped_item(slot)
	if item != null:
		var rarity_name = Inventory.get_rarity_name(item.rarity)
		var rarity_color = Inventory.get_rarity_color(item.rarity)
		item_name_label.text = item.name + " [" + rarity_name + "]"
		item_name_label.modulate = rarity_color
		item_description_label.text = item.description
	else:
		item_name_label.text = "Empty Slot"
		item_name_label.modulate = Color(1, 1, 1)
		item_description_label.text = ""

func _on_equipment_changed():
	update_equipment_display()

func _on_inventory_changed():
	update_inventory_display()

func _on_close_button_pressed():
	hide()

func _input(event):
	if event.is_action_pressed("ui_cancel") and visible:
		hide()
		get_viewport().set_input_as_handled()
