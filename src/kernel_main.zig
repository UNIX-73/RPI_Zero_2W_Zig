const GPIO = @import("drivers/drivers.zig").GPIO;
const MU = @import("drivers/drivers.zig").AUX.MINI_UART;
const EL = @import("boot/exception_level/exception_level.zig");

fn write_str(str: []const u8) void {
    for (str) |b| {
        while (MU.write_fifo_is_full())
            asm volatile ("nop");

        MU.write_unsafe(b);
    }
}

extern fn switch_to_el1() noreturn;

export fn kernel_main() noreturn {
    GPIO.set_function_select(21, .OUTPUT);
    GPIO.set_pin(21);

    switch_to_el1();

    MU.init();

    var t: bool = true;

    while (true) {
        for (0..2000000) |_| {
            asm volatile ("nop");
        }

        if (t) {
            GPIO.set_pin(21);
        } else {
            GPIO.clear_pin(21);
        }

        t = !t;

        write_str("Hello world!\r\n");

        write_str(&.{@intCast(EL.read_el() + 48)});
    }
}
