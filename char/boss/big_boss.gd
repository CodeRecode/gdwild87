extends Enemy

@export var speed: float
@export var aoe_count_on_cast: int
@export var aoe_distance_from_player: float
@export var aoe_scene: PackedScene
var target: Player

@onready var healthbar: ProgressBar = %HealthBar
@onready var health_label: Label = %HealthLabel
@onready var cast_timer: Timer = %CastTimer

func _ready() -> void:
	cast_timer.timeout.connect(cast)

func _process(_delta: float) -> void:
	healthbar.max_value = health_component.max_health
	healthbar.value = health_component.current_health
	health_label.text = str(int(healthbar.value)) + " / " + str(int(healthbar.max_value))

func _physics_process(delta: float) -> void:
	var delta_speed = speed * delta * Engine.physics_ticks_per_second
	if not target:
		target = get_tree().get_first_node_in_group("player")
		return

	var direction = (target.global_position - global_position).normalized()
	velocity.x = direction.x * delta_speed
	velocity.z = direction.z * delta_speed
	move_and_slide()

func cast() -> void:
	var angle: float = 2 * PI / aoe_count_on_cast
	for i in range(aoe_count_on_cast):
		var aoe: Node3D = aoe_scene.instantiate()
		get_tree().root.add_child(aoe)
		var direction_from_player := Vector3(sin(angle * i), 0, cos(angle * i))
		aoe.global_position = target.global_position + (direction_from_player * aoe_distance_from_player) + Vector3(0,0.2,0)
