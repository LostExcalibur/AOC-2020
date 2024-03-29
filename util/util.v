module util

import arrays
import os

pub fn add_array<T>(arr []T) T {
	return arrays.reduce(arr, fn <T>(x T, y T) T {
		return x + y
	}) or { T(0) }
}

pub fn u64_to_bit_array(n u64, n_bits int) []bool {
	mut result := []bool{len: n_bits, init: false}
	for i in 0 .. n_bits {
		if n & (u64(1) << i) != 0 {
			result[n_bits - 1 - i] = true
		}
	}
	return result
}

pub fn bit_array_to_u64(arr []bool) u64 {
	mut result := u64(0)
	for i, v in arr {
		if v {
			result += (u64(1) << (arr.len - 1 - i))
		}
	}
	return result
}

// No negative numbers returned
[inline]
pub fn mod(x int, y int) int {
	return (x + y) % y
}

[inline]
pub fn is_in_bounds<T>(i int, j int, array [][]T) bool {
	return (i >= 0) && (j >= 0) && (i < array[0].len) && (j < array.len)
}

pub fn neighbours<T>(x int, y int, array [][]T) []T {
	// Preallocating speeds up, as you can only have 8 neighbours
	mut neigh := []T{cap: 8}

	for j := -1; j <= 1; j++ {
		for i := -1; i <= 1; i++ {
			if is_in_bounds(x + i, y + j, array) && (i != 0 || j != 0) {
				neigh << array[y + j][x + i]
			}
		}
	}
	return neigh
}

[inline]
pub fn count_in_array<T>(value T, array []T) int {
	mut count := 0
	for v in array {
		if v == value {
			count++
		}
	}
	return count
}

pub fn read_raw_file(path string) string {
	return os.read_file(path) or { panic(err) }
}

pub fn read_file(path string) []string {
	lines := os.read_lines(path) or { panic(err) }
	return lines
}

pub fn read_ints_from_file(path string) []int {
	return read_file(path).map(it.int())
}

pub fn read_char_2d_array_from_file(path string) [][]u8 {
	return read_file(path).map(it.bytes())
}
