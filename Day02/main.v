module main

import util

fn part1(data []string) {
	mut count := 0
	for line in data {
		processed := line.split_any(' :').filter(it != '')
		rule, chr, passwd := processed[0], processed[1], processed[2]
		sp_rule := rule.split('-')
		low, high := sp_rule[0].int(), sp_rule[1].int()

		if low <= passwd.count(chr) && passwd.count(chr) <= high {
			count += 1
		}
	}
	println('Answer to Part One : $count')
}

fn part2(data []string) {
	mut count := 0
	for line in data {
		processed := line.split_any(' :').filter(it != '')
		rule, chr, passwd := processed[0], processed[1][0], processed[2]
		sp_rule := rule.split('-')
		low, high := sp_rule[0].int() - 1, sp_rule[1].int() - 1

		if chr in [passwd[low], passwd[high]] && passwd[low] != passwd[high] {
			count += 1
		}
	}
	println('Answer to Part Two : $count')
}

fn main() {
	data := util.read_file('Day02/input.txt')
	part1(data)
	part2(data)
}
