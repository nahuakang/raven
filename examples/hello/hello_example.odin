package raven_example_hello

import "core:log"
import "core:math"
import rv "../.."

state: ^State
State :: struct {
    num:    i32,
    raven:  ^rv.State,
}

main :: proc() {
    rv.run_main_loop(cast(rv.Step_Proc)_step)
}

@export _step :: proc "contextless" (prev_state: ^State) -> ^State {
    context = rv.default_context()
    // THIS LEAKS THE LOGGER FUCK
    context.logger = log.create_console_logger()

    state = prev_state
    if state == nil {
        rv.init("Raven Hello Example")
        state = new(State)
        state.raven = rv.get_state_ptr()
    }

    rv.set_state_ptr(state.raven)

    if !rv.new_frame() {
        return nil
    }

    rv.set_layer_params(0, rv.make_screen_camera())
    rv.set_layer_params(1, rv.make_screen_camera())

    rv.bind_depth_test(true)
    rv.bind_depth_write(true)
    rv.bind_texture("thick")

    center := rv.get_viewport() * {0.5, 0.5, 0}
    for i in 0..<3 {
        t := f32(i) / 2
        rv.draw_text("Hello World!",
            center + {
                0,
                math.sin_f32(rv.get_time() - t * 0.5) * 100,
                f32(i) * 0.1,
            },
            anchor = 0.5,
            spacing = 1,
            scale = 4,
            col = i == 0 ? rv.WHITE : rv.BLUE,
        )
    }

    rv.bind_layer(1)
    rv.bind_blend(.Add)
    rv.draw_text("Hello World!",
        {100, 100, 0},
        anchor = 0,
        spacing = 1,
        scale = 4,
        col = rv.RED * rv.fade(0.5),
    )

    state.num += 1

    rv.upload_gpu_layers()

    rv.render_gpu_layer(0, rv.DEFAULT_RENDER_TEXTURE,
        clear_color = rv.Vec3{0, 0, 0.5},
        clear_depth = true,
    )

    rv.render_gpu_layer(1, rv.DEFAULT_RENDER_TEXTURE,
        clear_color = nil,
        clear_depth = false,
    )

    return state
}
