const AUX_REGS = @import("aux.zig").AUX_REGS;
const GPIO = @import("../gpio.zig");

const SYSTEM_CLOCK_FREQ = 250000000;
const MINI_UART_BAUD_RATE = 115200;

const baud_rate: u32 = (SYSTEM_CLOCK_FREQ / (8 * MINI_UART_BAUD_RATE)) - 1;

pub fn init() void {
    GPIO.set_function_select(14, .ALT5);
    GPIO.set_function_select(15, .ALT5);

    GPIO.set_pull_up_down(14, .OFF);
    GPIO.set_pull_up_down(15, .OFF);

    AUX_REGS.enables().* = 0b1;

    AUX_REGS.mu_cntl().* = 0b0;

    AUX_REGS.mu_ier().* = 0b0;

    AUX_REGS.mu_iir().* = (0b1 << 1) | (0b1 << 2);

    AUX_REGS.mu_lcr().* = 0b11;

    AUX_REGS.mu_mcr().* = 0b0;

    AUX_REGS.mu_baud().* = baud_rate;

    AUX_REGS.mu_cntl().* = 0b11;

    // Enable Irq
    //  AUX_REGS.mu_ier().* = 0b1;
}

pub inline fn read() u8 {
    return @intCast(AUX_REGS.mu_io().* & 0xFF);
}

pub inline fn write_unsafe(b: u8) void {
    AUX_REGS.mu_io().* = @intCast(b);
}

pub inline fn write_fifo_is_full() bool {
    return (AUX_REGS.mu_lsr().* & (0b1 << 5) == 0);
}

pub fn write_str_sync(str: []const u8) void {
    for (str) |b| {
        while (write_fifo_is_full()) {
            asm volatile ("nop");
        }
        write_unsafe(b);
    }
}
