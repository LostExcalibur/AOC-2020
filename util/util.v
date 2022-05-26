module util

import os

pub fn read_file(path string) []string {
	lines := os.read_lines(path) or { panic(err) }
	return lines
}

pub fn read_ints_from_file(path string) []int {
	return read_file(path).map(it.int())
}
