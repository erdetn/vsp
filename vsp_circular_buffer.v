// Copyright(C) 2021 Erdet Nasufi. All rights reserved.

module vsp

pub struct CircularBuffer {
mut:
	buffer      []f32
	write_index   u32
	read_index    u32
	last_read     f32
}

pub fn new_circular_buffer(capacity int) CircularBuffer {
	return CircularBuffer {
		buffer:       []f32{init: f32(0.0), cap: capacity, len: capacity},
		write_index:    u32(0),
		read_index:     u32(0),
		last_read:      f32(0.0)
	}
}

pub fn (this CircularBuffer)length() u32 {
	return u32(this.buffer.len)
}

pub fn (mut this CircularBuffer)read() f32 {
	if this.read_index >= this.write_index {
		return this.last_read
	}

	if this.read_index == this.buffer.cap {
		this.read_index = 0
	}

	this.last_read = this.buffer[this.read_index]
	this.buffer[this.read_index] = f32(0.0)
	this.read_index++
	return this.last_read
}

pub fn (this CircularBuffer)read_at(index u32) ?f32 {
	if index > this.buffer.len {
		return error('Given index is out of the range.')
	}
	return this.buffer[index]
}

pub fn (mut this CircularBuffer)write(value f32) {
	if this.write_index >= this.buffer.len {
		this.write_index = 0
	}

	this.buffer[this.write_index] = value
	this.write_index++
}

pub fn (mut this CircularBuffer)write_at(index u32, value f32) {
	if index < this.buffer.len {
		this.buffer[index] = value
	}
}

pub fn (mut this CircularBuffer)clear() {
	this.read_index = 0
	this.write_index = 0
	this.last_read = f32(0.0)

	for mut element in this.buffer {
		element = f32(0)
	}
}
pub fn (this CircularBuffer)str() string {
	mut ret_str := 'CircularBuffer {'
	ret_str += '\n\tlength:   ${this.buffer.len},'
	ret_str += '\n\tcapacity: ${this.buffer.cap},'
	ret_str += '\n\tbuffer:   [ '
	for element in this.buffer {
		ret_str += '${element} '
	}
	ret_str += ']\n}'
	return ret_str
}