const GPIO = @import("drivers").GPIO;
const IRQ = @import("drivers").IRQ;
const MU = @import("drivers").AUX.MINI_UART;

const EL = @import("boot").EL;

const a = @import("irq");

fn write_str(str: []const u8) void {
    for (str) |b| {
        while (MU.write_fifo_is_full())
            asm volatile ("nop");

        MU.write_unsafe(b);
    }
}

export fn kernel_main() noreturn {
    _ = a;

    MU.init();

    GPIO.set_function_select(21, .OUTPUT);
    GPIO.set_pin(21);

    if (EL.read_el() != 1)
        EL.switch_to_el1();

    IRQ.cpu_irq_enable();
    IRQ.enable_irq(.MINI_UART);

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

        write_str("Hello worldaa!\r\n");

        write_str(&.{@intCast(EL.read_el() + 48)});
    }
}
