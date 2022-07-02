module main

import util
import time

fn part1(data []int) {
	result := simulate_for_n_turns(2020, data)
	println('Answer to Part One : $result')
}

fn part2(data []int) {
	result := simulate_for_n_turns(30000000, data)
	println('Answer to Part Two : $result')
}

fn simulate_for_n_turns(n int, start []int) int {
	mut ages := map[int]int{}
	mut latest := start.last()
	for i, num in start#[..-1] {
		ages[num] = i
	}
	mut num := 0
	mut i := start.len - 1
	for i < n - 1 {
		num = i - (ages[latest] or { i })
		ages[latest] = i
		latest = num
		i++
	}
	return latest
}

fn main() {
	data := util.read_file('Day15/input.txt')[0].split(',').map(it.int())

	mut sw := time.new_stopwatch()
	part1(data)
	println('Part One took: ${sw.elapsed().microseconds()}us')
	sw.restart()
	part2(data)
	// ~11s for non-optimized build, ~3.8s for optimized build
	println('Part Two took: ${sw.elapsed().milliseconds()}ms')
}
