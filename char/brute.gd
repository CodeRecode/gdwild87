extends Enemy

@export var Speed = 5.0
@export var Health = 50.0
@export var AttackDamage = 5.0
@export var AttackWindupTime = 2.0
@export var AttackWinddownTime = 0.5

var target: Player
var is_in_attack_area: bool = false
var attacking: bool = false

func _ready() -> void:
	set_health(Health)

func _physics_process(delta: float) -> void:
	if attacking:
		return
		
	_face_player()
	
	var delta_speed = Speed * delta * Engine.physics_ticks_per_second
	if target:
		var direction = (target.global_position - global_position).normalized()
		velocity.x = direction.x * delta_speed
		velocity.z = direction.z * delta_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta_speed)
		velocity.z = move_toward(velocity.z, 0, delta_speed)
	move_and_slide()
	
	_try_attack()
	
func _face_player() -> void:
	if not target:
		return
	var look_to = target.global_position
	look_at(look_to)

func _try_attack() -> void:
	if not is_in_attack_area or attacking:
		return
	attacking = true
	await get_tree().create_timer(AttackWindupTime).timeout
	if is_in_attack_area:
		target.apply_damage(AttackDamage)
		
	await get_tree().create_timer(AttackWinddownTime).timeout
	attacking = false

func _on_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body as Player

func _on_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = null

func _on_attack_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_attack_area = true

func _on_attack_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		is_in_attack_area = false
