const MU = @import("../../../../drivers/drivers.zig").AUX.MINI_UART;

export fn irq_el1h() void {
    MU.write_str_sync("\n\rirq_el1h\n\r");
}
