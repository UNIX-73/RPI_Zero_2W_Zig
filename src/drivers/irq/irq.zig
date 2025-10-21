const std = @import("std");
const PERIPHERAL_BASE = @import("../peripherals.zig").BASE;

/// Base address for IRQ registers (relative to peripheral base)
const IRQ_BASE = PERIPHERAL_BASE + 0x0000_B200;

/// IRQ register offsets
const IRQ_REG_OFFSETS = enum(u32) {
    BASIC_PENDING = 0x200,
    PENDING_1 = 0x204,
    PENDING_2 = 0x208,
    FIQ_CONTROL = 0x20C,
    ENABLE_IRQS_1 = 0x210,
    ENABLE_IRQS_2 = 0x214,
    ENABLE_BASIC_IRQS = 0x218,
    DISABLE_IRQS_1 = 0x21C,
    DISABLE_IRQS_2 = 0x220,
    DISABLE_BASIC_IRQS = 0x224,

    pub fn value(self: IRQ_REG_OFFSETS) u32 {
        return @intFromEnum(self);
    }
};

/// IRQ register accessor
pub const IRQ_REGS = struct {
    inline fn reg_addr(comptime offset: IRQ_REG_OFFSETS) *volatile u32 {
        return @ptrFromInt(IRQ_BASE + offset.value());
    }

    pub inline fn basic_pending() *volatile u32 {
        return reg_addr(.BASIC_PENDING);
    }

    pub inline fn pending1() *volatile u32 {
        return reg_addr(.PENDING_1);
    }

    pub inline fn pending2() *volatile u32 {
        return reg_addr(.PENDING_2);
    }

    pub inline fn enable1() *volatile u32 {
        return reg_addr(.ENABLE_IRQS_1);
    }

    pub inline fn enable2() *volatile u32 {
        return reg_addr(.ENABLE_IRQS_2);
    }

    pub inline fn disable1() *volatile u32 {
        return reg_addr(.DISABLE_IRQS_1);
    }

    pub inline fn disable2() *volatile u32 {
        return reg_addr(.DISABLE_IRQS_2);
    }
};

/// IRQ options — bit masks for ENABLE_IRQS_1/2
pub const IRQ_OPTIONS = enum(u32) {
    MINI_UART = 1 << 29,

    pub fn value(self: IRQ_OPTIONS) u32 {
        return @intFromEnum(self);
    }
};

/// Enable a specific IRQ (e.g., MINI_UART)
pub fn enable_irq(option: IRQ_OPTIONS) void {
    IRQ_REGS.enable1().* |= option.value();
}

/// Disable a specific IRQ
pub fn disable_irq(option: IRQ_OPTIONS) void {
    IRQ_REGS.disable1().* |= option.value();
}

/// Assembly functions to globally enable/disable CPU IRQs
pub extern fn cpu_irq_enable() void; // → msr DAIFClr, #2
pub extern fn cpu_irq_disable() void; // → msr DAIFSet, #2

/// Software interrupt (Supervisor Call)
pub fn trigger_svc() void {
    asm volatile ("svc #0");
}
