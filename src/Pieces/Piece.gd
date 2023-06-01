class_name Piece
extends Sprite2D

var available_moves: Array
var current_pos = Vector2(3, 3)
var board = self.get_parent()
var alignment = 1;
var exhausted = false;

func check_collision(key : String):
	if key in self.board.grid:
		var found_piece = self.board.grid[key]
		if found_piece.alignment == alignment:
			return [true, true]
		return [true, false]
	return [false, false]
	
func rook_moves():
	for direction in Globals.directions:
		# [1,0] [0,1] [-1,0] [0,-1]
		var dir_x = direction[0]
		var dir_y = direction[1]
		var finished = false;
		var move_this_dir = [];
		var x = self.current_pos[0]
		var y = self.current_pos[1]
		if dir_x != 0:
			x += dir_x
			while (x >= 0 && x <= Globals.w_edge && !finished):
				var result = check_collision(str(x) + str(y))
				finished = result[0]
				var own_piece = result[1]
				if own_piece: break
				move_this_dir.append(Vector2(x, y))
				x += dir_x
				
		if dir_y != 0:
			y += dir_y
			while (y >= 0 && y <= Globals.l_edge && !finished):
				var result = check_collision(str(x) + str(y))
				finished = result[0]
				var own_piece = result[1]
				if own_piece: break
				move_this_dir.append(Vector2(x, y))
				y += dir_y
		available_moves.append(move_this_dir)

func bishop_moves():
	for diag in Globals.diags:
		var dir_x = diag[0]
		var dir_y = diag[1]
		var finished = false;
		var move_this_dir = [];
		var x = self.current_pos[0] + dir_x
		var y = self.current_pos[1] + dir_y
		while (x >= 0 && x <= Globals.w_edge && y >= 0 && y <= Globals.l_edge && !finished):
			var result = check_collision(str(x) + str(y))
			finished = result[0]
			var own_piece = result[1]
			if own_piece: break
			move_this_dir.append(Vector2(x,y))
			x += dir_x
			y += dir_y
		available_moves.append(move_this_dir)

# To be used by non long-boy moves
func valid_move(key: String, move: Vector2):
	if move[0] >= 0 && move[0] <= Globals.w_edge && move[1] >= 0 && move[1] <= Globals.l_edge:
		var result = check_collision(key)
		var own_piece = result[1]
		if not own_piece:
			available_moves.append([move])

func horse_moves():
	for dir in Globals.directions:
		var x = current_pos[0] + (dir[0] * 2)
		var y = current_pos[1] + (dir[1] * 2)
		if dir[0] != 0:
			valid_move(str(x) + str(y + 1), Vector2(x, y + 1))
			valid_move(str(x) + str(y - 1), Vector2(x, y - 1))
		if dir[1] != 0:
			valid_move(str(x + 1) + str(y), Vector2(x + 1, y))
			valid_move(str(x - 1) + str(y), Vector2(x - 1, y))

func pawn_moves():
	var x = self.current_pos[0]
	var y = self.current_pos[1]
	valid_move(str(x) + str(y + alignment), Vector2(x, y + alignment))

func king_moves():
	for dir in Globals.directions:
		var x = current_pos[0] + dir[0]
		var y = current_pos[1] + dir[1]
		valid_move(str(x) + str(y), Vector2(x, y))
	for diag in Globals.diags:
		var x = current_pos[0] + diag[0]
		var y = current_pos[1] + diag[1]
		valid_move(str(x) + str(y), Vector2(x,y))

func possible_moves():
	print("Please implement this method for your piece. It should make use of current_pos and add to available_moves")

func init(pos: Vector2, alignment: int = 1):
	current_pos = pos
	self.alignment = alignment
	return self


# Called when the node enters the scene tree for the first time.
func _ready():
	self.board = self.get_parent()
	self.z_index = 1
	self.scale = Vector2(Globals.scale, Globals.scale)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
