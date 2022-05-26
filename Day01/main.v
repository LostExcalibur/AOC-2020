module main

import util

fn part1(data []int) {
	for i, v1 in data {
		for v2 in data[i + 1..] {
			if v1 + v2 == 2020 {
				println('Answer to Part One : ${v1 * v2}')
				return
			}
		}
	}
}

fn part2(data []int) {
	for i, v1 in data {
		for j, v2 in data[i + 1..] {
			for v3 in data[j + 1..] {
				if v1 + v2 + v3 == 2020 {
					println('Answer to Part Two : ${v1 * v2 * v3}')
					return
				}
			}
		}
	}
}

fn main() {
	data := util.read_ints_from_file('Day01/input.txt')
	part1(data)
	part2(data)
}
