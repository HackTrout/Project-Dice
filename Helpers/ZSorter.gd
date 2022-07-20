extends Node


var anchorPos : Vector2 = Vector2.ZERO		# Global position where all z values are based off of
var zRange : int = 640


func sort_position(pos : Vector2, height : float = 0.0) -> int:
	return int(((pos.y - anchorPos.y) + height) / zRange)
