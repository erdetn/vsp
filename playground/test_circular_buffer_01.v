// Copyright(C) 2021 Erdet Nasufi. All rights reserved.

module main

import vsp
import time

fn write_routine(shared cb vsp.CircularBuffer) {
	mut wi := u32(0)
	for i in 1..50 {
		lock cb {
			cb.write(f32(i))
			_, wi = cb.index()
		}
		println('<< write [wi: ${wi}]: ${i}...')
		time.sleep(500*time.millisecond)
	}
}

fn read_routine(shared cb vsp.CircularBuffer) {
	mut val := f32(0)
	mut ri := u32(0)
	for i in 1..50 {
		lock cb {
			val = cb.read()
			ri, _ = cb.index()
		}
		println('>> read: val(ri: ${ri}) = ${val}')
		time.sleep(500*time.millisecond)
	}
}

fn main() {
	shared cb := vsp.new_circular_buffer(10)

	write_thread := go write_routine(shared cb)
	read_thread  := go read_routine(shared cb)

	write_thread.wait()
	read_thread.wait()
	
	println('Done.')
}