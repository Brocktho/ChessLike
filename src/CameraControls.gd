extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _input(event):
	if event.is_action_pressed("ui_right"):
		self.translate(Vector2(15.0, 0.0))
	if event.is_action_pressed("ui_left"):
		self.translate(Vector2(-15.0, 0.0))
	if event.is_action_pressed("ui_up"):
		self.translate(Vector2(0.0, -15.0))
	if event.is_action_pressed("ui_down"):
		self.translate(Vector2(0.0, 15.0))
