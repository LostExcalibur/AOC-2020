module main

import util
import arrays
import time

const (
	occupied = u8(`#`)
	empty    = u8(`L`)
)

fn neighbours_all_dirs(x int, y int, data [][]u8) []u8 {
	mut neigh := []u8{}
	mut i, mut j := 1, 1
	// unoptimized as shit
	for util.is_in_bounds(x + i, y + j, data) {
		if data[y + j][x + i] != u8(`.`) {
			neigh << data[y + j][x + i]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x + i, y - j, data) {
		if data[y - j][x + i] != u8(`.`) {
			neigh << data[y - j][x + i]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x - i, y + j, data) {
		if data[y + j][x - i] != u8(`.`) {
			neigh << data[y + j][x - i]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x - i, y - j, data) {
		if data[y - j][x - i] != u8(`.`) {
			neigh << data[y - j][x - i]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x + i, y, data) {
		if data[y][x + i] != u8(`.`) {
			neigh << data[y][x + i]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x - i, y, data) {
		if data[y][x - i] != u8(`.`) {
			neigh << data[y][x - i]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x, y + j, data) {
		if data[y + j][x] != u8(`.`) {
			neigh << data[y + j][x]
			break
		}
		i++
		j++
	}
	i, j = 1, 1
	for util.is_in_bounds(x, y - j, data) {
		if data[y - j][x] != u8(`.`) {
			neigh << data[y - j][x]
			break
		}
		i++
		j++
	}
	return neigh
}

fn iter(data [][]u8, mut buffer [][]u8, part1 bool, max_occupied int) {
	for y := 0; y < data.len; y++ {
		for x := 0; x < data[0].len; x++ {
			neighbours := if part1 {
				util.neighbours(x, y, data)
			} else {
				neighbours_all_dirs(x, y, data)
			}
			match data[y][x] {
				occupied {
					if util.count_in_array(occupied, neighbours) >= max_occupied {
						buffer[y][x] = empty
					}
				}
				empty {
					if !neighbours.any(it == occupied) {
						buffer[y][x] = occupied
					}
				}
				else {}
			}
		}
	}
}

fn part1(data_ [][]u8) {
	mut data := data_.clone()
	mut buffer := data.clone()
	iter(data, mut buffer, true, 4)
	for {
		if buffer == data {
			break
		}
		data = buffer.clone()
		iter(data, mut buffer, true, 4)
	}

	count := util.count_in_array(occupied, arrays.flatten(data))

	println('Answer to Part One : $count')
}

fn part2(data_ [][]u8) {
	mut data := data_.clone()
	mut buffer := data.clone()
	iter(data, mut buffer, false, 5)

	for {
		if buffer == data {
			break
		}
		data = buffer.clone()
		iter(data, mut buffer, false, 5)
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
