module main

import util
import math

fn forward(x_ int, y_ int, distance int, angle int) (int, int) {
	mut x, mut y := x_, y_
	match angle {
		0 { x += distance }
		90 { y += distance }
		180 { x -= distance }
		270 { y -= distance }
		else {}
	}
	return x, y
}

fn rotate(x_ int, y_ int, angle int) (int, int) {
	if angle < 0 {
		return rotate(x_, y_, 360 + angle)
	}
	mut x, mut y := 0, 0
	match angle {
		90 {
			x, y = -y_, x_
		}
		180 {
			x, y = -x_, -y_
		}
		270 {
			x, y = y_, -x_
		}
		else {}
	}
	return x, y
}

fn part1(data []string) {
	mut x, mut y := 0, 0
	mut angle := 0
	for line in data {
		match line[0] {
			`F` {
				x, y = forward(x, y, line[1..].int(), angle)
			}
			`L` {
				angle = (angle + line[1..].int()) % 360
			}
			`R` {
				angle = util.mod(angle - line[1..].int(), 360)
			}
			`N` {
				y += line[1..].int()
			}
			`S` {
				y -= line[1..].int()
			}
			`E` {
				x += line[1..].int()
			}
			`W` {
				x -= line[1..].int()
			}
			else {}
		}
	}
	distance := math.abs(x) + math.abs(y)
	println('Answer to Part One : $distance')
}

fn part2(data []string) {
	mut ship_x, mut ship_y := 0, 0
	mut way_x, mut way_y := 10, 1
	for line in data {
		value := line[1..].int()
		match line[0] {
			`F` {
				ship_x += way_x * value
				ship_y += way_y * value
			}
			`L` {
				way_x, way_y = rotate(way_x, way_y, value)
			}
			`R` {
				way_x, way_y = rotate(way_x, way_y, -value)
			}
			`N` {
				way_y += line[1..].int()
			}
			`S` {
				way_y -= line[1..].int()
			}
			`E` {
				way_x += line[1..].int()
			}
			`W` {
				way_x -= line[1..].int()
			}
			else {}
		}
		// println('$ship_x, $ship_y  :  $way_x, $way_y')
	}
	distance := math.abs(ship_x) + math.abs(ship_y)
	println('Answer to Part Two : $distance')
}

fn main() {
	data := util.read_file('Day12/input.txt')
	part1(data)
	part2(data)
}
