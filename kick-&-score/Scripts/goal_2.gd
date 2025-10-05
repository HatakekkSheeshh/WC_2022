extends Area2D
@export_enum("home", "away") var side := "away"

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("ball"):
		var side_idx :=  1
		%GameManager.goal(side_idx)
		
		print("GOAL for ", side, "! Score=", %GameManager.score)
