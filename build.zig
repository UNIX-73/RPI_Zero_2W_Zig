const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .aarch64,
        .os_tag = .freestanding,
        .abi = .none,
    });

    const elf = b.addExecutable(.{
        .name = "kernel8.elf",
        .root_module = b.createModule(.{
            .root_source_file = b.path("./src/kernel_main.zig"),
            .target = target,
        }),
    });

    // -- Modules --
    // Irq
    const irq_module = b.createModule(.{
        .root_source_file = b.path(
            "./src/boot/exception_level/el1/exceptions/exceptions_handlers.zig",
        ),
        .target = target,
    });

    elf.root_module.addImport(
        "irq",
        irq_module,
    );

    //  Drivers
    const drivers_module = build_module(b, target, "drivers") catch return;

    irq_module.addImport("drivers", drivers_module);
    elf.root_module.addImport("drivers", drivers_module);
    //  Boot
    const boot_module = build_module(b, target, "boot") catch return;

    elf.root_module.addImport("boot", boot_module);

    // -- ASM --

    elf.setLinkerScript(b.path("./linker.ld"));

    b.dest_dir = "./build";
    const copy_elf = b.addInstallArtifact(elf, .{});
    b.default_step.dependOn(&copy_elf.step);

    const bin = b.addObjCopy(elf.getEmittedBin(), .{ .format = .bin });
    bin.step.dependOn(&elf.step);

    const copy_bin = b.addInstallBinFile(bin.getOutput(), "kernel8.img");
    b.default_step.dependOn(&copy_bin.step);
}

fn build_module(
    b: *std.Build,
    target: std.Build.ResolvedTarget,
    path: []const u8,
) !*std.Build.Module {
    var buf: [4096]u8 = undefined;

    const module = b.createModule(.{
        .root_source_file = b.path(
            try std.fmt.bufPrint(
                &buf,
                "./src/{s}/{s}.zig",
                .{ path, path },
            ),
        ),
        .target = target,
    });

    var asm_buf: [4096]u8 = undefined;
    const asm_dir_u8 = try std.fmt.bufPrint(
        &asm_buf,
        "./src/{s}",
        .{path},
    );

    const asm_dir = try std.fs.cwd().openDir(
        asm_dir_u8,
        .{ .iterate = true },
    );

    var it = try asm_dir.walk(b.allocator);
    defer it.deinit();

    while (try it.next()) |entry| {
        if (entry.kind == .file and
            (std.mem.endsWith(u8, entry.path, ".S") or std.mem.endsWith(u8, entry.path, ".s")))
        {
            module.addAssemblyFile(
                b.path(
                    b.pathJoin(&.{
                        asm_dir_u8,
                        entry.path,
                    }),
                ),
            );
        }
    }

    return module;
}
