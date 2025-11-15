extends CanvasLayer
class_name MenuUI

signal start_button_pressed()

@onready var settings_menu: PanelContainer = $SettingsMenu
@onready var credits_menu: PanelContainer = $CreditsMenu
@onready var start_button: Button = %StartButton
@onready var music_slider: Slider = %MusicSlider
@onready var credits_close_button: Button = %CreditsCloseButton

func _ready() -> void:
	start_button.grab_focus()
	MusicManager.play_music()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if credits_menu.visible:
			credits_menu.hide()
		elif settings_menu.visible:
			settings_menu.hide()

func _on_main_menu_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		if credits_menu.visible:
			credits_menu.hide()
		elif settings_menu.visible:
			settings_menu.hide()

func _on_start_button_pressed() -> void:
	start_button_pressed.emit()

func _on_settings_button_pressed() -> void:
	settings_menu.show()
	music_slider.grab_focus()

func _on_settings_close_button_pressed() -> void:
	settings_menu.hide()
	start_button.grab_focus()

func _on_credits_button_pressed() -> void:
	credits_menu.show()
	credits_close_button.grab_focus()
	
func _on_credits_close_button_pressed() -> void:
	credits_menu.hide()
	start_button.grab_focus()
	
func _on_music_slider_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_volume_linear(bus_idx, value / 100.)

func _on_effects_slider_value_changed(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("SoundEffects")
	AudioServer.set_bus_volume_linear(bus_idx, value / 100.)
