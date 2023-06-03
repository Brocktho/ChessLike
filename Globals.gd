extends Node

const directions : Array = [Vector2(1,0),Vector2(0,1),Vector2(-1,0),Vector2(0,-1)]
const diags : Array = [Vector2(1,1), Vector2(1,-1), Vector2(-1,1), Vector2(-1,-1)]
const clear = "TRANSPARENT"

# Y is length
@export var board_length = 8
var l_edge = board_length - 1

# X is width
@export var board_width = 6
var w_edge = board_width - 1
@export var scale = 0.213


# Center a div (lol) 
# block.anchor_left = 0.5
# block.anchor_top = 0.5
# block.anchor_right = 0.5
# block.anchor_bottom = 0.5