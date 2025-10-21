const MU = @import("drivers").AUX.MINI_UART;

export fn sync_el1t() void {
    MU.write_str_sync("\n\rSYNC_EL1T\n\r");
}

export fn irq_el1t() void {
    MU.write_str_sync("\n\rIRQ_EL1T\n\r");
}

export fn fiq_el1t() void {
    MU.write_str_sync("\n\rFIQ_EL1T\n\r");
}

export fn serror_el1t() void {
    MU.write_str_sync("\n\rSERROR_EL1T\n\r");
}

export fn sync_el1h() void {
    MU.write_str_sync("\n\rSYNC_EL1H\n\r");
}

export fn irq_el1h() void {
    MU.write_str_sync("\n\rIRQ_EL1H\n\r");
}

export fn fiq_el1h() void {
    MU.write_str_sync("\n\rFIQ_EL1H\n\r");
}

export fn serror_el1h() void {
    MU.write_str_sync("\n\rSERROR_EL1H\n\r");
}

export fn sync_el0_64() void {
    MU.write_str_sync("\n\rSYNC_EL0_64\n\r");
}

export fn irq_el0_64() void {
    MU.write_str_sync("\n\rIRQ_EL0_64\n\r");
}

export fn fiq_el0_64() void {
    MU.write_str_sync("\n\rFIQ_EL0_64\n\r");
}

export fn serror_el0_64() void {
    MU.write_str_sync("\n\rSERROR_EL0_64\n\r");
}

export fn sync_el0_32() void {
    MU.write_str_sync("\n\rSYNC_EL0_32\n\r");
}

export fn irq_el0_32() void {
    MU.write_str_sync("\n\rIRQ_EL0_32\n\r");
}

export fn fiq_el0_32() void {
    MU.write_str_sync("\n\rFIQ_EL0_32\n\r");
}

export fn serror_el0_32() void {
    MU.write_str_sync("\n\rSERROR_EL0_32\n\r");
}
