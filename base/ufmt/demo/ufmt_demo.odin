package ufmt_demo

import ".."

Foo :: struct {
    a:          i32,
    b:          f32,
    ptr:        rawptr,
    simple:     Simple,
    parent:     ^Foo,
    flags:      bit_set[Flag],
    flag:       Flag,
    flag_vals:  [Flag]f32,
    data:       []byte,
    data2:      [2]byte,
    dyn:        [dynamic]f32,
    type:       typeid,
}

Flag :: enum u16 {
    Invalid = 0,
    A,
    B,
    C,
}

Simple :: struct {
    a: f32,
    b: f32,
}

main :: proc() {
    foo: Foo = {
        a = 123,
        b = -1.3,
        ptr = rawptr(uintptr(0xffff)),
        parent = &Foo{},
        flags = {.A, .C},
        flag_vals = {
            .Invalid = 0,
            .A = 1,
            .B = 10,
            .C = 100,
        },
        data = {
            123, 0, 22, 33, 0, 1,
        },
        data2 = {1, 2},
        type = typeid_of(Simple),
    }

    append(&foo.dyn, 1.1)
    append(&foo.dyn, 1.2)
    append(&foo.dyn, 1.3)

    ufmt.eprintfln("%#", foo)
}