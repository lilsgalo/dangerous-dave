extends RigidBody2D
signal coin_collected

func _process(delta):
	pass

func _on_coin_area_2d_body_entered(body):
	#print("entrou")
	self.queue_free()
	emit_signal("coin_collected")
