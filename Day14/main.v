module main

import util
import strconv
import time

enum MaskElement {
	set
	unchanged
	floating
}

fn part1(data []string) {
	mut mem := map[int]u64{}
	mut mask := ''
	for line in data {
		splitted := line.split(' = ')
		if splitted[0] == 'mask' {
			mask = splitted[1]
		} else {
			address := splitted[0][4..(splitted[0].len - 1)].int()
			value := strconv.parse_uint(splitted[1], 10, 36) or { panic(err) }
			// println(value)
			mem[address] = compute_value_with_mask(value, mask)
		}
	}
	mut sum := u64(0)
	for _, value in mem {
		sum += value
	}
	println('Answer to Part One : $sum')
}

fn part2(data []string) {
	mut mem := map[u64]u64{}
	mut mask := []MaskElement{len: 36, init: MaskElement.unchanged}
	mut splitted := []string{}
	for line in data {
		splitted = line.split(' = ')
		if splitted[0] == 'mask' {
			for i, c in splitted[1] {
				match c {
					`0` {
						mask[i] = .unchanged
					}
					`1` {
						mask[i] = .set
					}
					`X` {
						mask[i] = .floating
					}
					else {}
				}
			}
		} else {
			mut address := splitted[0][4..(splitted[0].len - 1)].int()
			value := strconv.parse_uint(splitted[1], 10, 36) or { panic(err) }
			compute_part_2(address, mask, value, mut mem)
		}
	}
	mut sum := u64(0)
	for _, value in mem {
		sum += value
	}
	println('Answer to Part Two : $sum')
}

fn compute_value_with_mask(value u64, mask string) u64 {
	mut arr := util.u64_to_bit_array(value, 36)
	for i, bit in mask {
		match bit {
			`0` {
				arr[i] = false
			}
			`1` {
				arr[i] = true
			}
			else {}
		}
	}
	return util.bit_array_to_u64(arr)
}

fn compute_part_2(_address int, mask []MaskElement, value u64, mut mem map[u64]u64) {
	mut addresses := []u64{}
	mut address := util.u64_to_bit_array(u64(_address), 36)
	mut floatings := []int{}
	for i, bit in mask {
		match bit {
			.set {
				address[i] = true
			}
			.unchanged {}
			.floating {
				floatings << i
			}
		}
	}
	compute_floating_addresses(mut addresses, address, floatings)

	for a in addresses {
		mem[a] = value
	}
}

fn compute_floating_addresses(mut addresses []u64, address []bool, indices []int) {
	mut add := address.clone()
	idx := indices[0]

	if indices.len == 1 {
		addresses << util.bit_array_to_u64(add)
		add[idx] = !add[idx]
		addresses << util.bit_array_to_u64(add)
		return
	}

	compute_floating_addresses(mut addresses, add, indices[1..])

	add[idx] = !add[idx]
	compute_floating_addresses(mut addresses, add, indices[1..])
}

fn main() {
	data := util.read_file('Day14/input.txt')

	mut sw := time.new_stopwatch()
	part1(data)
	println('Part One took: ${sw.elapsed().milliseconds()}ms')
	sw.restart()
	part2(data)
	println('Part Two took: ${sw.elapsed().milliseconds()}ms')
}
