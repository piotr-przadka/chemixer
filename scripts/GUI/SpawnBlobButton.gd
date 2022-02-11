extends Button


func _ready():
	pass


func _on_SpawnBlobButton_pressed():
	$SpawnParticles.emitting = true


func _on_SpawnBlobButton_button_down():
	$BlobTimer.start()


func _on_BlobTimer_timeout():
	emit_signal("pressed")


func _on_SpawnBlobButton_button_up():
	$BlobTimer.stop()
