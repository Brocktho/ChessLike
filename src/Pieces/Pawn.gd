class_name Pawn
extends Piece

func possible_moves():
	available_moves = []
	if exhausted:
		return
	self.pawn_moves()
