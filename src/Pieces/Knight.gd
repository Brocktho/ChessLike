class_name Knight
extends Sprite2D

var available_moves: Array
var current_pos = Vector2(3, 3)

func possible_moves():
	available_moves = [];
	var x = current_pos[0]
	var y = current_pos[1]
	for direction in Globals.directions:
		var dir_x = direction[0]
		var dir_y = direction[1]
		if dir_x != 0:
			var delta_x = x + (dir_x * 2)
			if delta_x >= 0 && delta_x <= 7:
				var down_y = y - 1;
				var up_y = y + 1;
				if up_y <= 7:
					available_moves.append(Vector2(delta_x, up_y))
				if down_y >= 0:
					available_moves.append(Vector2(delta_x, down_y))
		if dir_y != 0:
			var delta_y = y + (dir_y * 2)
			if delta_y >= 0 && delta_y <= 7:
				var right_x = x + 1;
				var left_x = x - 1;
				if right_x <= 7:
					available_moves.append(Vector2(right_x, delta_y))
				if left_x >= 0:
					available_moves.append(Vector2(left_x, delta_y))
	print(available_moves)

func init(pos: Vector2):
				self.current_pos = pos

func _ready():
	pass

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Z:
			possible_moves()
