class_name Utils

static func coord_to_key(x: int, y: int) -> String:
	return str(x) + "," + str(y)

static func key_to_coord(key: String) -> Vector2:
	var split_key := key.split(",", false)
	return Vector2(int(split_key[0]), int(split_key[1]))
