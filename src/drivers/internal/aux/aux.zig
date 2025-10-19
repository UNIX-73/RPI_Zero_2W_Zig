pub const MINI_UART = @import("mini_uart.zig");

const AUX_BASE = @import("../../peripherals.zig").BASE + 0x215000;

const AUX_REG_OFFSETS = enum(u32) {
    IRQ_OFFSET = 0x000,
    ENABLES_OFFSET = 0x004,

    MU_IO_REG_OFFSET = 0x040,
    MU_IER_REG_OFFSET = 0x044,
    MU_IIR_REG_OFFSET = 0x048,
    MU_LCR_REG_OFFSET = 0x04C,
    MU_MCR_REG_OFFSET = 0x050,
    MU_LSR_REG_OFFSET = 0x054,
    MU_MSR_REG_OFFSET = 0x058,
    MU_SCRATCH_OFFSET = 0x05C,
    MU_CNTL_REG_OFFSET = 0x060,
    MU_STAT_REG_OFFSET = 0x064,
    MU_BAUD_REG_OFFSET = 0x068,

    SPI0_CNTL0_REG_OFFSET = 0x080,
    SPI0_CNTL1_REG_OFFSET = 0x084,
    SPI0_STAT_REG_OFFSET = 0x088,
    SPI0_IO_REG_OFFSET = 0x090,
    SPI0_PEEK_REG_OFFSET = 0x094,

    SPI1_CNTL0_REG_OFFSET = 0x0C0,
    SPI1_CNTL1_REG_OFFSET = 0x0C4,
    SPI1_STAT_REG_OFFSET = 0x0C8,
    SPI1_IO_REG_OFFSET = 0x0D0,
    SPI1_PEEK_REG_OFFSET = 0x0D4,

    pub fn value(comptime self: AUX_REG_OFFSETS) u32 {
        return @intFromEnum(self);
    }
};

pub const AUX_REGS = struct {
    inline fn reg_addr(comptime offset: AUX_REG_OFFSETS) *volatile u32 {
        return @ptrFromInt(AUX_BASE + offset.value());
    }

    // === AUX global registers ===
    pub inline fn irq() *volatile u32 {
        return reg_addr(.IRQ_OFFSET);
    }

    pub inline fn enables() *volatile u32 {
        return reg_addr(.ENABLES_OFFSET);
    }

    // === Mini UART registers ===
    pub inline fn mu_io() *volatile u32 {
        return reg_addr(.MU_IO_REG_OFFSET);
    }

    pub inline fn mu_ier() *volatile u32 {
        return reg_addr(.MU_IER_REG_OFFSET);
    }

    pub inline fn mu_iir() *volatile u32 {
        return reg_addr(.MU_IIR_REG_OFFSET);
    }

    pub inline fn mu_lcr() *volatile u32 {
        return reg_addr(.MU_LCR_REG_OFFSET);
    }

    pub inline fn mu_mcr() *volatile u32 {
        return reg_addr(.MU_MCR_REG_OFFSET);
    }

    pub inline fn mu_lsr() *volatile u32 {
        return reg_addr(.MU_LSR_REG_OFFSET);
    }

    pub inline fn mu_msr() *volatile u32 {
        return reg_addr(.MU_MSR_REG_OFFSET);
    }

    pub inline fn mu_scratch() *volatile u32 {
        return reg_addr(.MU_SCRATCH_OFFSET);
    }

    pub inline fn mu_cntl() *volatile u32 {
        return reg_addr(.MU_CNTL_REG_OFFSET);
    }

    pub inline fn mu_stat() *volatile u32 {
        return reg_addr(.MU_STAT_REG_OFFSET);
    }

    pub inline fn mu_baud() *volatile u32 {
        return reg_addr(.MU_BAUD_REG_OFFSET);
    }

    // === SPI0 registers ===
    pub inline fn spi0_cntl0() *volatile u32 {
        return reg_addr(.SPI0_CNTL0_REG_OFFSET);
    }

    pub inline fn spi0_cntl1() *volatile u32 {
        return reg_addr(.SPI0_CNTL1_REG_OFFSET);
    }

    pub inline fn spi0_stat() *volatile u32 {
        return reg_addr(.SPI0_STAT_REG_OFFSET);
    }

    pub inline fn spi0_io() *volatile u32 {
        return reg_addr(.SPI0_IO_REG_OFFSET);
    }

    pub inline fn spi0_peek() *volatile u32 {
        return reg_addr(.SPI0_PEEK_REG_OFFSET);
    }

    // === SPI1 registers ===
    pub inline fn spi1_cntl0() *volatile u32 {
        return reg_addr(.SPI1_CNTL0_REG_OFFSET);
    }

    pub inline fn spi1_cntl1() *volatile u32 {
        return reg_addr(.SPI1_CNTL1_REG_OFFSET);
    }

    pub inline fn spi1_stat() *volatile u32 {
        return reg_addr(.SPI1_STAT_REG_OFFSET);
    }

    pub inline fn spi1_io() *volatile u32 {
        return reg_addr(.SPI1_IO_REG_OFFSET);
    }

    pub inline fn spi1_peek() *volatile u32 {
        return reg_addr(.SPI1_PEEK_REG_OFFSET);
    }
};
