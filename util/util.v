module util

import os

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
