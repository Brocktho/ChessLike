class_name Queen
extends Piece

func possible_moves():
	available_moves = []
	if exhausted:
		return
	self.rook_moves()
	self.bishop_moves()
	
