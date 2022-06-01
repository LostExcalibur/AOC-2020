module main

import util
import math
import math.big

fn lcm(a big.Integer, b big.Integer) big.Integer {
	return a * b / a.gcd(b)
}

struct Ts {
	id   int
	wait int
}

struct Ts2 {
	id    big.Integer
	index big.Integer
}

const (
	zero = big.integer_from_int(0)
)

fn part1(data []string) {
	timestamp := data[0].int()
	ids := data[1].split(',').filter(it != 'x').map(it.int())
	mut t := []Ts{len: ids.len, init: Ts{
		id: ids[it]
		wait: ids[it] - (timestamp % ids[it])
	}}
	t.sort(a.wait < b.wait)
	first_bus := t[0]
	answer := first_bus.id * first_bus.wait
	println('Answer to Part One : $answer')
}

fn part2(data []string) {
	mut ids := []Ts2{}
	for i, v in data[1].split(',') {
		if v != 'x' {
			ids << Ts2{
				id: big.integer_from_int(v.int())
				index: big.integer_from_int(i)
			}
		}
	}

	ids.sort(a.index < b.index)

	mut step := ids[0].id
	mut timestamp := big.integer_from_int(100000000000002)
	mut answer := zero
	mut valid := true
	mut start := 1
	for {
		timestamp += step
		valid = true
		for t in ids[start..] {
			if (timestamp + t.index) % t.id != zero {
				valid = false
				break
			} else {
				step = lcm(t.id, step)
				start++
			}
		}
		if valid {
			answer = timestamp
			break
		}
	}

	println('Answer to Part Two : $answer')
}

fn main() {
	data := util.read_file('Day13/input.txt')
	part1(data)
	part2(data)
}
