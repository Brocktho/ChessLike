class_name Tile
extends ColorRect

signal pressed(current_pos : Vector2)

var interactable = true
var current_pos = Vector2(0,0)

func center_self():
	anchor_left = 0.5
	anchor_top = 0.5
	anchor_right = 0.5
	anchor_bottom = 0.5
	return self

func add_border():
	var ref = ReferenceRect.new()
	ref.mouse_filter = Control.MOUSE_FILTER_IGNORE
	ref.z_index = 2
	ref.border_color = Color("BLACK")
	ref.border_width = 1
	ref.editor_only = false
	ref.get_parent_area_size()
	add_child(ref)

func init(pos: Vector2, can_interact: bool, border: bool = true):
	current_pos = pos
	if border:
		add_border()
	
	interactable = can_interact
	position = pos * 32
	if not interactable:
		mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		mouse_filter = Control.MOUSE_FILTER_PASS
		mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
	return self

func _gui_input(event):
	if interactable:
		if event is InputEventMouseButton:
			if event.is_pressed() && event.button_index == MOUSE_BUTTON_LEFT:
				pressed.emit(current_pos)
