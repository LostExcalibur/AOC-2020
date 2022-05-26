module main

import util
import arrays

fn is_sum_from(x int, list []int) bool {
	for i in list {
		if x - i in list {
			return true
		}
	}
	return false
}

fn find_sum_index(x int, data []int) (int, int) {
	for i, n in data {
		mut s := n
		for j, k in data[i + 1..] {
			if s + k > x {
				break
			}
			s += k
			if s == x {
				return i, i + j
			}
		}
	}
	panic('No valid contiguous sum found')
}

fn part1(data []int) {
	for i, x in data[25..] {
		if !is_sum_from(x, data[i..25 + i]) {
			println('Answer to Part One : $x')
			break
		}
	}
}

fn part2(data []int) {
	// Hard coded answer from part one
	j, k := find_sum_index(373803594, data)
	ans := arrays.max(data[j..k + 1]) or { 0 } + arrays.min(data[j..k + 1]) or { 0 }
	println('Answer to Part Two : $ans')
}

fn main() {
	data := util.read_ints_from_file('Day09/input.txt')
	part1(data)
	part2(data)
}
