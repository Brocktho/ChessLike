class_name Rook
extends Piece

func possible_moves():
	available_moves = []
	if exhausted:
		return
	self.rook_moves()
