// Copyright(C) 2021 Erdet Nasufi. All rights reserved.

module main

import vsp
import time
import math

enum BufferStatusFlag {
	has_data
	end_of_buffer
}

struct BufferStatus {
mut:
	buffer_status BufferStatusFlag
}

fn sig_generator(a f32, b f32, samples int) []f32 {
	mut sig := []f32{}
	mut sample := f32(0)

	for i in 1 .. samples {
		sample  = f32(a*math.sin(f32(i)*10*math.pi))
		sample += f32(b*math.sin(f32(i)*math.pi/3))
		sig << sample
	}
	return sig
}

fn write_routine(shared cb vsp.CircularBuffer, shared status BufferStatus, samples []f32) {
	mut wi := u32(0)
	mut i := u32(0)
	for sample in samples {
		lock cb {
			cb.write(sample)
			_, wi = cb.index()
		}
		println('<< write [wi: ${wi}]: ${sample} ')
		i++
		time.sleep(500*time.millisecond)
	}
	lock status {
		status.buffer_status = BufferStatusFlag.end_of_buffer
	}

}

fn read_routine(shared cb vsp.CircularBuffer, shared status BufferStatus) {
	mut val := f32(0)
	mut ri := u32(0)
	for {
		lock cb {
			val = cb.read()
			ri, _ = cb.index()
		}
		println('>> read: val(ri: ${ri}) = ${val}')
		time.sleep(500*time.millisecond)
		rlock status {
			if status.buffer_status == BufferStatusFlag.end_of_buffer {
				break
			}
		}
	}
}

fn main() {
	shared cb := vsp.new_circular_buffer(10)
	sig := sig_generator(2.1, 1.3, 100)
	shared status := BufferStatus{
		buffer_status: BufferStatusFlag.has_data
	}

	write_thread := go write_routine(shared cb, shared status, sig)
	read_thread  := go read_routine(shared cb, shared status)

	write_thread.wait()
	read_thread.wait()
	
	println('Done.')
}