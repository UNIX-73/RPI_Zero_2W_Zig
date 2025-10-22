const GPIO = @import("drivers").GPIO;
const IRQ = @import("drivers").IRQ;
const MU = @import("drivers").AUX.MINI_UART;
const EL = @import("boot").EL;

fn write_str(str: []const u8) void {
    for (str) |b| {
        while (MU.write_fifo_is_full())
            asm volatile ("nop");

        MU.write_unsafe(b);
    }
}
