module main

import util

fn part1(data []int) {
	mut one, mut three := 0, 0
	mut prev := data[0]
	// A cause de la prise de départ
	one++
	for v in data[1..] {
		match v - prev {
			1 { one++ }
			3 { three++ }
			else {}
		}
		prev = v
	}
	println('Answer to Part One : ${one * three}')
}

struct Cache {
mut:
	values map[int]u64
}

fn count_ways(start int, data []int, mut cache Cache) u64 {
	if start in cache.values {
		return cache.values[start]
	}
	if data.len == 0 {
		cache.values[start] = 1
		return 1
	}
	mut count := u64(0)
	for i, v in data {
		if v > start + 3 {
			break
		}
		count += count_ways(v, data[i + 1..], mut cache)
	}
	cache.values[start] = count
	return count
}

fn part2(data []int) {
	mut cache := Cache{}
	c := count_ways(0, data, mut cache)
	println(cache)
	println('Answer to Part Two : $c')
}

fn main() {
	mut data := util.read_ints_from_file('Day10/input.txt')
	data.sort()
	data << data.last() + 3 // Device
	part1(data)
	part2(data)
}
