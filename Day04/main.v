module main

import util

fn part1(data_ []string) {
	required := ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

	mut data := unsafe { data_ }
	mut count := 0
	mut pass, mut fields := '', []string{}
	for data.len > 0 {
		mut next := 0
		for i in 0 .. data.len {
			if data[i] == '' {
				next = i
				break
			}
		}
		pass = data[..next].join(' ')
		data = data[next + 1..]

		fields = pass.split(' ').map(it.split(':')[0])
		mut valid := true
		for field in required {
			if field !in fields {
				valid = false
			}
		}
		count += if valid { 1 } else { 0 }
	}
	println('Answer to Part one : $count')
}

fn part2(data_ []string) {
	required := ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid']

	mut data := unsafe { data_ }
	mut count := 0
	mut pass := ''
	for data.len > 0 {
		mut next := 0
		for i in 0 .. data.len {
			if data[i] == '' {
				next = i
				break
			}
		}
		pass = data[..next].join(' ')
		data = data[next + 1..]

		fields := pass.split(' ').map(it.split(':'))
		mut valid := true
		for field in required {
			if field !in fields.map(it[0]) {
				valid = false
				break
			}
		}
		if !valid {
			continue
		}
		for field in fields {
			value := field[1]
			match field[0] {
				'byr' {
					if value.len != 4 || value.int() < 1920 || value.int() > 2002 {
						valid = false
						break
					}
				}
				'iyr' {
					if value.len != 4 || value.int() < 2010 || value.int() > 2020 {
						valid = false
						break
					}
				}
				'eyr' {
					if value.len != 4 || value.int() < 2020 || value.int() > 2030 {
						valid = false
						break
					}
				}
				'hgt' {
					match value#[-2..] {
						'cm' {
							if value#[..-2].int() < 150 || value#[..-2].int() > 193 {
								valid = false
								break
							}
						}
						'in' {
							if value#[..-2].int() < 59 || value#[..-2].int() > 76 {
								valid = false
								break
							}
						}
						else {
							valid = false
							break
						}
					}
				}
				'hcl' {
					if value[0].ascii_str() != '#' || value[1..].bytes().any(!it.is_alnum()
						|| it.is_capital()) {
						valid = false
						break
					}
				}
				'ecl' {
					if value !in ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'] {
						valid = false
						break
					}
				}
				'pid' {
					if value.len != 9 || value.bytes().any(!it.is_digit()) {
						valid = false
						break
					}
				}
				'cid' {}
				else {
					valid = false
					break
				}
			}
		}
		if !valid {
			continue
		}
		count++
	}
	println('Answer to Part two : $count')
}

fn main() {
	data := util.read_file('Day4/input.txt')
	part1(data)
	part2(data)
}
