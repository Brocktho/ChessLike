class_name Bishop 
extends Piece

func possible_moves():
	available_moves = []
	if exhausted:
		return
	self.bishop_moves()
