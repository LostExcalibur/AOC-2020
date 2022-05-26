module main

import util

fn calc_id(seat string) int {
	mut min, mut max := 0, 127
	for c in seat[..7] {
		if c == `B` {
			min = (max + min + 1) / 2
		} else if c == `F` {
			max = (max + min) / 2
		}
	}
	row := min
	min, max = 0, 7
	for c in seat[7..] {
		if c == `R` {
			min = (max + min + 1) / 2
		} else if c == `L` {
			max = (max + min) / 2
		}
	}
	col := min
	id := row * 8 + col
	return id
}

fn part1(data []string) {
	mut highest := 0
	for line in data {
		id := calc_id(line)
		if id > highest {
			highest = id
		}
	}
	println('Answer to Part One : $highest')
}

fn part2(data []string) {
	mut found := []int{}
	for line in data {
		found << calc_id(line)
	}

	found.sort()

	for seat in found[0] .. found[found.len - 1] {
		if seat !in found && seat + 1 in found && seat - 1 in found {
			println('Answer to Part Two : $seat')
			return
		}
	}
}

fn main() {
	data := util.read_file('Day05/input.txt')
	part1(data)
	part2(data)
}
