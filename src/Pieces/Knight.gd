class_name Knight
extends Piece


func possible_moves():
	available_moves = [];
	if exhausted:
		return
	self.horse_moves()
