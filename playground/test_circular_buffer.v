// Copyright(C) 2021 Erdet Nasufi. All rights reserved.

module main

import vsp

fn main() {
	mut cb := vsp.new_circular_buffer(5)

	cb.write(f32(9.0))
	cb.write(f32(8.0))
	cb.write(f32(7.0))
	cb.write(f32(6.0))
	cb.write(f32(5.0))

	println(cb.str())

	mut val := cb.read()
	println('${val}')
	val = cb.read()
	println('${val}')
	val = cb.read()
	println('${val}')
	val = cb.read()
	println('${val}')
	val = cb.read()
	println('${val}')
	val = cb.read()
	println('${val}')
	val = cb.read()
	println('${val}')

	println(cb.str())
	cb.clear()
	println(cb.str())

	println('length: ${cb.length()}')
}