extends Node

const directions : Array = [Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1)]
const diags : Array = [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]

# Y is length
@export var board_length = 8
var l_edge = board_length - 1

# X is width
@export var board_width = 4
var w_edge = board_width - 1
@export var scale = 0.213

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
