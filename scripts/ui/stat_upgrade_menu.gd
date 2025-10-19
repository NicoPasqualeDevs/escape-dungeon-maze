extends Control

signal attribute_selected(attribute_name: String)

@onready var brutality_button = $Panel/VBoxContainer/AttributesContainer/BrutalityButton
@onready var spirit_button = $Panel/VBoxContainer/AttributesContainer/SpiritButton
@onready var intelligence_button = $Panel/VBoxContainer/AttributesContainer/IntelligenceButton
@onready var dexterity_button = $Panel/VBoxContainer/AttributesContainer/DexterityButton
@onready var agility_button = $Panel/VBoxContainer/AttributesContainer/AgilityButton
@onready var luck_button = $Panel/VBoxContainer/AttributesContainer/LuckButton

@onready var stats_label = $Panel/VBoxContainer/StatsLabel
@onready var title_label = $Panel/VBoxContainer/TopBar/TitleLabel
@onready var points_label = $Panel/VBoxContainer/PointsLabel

func _ready():
	brutality_button.pressed.connect(_on_attribute_selected.bind("brutality"))
	spirit_button.pressed.connect(_on_attribute_selected.bind("spirit"))
	intelligence_button.pressed.connect(_on_attribute_selected.bind("intelligence"))
	dexterity_button.pressed.connect(_on_attribute_selected.bind("dexterity"))
	agility_button.pressed.connect(_on_attribute_selected.bind("agility"))
	luck_button.pressed.connect(_on_attribute_selected.bind("luck"))
	
	update_stats_display()
	update_points_display()

func update_stats_display():
	if not GameState.player_stats:
		return
	
	var stats_text = "Current Stats:\n\n"
	stats_text += "Brutality: %d\n" % GameState.player_stats.get_attribute("brutality")
	stats_text += "Spirit: %d\n" % GameState.player_stats.get_attribute("spirit")
	stats_text += "Intelligence: %d\n" % GameState.player_stats.get_attribute("intelligence")
	stats_text += "Dexterity: %d\n" % GameState.player_stats.get_attribute("dexterity")
	stats_text += "Agility: %d\n" % GameState.player_stats.get_attribute("agility")
	stats_text += "Luck: %d\n" % GameState.player_stats.get_attribute("luck")
	
	stats_label.text = stats_text

func update_points_display():
	if points_label:
		points_label.text = "Points Available: %d" % GameState.pending_stat_points

func _on_attribute_selected(attribute_name: String):
	if GameState.pending_stat_points <= 0:
		return
	
	if GameState.player_stats:
		GameState.player_stats.add_attribute_point(attribute_name)
	
	GameState.use_stat_point()
	
	attribute_selected.emit(attribute_name)
	
	update_stats_display()
	update_points_display()
	
	if GameState.pending_stat_points <= 0:
		await get_tree().create_timer(0.5).timeout
		get_tree().change_scene_to_file("res://scenes/world/main.tscn")
