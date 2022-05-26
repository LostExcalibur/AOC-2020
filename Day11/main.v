module main

import util
import arrays
import time

const (
	occupied = u8(`#`)
	empty    = u8(`L`)
)

fn neighbours_all_dirs(x int, y int, data [][]u8) []u8 {
	// Preallocating neighbours goes from ~850ms to ~640
	mut neigh := []u8{cap: 8}
	mut up, mut left, mut down, mut right, mut up_left, mut left_down, mut down_right, mut right_up := true, true, true, true, true, true, true, true
	mut i, mut j := 1, 1
	// unoptimized as shit
	for (true in [up, left, down, right, up_left, left_down, down_right, right_up]) {
		if down_right {
			if !util.is_in_bounds(x + i, y + j, data) {
				down_right = false
			} else if data[y + j][x + i] != u8(`.`) {
				neigh << data[y + j][x + i]
				down_right = false
			}
		}
		if right_up {
			if !util.is_in_bounds(x + i, y - j, data) {
				right_up = false
			} else if data[y - j][x + i] != u8(`.`) {
				neigh << data[y - j][x + i]
				right_up = false
			}
		}
		if left_down {
			if !util.is_in_bounds(x - i, y + j, data) {
				left_down = false
			} else if data[y + j][x - i] != u8(`.`) {
				neigh << data[y + j][x - i]
				left_down = false
			}
		}
		if up_left {
			if !util.is_in_bounds(x - i, y - j, data) {
				up_left = false
			} else if data[y - j][x - i] != u8(`.`) {
				neigh << data[y - j][x - i]
				up_left = false
			}
		}
		if right {
			if !util.is_in_bounds(x + i, y, data) {
				right = false
			} else if data[y][x + i] != u8(`.`) {
				neigh << data[y][x + i]
				right = false
			}
		}
		if left {
			if !util.is_in_bounds(x - i, y, data) {
				left = false
			} else if data[y][x - i] != u8(`.`) {
				neigh << data[y][x - i]
				left = false
			}
		}
		if down {
			if !util.is_in_bounds(x, y + j, data) {
				down = false
			} else if data[y + j][x] != u8(`.`) {
				neigh << data[y + j][x]
				down = false
			}
		}
		if up {
			if !util.is_in_bounds(x, y - j, data) {
				up = false
			} else if data[y - j][x] != u8(`.`) {
				neigh << data[y - j][x]
				up = false
			}
		}
		i++
		j++
	}
	return neigh
}

fn iter(data [][]u8, mut buffer [][]u8, neighbour_fn &fn (int, int, [][]u8) []u8, max_occupied int) bool {
	mut changed := false
	mut neighbours := []u8{cap: 8}
	for y := 0; y < data.len; y++ {
		for x := 0; x < data[0].len; x++ {
			neighbours = neighbour_fn(x, y, data)
			match data[y][x] {
				occupied {
					if util.count_in_array(occupied, neighbours) >= max_occupied {
						buffer[y][x] = empty
						changed = true
					}
				}
				empty {
					if !neighbours.any(it == occupied) {
						buffer[y][x] = occupied
						changed = true
					}
				}
				else {}
			}
		}
	}
	return changed
}

fn neighbours_part_one(x int, y int, data [][]u8) []u8 {
	return util.neighbours(x, y, data)
}

fn part1(data_ [][]u8) {
	mut data := data_.clone()
	mut buffer := data.clone()
	mut changed := iter(data, mut buffer, neighbours_part_one, 4)
	for changed {
		data = buffer.clone()
		changed = iter(data, mut buffer, neighbours_part_one, 4)
	}

	count := util.count_in_array(occupied, arrays.flatten(data))

	println('Answer to Part One : $count')
}

fn part2(data_ [][]u8) {
	mut data := data_.clone()
	mut buffer := data.clone()
	mut changed := iter(data, mut buffer, neighbours_all_dirs, 5)

	for changed {
		data = buffer.clone()
		changed = iter(data, mut buffer, neighbours_all_dirs, 5)
	}

	count := util.count_in_array(occupied, arrays.flatten(data))
	println('Answer to Part Two : $count')
}

fn main() {
	data := util.read_char_2d_array_from_file('Day11/input.txt')
	mut sw := time.new_stopwatch()
	part1(data)
	println('Part One took: ${sw.elapsed().milliseconds()}ms')
	sw.restart()
	part2(data)
	println('Part Two took: ${sw.elapsed().milliseconds()}ms')
}
