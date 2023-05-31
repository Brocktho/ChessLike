class_name Board
extends Node2D

@export var white: Color = Color("ANTIQUE_WHITE")  # Square color
@export var grey: Color = Color("DARK_SLATE_GRAY")  # Square color
@export var mod_color: Color = Color("YELLOW")  # For highlighting squares
@export var select_color: Color = Color("GREEN")

const center = Vector2(16, 16)

const tile = preload("res://src/Tile.tscn")
const knight = preload("res://src/Pieces/Knight.tscn")

enum {SIDE, UNDER}

var key_help = ["none", 0]

var grid: Dictionary = {}  # Map of what pieces are placed on the board

const horse = "Horse";
const queen = "Queen";
const pawn = "Pawn";
const king = "King";
const bishop = "Bishop";
const rook = "Rook";

var player_pieces: Dictionary = {
	horse: [],
	queen: [],
	pawn: [],
	king: [],
	bishop: [],
	rook: []
}

var highlights: Array

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_board()
	for y in 8:
		for x in 8:
			create_knight(Vector2(x, y))
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func move_piece(piece: Sprite2D, pos: Vector2):
	piece.position = Vector2(pos[0] * 32 + center[0], pos[1] * 32 + center[1])

func add_player_piece(piece: Sprite2D, type):
	var prev_pieces = player_pieces[type]
	prev_pieces.append(piece)
	player_pieces[type] = prev_pieces

func create_knight(pos: Vector2 = Vector2(0, 0)):
	var new_knight = knight.instantiate()
	new_knight.init(pos)
	move_piece(new_knight, new_knight.current_pos)
	self.add_child(new_knight)
	add_player_piece(new_knight, horse)
	#print(player_pieces)

func draw_board():
	var odd = true
	for y in 8:
		odd = ! odd
		for x in 8:
			odd = ! odd
			if odd:
				create_tile(Vector2(x, y), white, false)
			else:
				create_tile(Vector2(x, y), grey, false)

func create_tile(pos: Vector2, color: Color, temp: bool):
	var t = tile.instantiate()
	t.position = Vector2(pos[0] * 32, pos[1] * 32)
	t.color = color
	self.add_child(t)
	if (temp):
		highlights.append(t)

func draw_moves(moves: Array, keyboard: bool, selected: Vector2):
	for highlight in highlights:
		self.remove_child(highlight)
	highlights = []
	if keyboard:
		create_tile(selected, select_color, true)
	for move in moves:
		if move is Vector2:
			create_tile(move, mod_color, true)

func handle_key(type, reverse: bool):
	var last_type = key_help[0]
	var last_index = 0;
	if last_type == type:
		last_index = key_help[1]
		if reverse:
			last_index -= 1
		else:
			last_index += 1
	key_help = [type, last_index]
	var pieces = player_pieces[type]
	var next_piece = pieces[last_index % pieces.size()]
	if next_piece:
		next_piece.possible_moves()
		draw_moves(next_piece.available_moves, true, next_piece.current_pos)

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			handle_key(horse, event.shift_pressed)
			pass
''' 		if event.keycode == KEY_S:
			space_bot_chars(-1)
		if event.keycode == KEY_W:
			space_bot_chars(1)
		if event.keycode == KEY_A:
			space_side_chars(-1)
		if event.keycode == KEY_D:
			space_side_chars(1)
		if event.keycode == KEY_T:
			translate_side_chars(1)
		if event.keycode == KEY_G:
			translate_side_chars(-1);
		if event.keycode == KEY_O:
			translate_bot_chars(1);
		if event.keycode == KEY_L:
			translate_bot_chars(-1)
		if event.keycode == KEY_0:
			add_square_to_board()
		if event.keycode == KEY_C:
			move_recent_square(1, 1)'''
