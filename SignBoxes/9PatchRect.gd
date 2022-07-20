tool
extends ReferenceRect


export(Texture) var custom_texture


func _process(delta):
	update()
	
	#Reposition
	set_position(-(rect_size / 2.0))


func _draw() -> void:
	#Draw 9 Patch
	
	var w = 32
	var px = 0
	var py = 0
	var sx = rect_size.x - w
	var sy = rect_size.y - w
	
	#Center
	draw_texture_rect_region(custom_texture, Rect2(Vector2(w, w), Vector2(sx - w, sy - w)), Rect2(Vector2(16, 16), Vector2(16, 16)))
	
	#Sides
	
	#Top
	draw_texture_rect_region(custom_texture, Rect2(Vector2(w, py), Vector2(sx - w, w)), Rect2(Vector2(16, 0), Vector2(16, 16)))
	#Bottom
	draw_texture_rect_region(custom_texture, Rect2(Vector2(w, sy), Vector2(sx - w, w)), Rect2(Vector2(16, 32), Vector2(16, 16)))
	#Left
	draw_texture_rect_region(custom_texture, Rect2(Vector2(px, w), Vector2(w, sy - w)), Rect2(Vector2(0, 16), Vector2(16, 16)))
	#Right
	draw_texture_rect_region(custom_texture, Rect2(Vector2(sx, w), Vector2(w, sy - w)), Rect2(Vector2(32, 16), Vector2(16, 16)))
	
	#Corners
	
	#Top Left
	draw_texture_rect_region(custom_texture, Rect2(Vector2(px, py), Vector2(w, w)), Rect2(Vector2(0, 0), Vector2(16, 16)))
	#Top Right
	draw_texture_rect_region(custom_texture, Rect2(Vector2(sx, py), Vector2(w, w)), Rect2(Vector2(32, 0), Vector2(16, 16)))
	#Bottom Left
	draw_texture_rect_region(custom_texture, Rect2(Vector2(px, sy), Vector2(w, w)), Rect2(Vector2(0, 32), Vector2(16, 16)))
	#Bottom Right
	draw_texture_rect_region(custom_texture, Rect2(Vector2(sx, sy), Vector2(w, w)), Rect2(Vector2(32, 32), Vector2(16, 16)))
	
