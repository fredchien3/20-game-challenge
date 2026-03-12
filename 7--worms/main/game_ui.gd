extends CanvasLayer

@export var grenade_display: PanelContainer
@export var bazooka_display: PanelContainer

@onready var current_display: PanelContainer = grenade_display


func _on_bean_weapon_selected(number: int) -> void:
	var previous_display = current_display

	if number == 1:
		current_display = grenade_display
	elif number == 2:
		current_display = bazooka_display
	else:
		printerr("Weapon display not implemented")

	previous_display.theme_type_variation = ""
	current_display.theme_type_variation = "PanelContainerOutlined"
