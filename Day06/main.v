module main

import util

fn part1(data []string) {
	mut sum := 0
	mut answered := []u8{}
	for line in data {
		if line == '' {
			sum += answered.len
			answered.clear()
			continue
		}
		for c in line {
			if c !in answered {
				answered << c
			}
		}
	}
	sum += answered.len
	println('Answer to Part One : $sum')
}

fn part2(data []string) {
	mut sum := 0
	mut everyone := []u8{}
	mut new := true
	for line in data {
		if line == '' {
			sum += everyone.len
			everyone.clear()
			new = true
			continue
		}
		if new {
			everyone = line.bytes()
			new = false
		} else {
			mut tmp := []u8{}
			for c in everyone {
				if c in line.bytes() {
					tmp << c
				}
			}
			everyone = tmp.clone()
		}
	}
	sum += everyone.len
	println('Answer to Part Two : $sum')
}

fn main() {
	data := util.read_file('Day06/input.txt')
	part1(data)
	part2(data)
}
