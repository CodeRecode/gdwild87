extends CharacterBody3D
class_name Player

@export var Speed = 10.0
@export var JumpVelocity = 4.5

@export var InitAttackDamage = 10.0
@export var InitAttackRadius = 2.0
@export var InitAttackCooldown = 0.5
@export var AttackAngle = 70.0

var attack_cooldown = -100.0

@onready var camera_3d: Camera3D = $Camera3D
@onready var body_mesh: MeshInstance3D = $Body
@onready var attack_debug: MeshInstance3D = $AttackDebug
@onready var attack_area: Area3D = $AttackArea
@onready var attack_collision: CollisionShape3D = $AttackArea/AttackCollision

func _physics_process(delta: float) -> void:
	_face_mouse()
	_calc_upgrades()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JumpVelocity

	var delta_speed = Speed * delta * Engine.physics_ticks_per_second
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * delta_speed
		velocity.z = direction.z * delta_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta_speed)
		velocity.z = move_toward(velocity.z, 0, delta_speed)

	move_and_slide()

	_calc_attack(delta)
	
func _calc_attack(delta: float) -> void:
	if attack_cooldown > 0.0:
		attack_cooldown -= delta
		return
		
	if Input.is_action_just_pressed("attack"):
		attack_cooldown = InitAttackCooldown
		
		var vector_forward = -body_mesh.basis.z
		var targets = attack_area.get_overlapping_bodies()
		for target in targets:
			if not target.is_in_group("enemy"):
				continue
				
			var vector_to = target.global_position - global_position
			var angle = rad_to_deg(vector_forward.angle_to(vector_to))
			if angle > AttackAngle:
				continue
			
			var enemy = target as Enemy
			enemy.apply_damage(11.0)
		
		#debug draw
		#attack_debug.global_position = global_position + vector_forward
		#attack_debug.rotation.y = body_mesh.rotation.y
		#attack_debug.visible = true
		#await get_tree().create_timer(.5).timeout
		#attack_debug.visible = false

func _calc_upgrades() -> void:
	attack_collision.shape.radius = InitAttackRadius

func _face_mouse() -> void:
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camera_3d.project_ray_origin(mouse_pos)
	var normal = camera_3d.project_ray_normal(mouse_pos)
	var point = Plane.PLANE_XZ.intersects_ray(origin, normal)
	if point:
		body_mesh.look_at(point + Vector3.UP)
