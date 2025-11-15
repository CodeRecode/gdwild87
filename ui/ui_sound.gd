extends Node

var button_press_sounds: Array[AudioStreamPlayer] = []
var button_hover_sounds: Array[AudioStreamPlayer] = []
var slider_move_sounds: Array[AudioStreamPlayer] = []

@onready var press_1: AudioStreamPlayer = $ButtonPressSound1
@onready var press_2: AudioStreamPlayer = $ButtonPressSound2
@onready var press_3: AudioStreamPlayer = $ButtonPressSound3
@onready var hover_1: AudioStreamPlayer = $ButtonHoverSound1
@onready var hover_2: AudioStreamPlayer = $ButtonHoverSound2
@onready var hover_3: AudioStreamPlayer = $ButtonHoverSound3
@onready var slide_1: AudioStreamPlayer = $SliderSound1
@onready var slide_2: AudioStreamPlayer = $SliderSound2
@onready var slide_3: AudioStreamPlayer = $SliderSound3

func _ready() -> void:
	# when _ready is called, there might already be nodes in the tree, so connect all existing buttons
	connect_buttons(get_tree().root)
	get_tree().node_added.connect(_on_tree_node_added)

	button_press_sounds = [press_1, press_2, press_3]
	button_hover_sounds = [hover_1, hover_2, hover_3]
	slider_move_sounds = [slide_1, slide_2, slide_3]

func _on_tree_node_added(node: Node) -> void:
	if node is Button:
		connect_to_button(node)

func _on_button_pressed() -> void:
	button_press_sounds.pick_random().play()

func _on_mouse_entered() -> void:
	button_hover_sounds.pick_random().play()

# recursively connect all buttons
func connect_buttons(root: Node) -> void:
	for child in root.get_children():
		if child is BaseButton:
			connect_to_button(child)
		connect_buttons(child)
		if child is Slider:
			connect_to_slider(child)

func connect_to_button(button: Button) -> void:
	button.pressed.connect(_on_button_pressed)
	button.mouse_entered.connect(_on_mouse_entered)
	button.focus_exited.connect(_on_mouse_entered)

func connect_to_slider(slider: Slider) -> void:
	slider.focus_exited.connect(_on_mouse_entered)
	slider.value_changed.connect(func(_val: float) -> void: slider_move_sounds.pick_random().play())
