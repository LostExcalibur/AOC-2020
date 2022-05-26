module main

import util

fn descend(forest []string, right int, down int) int {
	mut x, mut y := 0, 0
	mut count := 0
	l := forest[0].len
	for y < forest.len {
		if forest[y][x % l] == `#` {
			count++
		}
		x += right
		y += down
	}
	return count
}

fn part1(data []string) {
	count := descend(data, 3, 1)
	println('Answer to Part one : $count')
}

fn part2(data []string) {
	count := descend(data, 1, 1) * descend(data, 3, 1) * descend(data, 5, 1) * descend(data,
		7, 1) * descend(data, 1, 2)
	println('Answer to Part two : $count')
}

fn main() {
	data := util.read_file('Day03/input.txt')
	part1(data)
	part2(data)
}
