extends Label
var score = 0
#@onready var teste = $"Map".get_children()

func _ready():
	self.text = "Score: %s" % score

func _process(delta):
	pass

func _on_player_point_added(value):
	score += value
	self.text = "Score: %s" % score
