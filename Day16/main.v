module main

import arrays
import datatypes
import util
import time

struct Range {
	low  int
	high int
}

fn part1(data string) [][]int {
	_, ranges, _, other_tickets := prepare_data(data)
	mut valid := [][]int{cap: other_tickets.len, init: []int{}}
	invalid_fields := arrays.flatten(other_tickets).filter(!is_field_valid_for_any(it,
		ranges))

	for ticket in other_tickets {
		if !ticket.any(it in invalid_fields) {
			valid << ticket
		}
	}

	error_rate := util.add_array<int>(invalid_fields)

	println('Answer to Part One : $error_rate')
	return valid
}

struct Field {
	index     int
	possibles []int
}

fn part2(data string, pseudo_valid [][]int) {
	ranges_names, ranges, my_ticket, _ := prepare_data(data)
	n := my_ticket.len

	mut fields := [my_ticket]
	fields << pseudo_valid

	mut pris := []int{cap: n}

	mut final := []Field{cap: n}
	mut buffer := datatypes.new_ringbuffer<Field>(n)
	for i in 0 .. n {
		buffer.push(Field{ index: i, possibles: []int{len: n, init: it} }) or {
			panic("shouldn't happen")
		}
	}

	for !buffer.is_empty() {
		current := buffer.pop() or { panic('Pas normal...') }
		mut nv_possibles := []int{}
		range: for i in current.possibles {
			for field in fields {
				if !check_two_ranges(field[current.index], ranges[i]) {
					// println('malaise: ${field[current.index]}, ${ranges[i]}')
					continue range
				}
			}
			// println('On ajoute $i')
			nv_possibles << i
		}
		nv_possibles = nv_possibles.filter(it !in pris)
		nouveau := Field{
			index: current.index
			possibles: nv_possibles.clone()
		}
		if nv_possibles.len == 1 {
			final << nouveau
			pris << nv_possibles[0]
		} else {
			buffer.push(nouveau) or { panic('Pas normal') }
		}

		// _ := os.input('Prochaine itération ')
	}

	mut res := u64(1)
	for f in final {
		if ranges_names[f.possibles[0]].starts_with('departure') {
			res *= u64(my_ticket[f.index])
		}
	}

	println('Answer to Part Two : $res')
}

fn prepare_data(data string) ([]string, [][]Range, []int, [][]int) {
	separated := data.split('\n\n')
	fields := separated[0].split('\n').map(it.split(' '))
	ranges_raw := fields.map([it[it.len - 1], it[it.len - 3]])
	ranges_names := fields.map(it[0])
	ranges := ranges_raw.map(it.map(it.split('-')).map(Range{ low: it[0].int(), high: it[1].int() }))

	ticket := separated[1].split('\n')[1].split(',').map(it.int())

	other_tickets := separated[2].split('\n')[1..].map(it.split(',').map(it.int()))

	return ranges_names, ranges, ticket, other_tickets
}

fn is_in_range(n int, range &Range) bool {
	return n >= range.low && n <= range.high
}

fn is_field_valid_for_any(field int, ranges [][]Range) bool {
	return ranges.any(is_in_range(field, it[0]) || is_in_range(field, it[1]))
}

fn is_invalid_ticket(ticket []int, ranges [][]Range) bool {
	return ticket.any(!is_field_valid_for_any(it, ranges))
}

fn check_two_ranges(field int, ranges []Range) bool {
	return is_in_range(field, ranges[0]) || is_in_range(field, ranges[1])
}

fn main() {
	data := util.read_raw_file('Day16/input.txt')

	mut sw := time.new_stopwatch()
	pseudo_valid_tickets := part1(data)
	println('Part One took: ${sw.elapsed().milliseconds()}ms')
	sw.restart()
	part2(data, pseudo_valid_tickets)
	println('Part Two took: ${sw.elapsed().milliseconds()}ms')
}
