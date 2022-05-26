module main

import util

fn simulate(data []string) (int, bool) {
	mut acc := 0
	mut seen := []int{}
	mut i := 0
	for i !in seen && i < data.len {
		seen << i
		line := data[i].split(' ')
		// println(line)
		if line[0] == 'acc' {
			acc += line[1].int()
			i++
		} else if line[0] == 'jmp' {
			i += line[1].int()
		} else {
			i++
		}
	}
	return acc, i == data.len
}

fn part1(data []string) {
	acc, _ := simulate(data)

	println('Answer to Part One : $acc')
}

fn part2(data []string) {
	mut tmp := data.clone()
	mut i := data.len - 1
	for i >= 0 {
		line := data[i].split(' ')
		if line[0] == 'jmp' {
			tmp[i] = 'nop $line[1]'
			acc, term := simulate(tmp)
			if term {
				println('Answer to Part Two : $acc')
			}
			tmp[i] = line.join(' ')
		} else if line[0] == 'nop' {
			tmp[i] = 'jmp $line[1]'
			acc, term := simulate(tmp)
			if term {
				println('Answer to Part Two : $acc')
			}
			tmp[i] = line.join(' ')
		}
		i--
	}
}

fn main() {
	data := util.read_file('Day08/input.txt')
	part1(data)
	part2(data)
}
