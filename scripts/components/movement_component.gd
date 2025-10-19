extends Node
class_name MovementComponent

@export var base_speed: float = 100.0
@export var can_dash: bool = false
@export var dash_speed: float = 300.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 2.0

var character_body: CharacterBody2D
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cooldown_timer: float = 0.0
var dash_direction: Vector2 = Vector2.ZERO

func _ready():
	character_body = get_parent() as CharacterBody2D
	if not character_body:
		push_error("MovementComponent must be child of CharacterBody2D")

func _physics_process(delta: float):
	if dash_cooldown_timer > 0:
		dash_cooldown_timer -= delta
	
	if is_dashing:
		_handle_dash(delta)

func move(direction: Vector2, speed_multiplier: float = 1.0) -> void:
	if is_dashing:
		return
	
	var final_speed = base_speed * speed_multiplier
	
	if direction != Vector2.ZERO:
		character_body.velocity = direction.normalized() * final_speed
	else:
		character_body.velocity = Vector2.ZERO

func start_dash(direction: Vector2) -> bool:
	if not can_dash or dash_cooldown_timer > 0 or direction == Vector2.ZERO:
		return false
	
	is_dashing = true
	dash_timer = dash_duration
	dash_direction = direction.normalized()
	dash_cooldown_timer = dash_cooldown
	return true

func _handle_dash(delta: float) -> void:
	dash_timer -= delta
	
	if dash_timer <= 0:
		is_dashing = false
		character_body.velocity = Vector2.ZERO
	else:
		character_body.velocity = dash_direction * dash_speed

func chase_target(target_position: Vector2, speed_multiplier: float = 1.0) -> void:
	if is_dashing:
		return
	
	var direction = (target_position - character_body.global_position).normalized()
	character_body.velocity = direction * base_speed * speed_multiplier

func stop() -> void:
	if not is_dashing:
		character_body.velocity = Vector2.ZERO

