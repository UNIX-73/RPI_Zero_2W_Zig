const AUX = @import("drivers").AUX;
const MU = AUX.MINI_UART;
const IRQ = @import("drivers").IRQ;

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
    const irq_pending1 = IRQ.IRQ_REGS.pending1().*;

    // Mini UART IRQ
    if ((irq_pending1 & @intFromEnum(IRQ.IRQ_OPTIONS.MINI_UART)) != 0) {
        const iir = AUX.AUX_REGS.mu_iir().*;

        // bit 0 = 1 no IRQ pending
        if ((iir & 0b1) == 1) return;

        switch ((iir >> 1) & 0b11) {
            0b10 => {
                // Receiver holds valid byte
                const b: u8 = @intCast(AUX.AUX_REGS.mu_io().*);
                MU.write_str_sync(&.{b});
            },
            0b01 => {
                //Transmit holding register empty
            },
            else => {},
        }
    }
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
