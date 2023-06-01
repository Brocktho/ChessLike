class_name Tile
extends ColorRect

signal pressed(current_pos : Vector2)

var interactable = true
var current_pos = Vector2(0,0)

func init(pos: Vector2, interactable: bool):
	current_pos = pos
	interactable = interactable
	mouse_default_cursor_shape = Control.CURSOR_HELP
	if not interactable:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_STOP
	return self

func interaction():
	print("Emit interaction")
	pressed.emit(current_pos)

func _gui_input(event):
	if interactable:
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
				pressed.emit(current_pos)
