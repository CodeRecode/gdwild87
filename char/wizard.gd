extends Enemy

@export var projectile: PackedScene
@export var speed = 5.0
@export var attack_cooldown = 1.0
var current_cooldown = -1.0
var target: Player
var can_attack: bool = false

func _physics_process(delta: float) -> void:
	_face_player()
	_try_attack(delta)
	
func _face_player() -> void:
	if not target:
		return
	var look_to = target.global_position
	look_to.y = 0
	look_at(look_to)
	
func _try_attack(delta: float) -> void:
	if current_cooldown > 0.0:
		current_cooldown -= delta
		return
	
	if not target:
		return
	var forward = -global_basis.z
	var orb = projectile.instantiate()
	orb.set_direction(forward)
	owner.add_child(orb)
	orb.global_position = global_position + Vector3.UP + forward * .5
	
	current_cooldown = attack_cooldown
	

func _on_vision_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = body as Player

func _on_vision_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		target = null
