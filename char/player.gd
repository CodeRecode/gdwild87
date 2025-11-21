extends CharacterBody3D
class_name Player

@export_category("movement")
@export var initial_speed := 10.0
@export var speed_curve: Curve
@export var jump_velocity := 4.5
@export_category("attack")
@export var initial_attack_damage := 10.0
@export var attack_curve: Curve
@export var initial_attack_speed := 1.5
@export var attack_speed_curve: Curve
@export var initial_attack_range: float = 1
@export var attack_range_curve: Curve
@export_category("health")
@export var initial_health := 10.0
@export var health_curve: Curve
var speed_level: int = 0
var speed: float = 0
var attack_level: int = 0
var attack_speed_level: int = 0
var attack_range_level: int = 0
var	attack_animation_play_speed: float

@onready var camera_3d: Camera3D = $Camera3D
@onready var body_mesh: MeshInstance3D = $Body
@onready var attack_collision: CollisionShape3D = %AttackCollision
@onready var attack_hitbox: Hitbox = %AttackHitbox
@onready var attack_timer: Timer = %AttackTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var health_component: HealthComponent = %HealthComponent

func _ready() -> void:
	attack_hitbox.damage = initial_attack_damage
	animation_player.animation_finished.connect(_on_animation_finished)
	attack_animation_play_speed = animation_player.get_animation("attack").length

func _process(_delta: float) -> void:
	attack_hitbox.damage = calculate_value_from_curve(initial_attack_damage, attack_level, attack_curve) 
	speed = calculate_value_from_curve(initial_speed, speed_level, speed_curve)

func _physics_process(delta: float) -> void:
	_face_mouse()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	if attack_timer.is_stopped():
		if Input.is_action_pressed("attack"):
			animation_player.play("attack")	
			_on_attack()
		if Input.is_action_pressed("attack_2"):
			_on_attack()

	var delta_speed = speed * delta * Engine.physics_ticks_per_second
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * delta_speed
		velocity.z = direction.z * delta_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta_speed)
		velocity.z = move_toward(velocity.z, 0, delta_speed)

	move_and_slide()
	
func calculate_value_from_curve(initial_val: float, level: int, curve: Curve) -> float:
	return initial_val + curve.sample(level)

func _face_mouse() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera_3d.project_ray_origin(mouse_pos)
	var normal = camera_3d.project_ray_normal(mouse_pos)
	var point = Plane.PLANE_XZ.intersects_ray(origin, normal)
	if point:
		point.y = body_mesh.global_position.y
		body_mesh.look_at(point)

func _on_attack() -> void:
	attack_timer.wait_time = initial_attack_speed * attack_speed_curve.sample(attack_speed_level)
	attack_timer.start()
	animation_player.speed_scale = 1 / attack_speed_curve.sample(attack_speed_level)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "attack":
		animation_player.play("RESET")
