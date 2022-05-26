module main

import util

type Rule_type = map[string][]map[string]int

fn extract_rules_no_numbers(lines []string) map[string][]string {
	mut rules := map[string][]string{}
	for line in lines {
		splitted := line.split('contain')
		container := splitted[0].split(' ')
		rule := '${container[0]} ${container[1]}'

		contained := splitted[1].split(', ')
		inside := contained.map(fn (x string) string {
			return x[2..].trim(' .').split(' ')[..2].join(' ')
		})
		rules[rule] = inside
	}
	return rules
}

fn extract_rules_with_numbers(lines []string) Rule_type {
	mut rules := map[string][]map[string]int{}
	for line in lines {
		splitted := line.split('contain')
		container := splitted[0].split(' ')
		rule := '${container[0]} ${container[1]}'

		contained := splitted[1].split(', ')
		inside := contained.map(fn (x string) map[string]int {
			val := x.trim(' .').split(' ')#[..-1]
			return {
				val[1..].join(' '): val[0].int()
			}
		})
		rules[rule] = inside
	}
	return rules
}

fn part1(data []string) {
	rules := extract_rules_no_numbers(data)
	mut to_explore := ['shiny gold']
	mut valid := []string{}
	mut explored := []string{}

	for to_explore.len > 0 {
		color := to_explore.pop()
		if color in explored {
			continue
		}
		valid << color
		for k, v in rules {
			if color in v {
				to_explore << k
			}
		}
		explored << color
	}
	println('Answer to Part One : ${valid.len - 1}')
}

fn count(color string, rules &Rule_type) int {
	mut c := 0
	for rule in (*rules)[color] {
		for k, v in rule {
			c += v * count(k, rules)
		}
	}
	return c + 1
}

fn part2(data []string) {
	rules := extract_rules_with_numbers(data)
	c := count('shiny gold', &rules)
	println('Answer to Part Two : ${c - 1}')
}

fn main() {
	data := util.read_file('Day7/input.txt')
	part1(data)
	part2(data)
}
