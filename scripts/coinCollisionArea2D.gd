extends Area2D

func _ready():
	connect("body_entered", _on_coin_body_entered)

func _on_coin_body_entered(body):
	var coin = self.find_parent("Coin")
	coin.visible = !coin.visible
