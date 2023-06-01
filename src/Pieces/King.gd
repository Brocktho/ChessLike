class_name King 
extends Piece


func possible_moves():
	available_moves = []
	if exhausted:
		return
	self.king_moves()
