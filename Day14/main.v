module main

import util
import strconv
import arrays

enum MaskElement {
	set
	unchanged
	floating
}

fn part1(data []string) {
	mut mem := []u64{len: 100_000, init: u64(0)}
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
	sum := arrays.sum(mem) or { panic(err) }
	println('Answer to Part One : $sum')
}

fn part2(data []string) {
	mut mem := map[u64]u64{}
	mut mask := []MaskElement{len: 36, init: MaskElement.unchanged}
	for line in data {
		splitted := line.split(' = ')
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
	// println(mem)
	mut sum := u64(0) // arrays.sum(mem) or { panic(err) }
	for _, value in mem {
		sum += value
	}
	println('Answer to Part Two : $sum')
}

fn u64_to_bit_array(n u64) []bool {
	mut result := []bool{len: 36, init: false}
	for i in 0 .. 36 {
		if n & (u64(1) << i) != 0 {
			result[35 - i] = true
		}
	}
	return result
}

fn bit_array_to_u64(arr []bool) u64 {
	mut result := u64(0)
	for i, v in arr {
		if v {
			result += (u64(1) << (35 - i))
		}
	}
	return result
}

fn compute_value_with_mask(value u64, mask string) u64 {
	mut arr := u64_to_bit_array(value)
	for i in 0 .. mask.len {
		match mask[i] {
			`0` {
				arr[i] = false
			}
			`1` {
				arr[i] = true
			}
			else {}
		}
	}
	return bit_array_to_u64(arr)
}

fn compute_part_2(_address int, mask []MaskElement, value u64, mut mem map[u64]u64) {
	mut addresses := []u64{}
	mut address := u64_to_bit_array(u64(_address))
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
		addresses << bit_array_to_u64(add)
		add[idx] = !add[idx]
		addresses << bit_array_to_u64(add)
		return
	}

	compute_floating_addresses(mut addresses, add, indices[1..])

	add[idx] = !add[idx]
	compute_floating_addresses(mut addresses, add, indices[1..])
}

fn main() {
	data := util.read_file('Day14/input.txt')

	part1(data)
	part2(data)
}
