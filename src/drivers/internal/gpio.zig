const GPIO_BASE = @import("../peripherals.zig").BASE + 0x200000;

const GPIO_REG_OFFSETS = enum(u32) {
    FSEL_OFFSET = 0x0,
    SET_OFFSET = 0x1c,
    CLR_OFFSET = 0x28,
    LEV_OFFSET = 0x34,
    PUD_OFFSET = 0x94,
    PUDLOCK_OFFSET = 0x98,

    pub fn value(comptime self: GPIO_REG_OFFSETS) u32 {
        return @intFromEnum(self);
    }

    pub fn bit_len(comptime self: GPIO_REG_OFFSETS) u32 {
        return comptime switch (self) {
            .FSEL_OFFSET => 10,
            else => 32,
        };
    }
};

pub const GPIO_REGS = struct {
    inline fn reg_addr(pin: u32, comptime offset: GPIO_REG_OFFSETS) *volatile u32 {
        if (pin > 39) {
            // TODO: Warn or panic
        }

        const reg_offset = (pin / offset.bit_len()) * @sizeOf(u32);

        return @ptrFromInt(
            GPIO_BASE + offset.value() + reg_offset,
        );
    }
    pub fn fsel(pin: u32) *volatile u32 {
        return GPIO_REGS.reg_addr(pin, .FSEL_OFFSET);
    }

    pub inline fn set(pin: u32) *volatile u32 {
        return GPIO_REGS.reg_addr(pin, .SET_OFFSET);
    }

    pub inline fn clear(pin: u32) *volatile u32 {
        return GPIO_REGS.reg_addr(pin, .CLR_OFFSET);
    }

    pub inline fn lev(pin: u32) *volatile u32 {
        return GPIO_REGS.reg_addr(pin, .LEV_OFFSET);
    }

    pub inline fn pud() *volatile u32 {
        return @ptrFromInt(GPIO_BASE + GPIO_REG_OFFSETS.PUD_OFFSET.value());
    }

    pub inline fn pudlock(pin: u32) *volatile u32 {
        return GPIO_REGS.reg_addr(pin, .PUDLOCK_OFFSET);
    }
};

pub const PIN_MODES = enum(u32) {
    INPUT = 0b000,
    OUTPUT = 0b001,
    ALT0 = 0b100,
    ALT1 = 0b101,
    ALT2 = 0b110,
    ALT3 = 0b111,
    ALT4 = 0b011,
    ALT5 = 0b010,

    pub fn mask(comptime self: PIN_MODES) u32 {
        return @intFromEnum(self);
    }
};

pub const PUD_OPTIONS = enum(u32) {
    OFF = 0b00,
    PULL_DOWN = 0b01,
    PULL_UP = 0b10,

    pub fn mask(comptime self: PUD_OPTIONS) u32 {
        return @intFromEnum(self);
    }
};

pub fn set_function_select(pin: u32, comptime pin_mode: PIN_MODES) void {
    const reg: *volatile u32 = GPIO_REGS.fsel(pin);

    const shift: u5 = @intCast((pin % 10) * 3);
    const mask: u32 = 0b111;

    var reg_value: u32 = reg.*;

    reg_value &= ~(mask << shift);
    reg_value |= ((pin_mode.mask() & mask) << shift);

    reg.* = reg_value;
}

pub inline fn set_pin(pin: u32) void {
    const bit_pos: u5 = @intCast(pin % 32);
    GPIO_REGS.set(pin).* = (0b1 << bit_pos);
}

pub inline fn clear_pin(pin: u32) void {
    const bit_pos: u5 = @intCast(pin % 32);
    GPIO_REGS.clear(pin).* = (0b1 << bit_pos);
}

pub inline fn read_pin(pin: u32) bool {
    const bit_pos: u5 = @intCast(pin % 32);
    return @as(bool, (GPIO_REGS.lev(pin).* >> bit_pos) & 0b1);
}

pub fn set_pull_up_down(pin: u32, comptime pud_option: PUD_OPTIONS) void {
    const pud_reg: *volatile u32 = GPIO_REGS.pud();
    const pudlock_reg: *volatile u32 = GPIO_REGS.pudlock(pin);

    pud_reg.* = pud_option.mask();

    const bit_pos: u5 = @intCast(pin % 32);

    for (0..400) |_|
        asm volatile ("nop");

    pudlock_reg.* = (@as(u32, 1) << bit_pos);

    for (0..400) |_|
        asm volatile ("nop");

    pud_reg.* = 0;
    pudlock_reg.* = 0;
}
