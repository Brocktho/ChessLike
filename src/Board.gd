class_name Board
extends Node2D

signal noEnergy(force: bool)

@export var white: Color = Color("ANTIQUE_WHITE")  # Square color
@export var grey: Color = Color("DARK_SLATE_GRAY")  # Square color
@export var mod_color: Color = Color("YELLOW")  # For highlighting squares
@export var select_color: Color = Color("GREEN")

const center = Vector2(16, 16)

const tile = preload("res://src/Tile.tscn")
const horses = preload("res://src/Pieces/Knight.tscn")
const rooks = preload("res://src/Pieces/Rook.tscn")
const bishops = preload("res://src/Pieces/Bishop.tscn")
const queens = preload("res://src/Pieces/Queen.tscn")
const pawns = preload("res://src/Pieces/Pawn.tscn")
const kings = preload("res://src/Pieces/King.tscn")

var key_help = ["none", 0]

var grid = {}  # Map of what pieces are placed on the board

var rng = RandomNumberGenerator.new()

const horse = "Horse";
const queen = "Queen";
const pawn = "Pawn";
const king = "King";
const bishop = "Bishop";
const rook = "Rook";

var player_turn = -1
var max_energy = 5
var energy = 5

var initializing = true

var player_pieces: Dictionary = {}

var highlights: Array[Tile]

var selected_piece : Piece

var progress_tile: Tile
var progress_text: Label
var energy_UI: Label

const draw_order = [[horses, horse], [kings, king], [bishops, bishop], [rooks, rook],]

func rng_x():
	return rng.randi_range(0, Globals.w_edge)

func rng_y(back: int = 0, front: int = 3):
	return rng.randi_range(back, front)

func must_create(type: PackedScene, dict_key, back: int = 0, front: int = 3, alignment : int = 1):
	var success = false
	while not success: 
		var pos = Vector2(rng_x(), rng_y(back, front))	
		success = create_piece(type, dict_key, pos, alignment)

func place_player_pieces():
	for y in 2:
		for x in 4:
			var pos = Vector2(x, Globals.l_edge - y)
			if y == 0:
				var this_piece = draw_order[x]
				create_piece(this_piece[0], this_piece[1], pos, -1)
			else:
				create_piece(pawns, pawn, pos, -1)

func create_label(node: Node, text: String = "End Turn"):
	var label = Label.new()
	label.text = text
	label.position = Vector2(0, 0)
	node.add_child(label)
	return label

func init():
	draw_board()
	if initializing:
		var en = create_tile(Vector2(-4, 0), Color(Globals.clear), false)
		energy_UI = create_label(en, "Energy: " + str(energy))
		var t = create_tile(Vector2(Globals.board_width + 2, 0), Color("BLUE"), false)
		progress_text = create_label(t)
		t.interactable = true
		t.connect("pressed", handle_progress)
		progress_tile = t
	place_player_pieces()
	must_create(rooks, rook, 0, 1)
	must_create(bishops, bishop, 0, 1)
	must_create(horses, horse, 0, 1)
	must_create(kings, king, 0, 1)
	for p in 4:
		must_create(pawns, pawn, 1, 2)	

func respawn():
	grid = {}
	player_pieces = {}
	var children = get_children()
	for child in children:
		if child is Camera2D:
			pass
		else:
			destroy_node(child)
	init()

func destroy():
	player_pieces = {}
	var children = get_children()
	for child in children:
		if child is Tile:
			var x = child.current_pos[0]
			var y = child.current_pos[1]
			if (x > Globals.w_edge || y > Globals.l_edge || not child.interactable):
				destroy_node(child)

func reload(reverse: bool):
	if(reverse):
		Globals.board_length -= 1
		Globals.w_edge -= 1
		Globals.board_width -= 1
		Globals.l_edge -= 1
	else:
		Globals.board_length += 1
		Globals.w_edge += 1
		Globals.board_width += 1
		Globals.l_edge += 1
	destroy()
	draw_board()

# Called when the node enters the scene tree for the first time.
func _ready():
	init()
	pass
	
func clear_highlights():
	for highlight in highlights:
		destroy_node(highlight)
	highlights = []

func destroy_node(node: Node):
	remove_child(node)
	node.queue_free()

func update_energy(new_val):
	if new_val is Callable:
		energy = new_val.call(energy)
	else:
		energy = new_val
	energy_UI.text = "Energy: " + str(energy)
	if energy <= 0:
		noEnergy.emit()

func move_piece(piece: Piece, pos: Vector2, interaction: int = 0):
	clear_highlights()
	grid.erase(str(piece.current_pos[0]) + str(piece.current_pos[1]))
	grid[str(pos[0]) + str(pos[1])] = piece
	piece.move(pos, interaction)
	if interaction != 0:
		update_energy(func(x): return x - 1)

func add_player_piece(piece: Sprite2D, type: String):
	var prev_pieces = []
	if type in player_pieces:
		prev_pieces = player_pieces[type]
	
	prev_pieces.append(piece)
	player_pieces[type] = prev_pieces

func create_piece(type: PackedScene, dict_key: String, pos: Vector2 = Vector2(0,0), alignment : int = 1):
	var x = pos[0]
	var y = pos[1]
	if(str(x) + str(y) in grid):
		return false;
	var new_piece = type.instantiate().init(pos, alignment)
	move_piece(new_piece, new_piece.current_pos)
	self.connect("noEnergy", new_piece.exhaust)
	new_piece.connect("pressed", handle_piece_click)
	grid[str(x) + str(y)] = new_piece
	add_child(new_piece)
	if alignment != 1:
		add_player_piece(new_piece, dict_key)
	return true;

func draw_board():
	var odd = true
	for y in Globals.board_length:
		odd = ! odd
		for x in Globals.board_width:
			odd = ! odd
			if odd:
				create_tile(Vector2(x, y), white, false)
			else:
				create_tile(Vector2(x, y), grey, false)

func create_tile(pos: Vector2, color: Color, temp: bool):
	var t = tile.instantiate().init(pos, temp, temp)
	t.color = color
	add_child(t)
	if (temp):
		t.connect("pressed", handle_highlight_click)
		highlights.append(t)
	return t

func draw_moves(moves_array: Array, keyboard: bool, selected: Vector2):
	clear_highlights()
	if keyboard:
		create_tile(selected, select_color, true).disconnect("pressed", handle_highlight_click)
	for moves in moves_array:
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
	if type in player_pieces:
		var pieces = player_pieces[type]
		if(pieces.size() > 0):
			var next_piece = pieces[last_index % pieces.size()]
			if next_piece:
				handle_moves(next_piece)

func handle_moves(piece: Piece):
	selected_piece = piece
	piece.possible_moves()
	draw_moves(piece.available_moves, false, piece.current_pos)

func handle_piece_click(piece: Piece):
	if initializing:
		pass
	else: 
		handle_moves(piece)
	
func change_turn():
	player_turn *= -1

func handle_progress():
	if initializing:
		initializing = false
	change_turn()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_H:
			handle_key(horse, event.shift_pressed)
		if event.keycode == KEY_R:
			handle_key(rook, event.shift_pressed)
		if event.keycode == KEY_B:
			handle_key(bishop, event.shift_pressed)
		if event.keycode == KEY_Q:
			handle_key(queen, event.shift_pressed)
		if event.keycode == KEY_P:
			handle_key(pawn, event.shift_pressed)
		if event.keycode == KEY_K:
			handle_key(king, event.shift_pressed)
		if event.keycode == KEY_ENTER:
			reload(event.shift_pressed)
		if event.keycode == KEY_BACKSPACE:
			respawn()

func handle_highlight_click(pos: Vector2):
	var type = 1
	if initializing:
		type = 0
	if selected_piece:
		move_piece(selected_piece, pos, type)
