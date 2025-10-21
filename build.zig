const std = @import("std");

pub fn build(b: *std.Build) void {
    const allocator = b.allocator;
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
    const drivers_module = b.createModule(.{
        .root_source_file = b.path(
            "./src/drivers/drivers.zig",
        ),
        .target = target,
    });

    irq_module.addImport("drivers", drivers_module);
    elf.root_module.addImport("drivers", drivers_module);
    //  Boot
    const boot_module = b.createModule(.{
        .root_source_file = b.path(
            "./src/boot/boot.zig",
        ),
        .target = target,
    });

    elf.root_module.addImport("boot", boot_module);

    // -- ASM --
    const src_dir = std.fs.cwd().openDir(
        "./src",
        .{ .iterate = true },
    ) catch return;
    var it = src_dir.walk(allocator) catch return;
    defer it.deinit();

    while (it.next() catch return) |entry| {
        if (entry.kind == .file and
            (std.mem.endsWith(u8, entry.path, ".S") or std.mem.endsWith(u8, entry.path, ".s")))
        {
            elf.root_module.addAssemblyFile(
                b.path(
                    b.pathJoin(&.{
                        "./src/",
                        entry.path,
                    }),
                ),
            );

            drivers_module.addAssemblyFile(
                b.path(
                    b.pathJoin(&.{
                        "./src/",
                        entry.path,
                    }),
                ),
            );
        }
    }

    elf.setLinkerScript(b.path("./linker.ld"));

    b.dest_dir = "./build";
    const copy_elf = b.addInstallArtifact(elf, .{});
    b.default_step.dependOn(&copy_elf.step);

    const bin = b.addObjCopy(elf.getEmittedBin(), .{ .format = .bin });
    bin.step.dependOn(&elf.step);

    const copy_bin = b.addInstallBinFile(bin.getOutput(), "kernel8.img");
    b.default_step.dependOn(&copy_bin.step);
}

fn build_module(b: *std.Build, path: []const u8) *std.Build.Module {
    const module = b.createModule(.{
        .root_source_file = b.path(

            b.pathJoin(paths: []const []const u8)
            "./src/drivers/drivers.zig",
        ),
        .target = target,
    });

    irq_module.addImport("drivers", drivers_module);
    elf.root_module.addImport("drivers", drivers_module);
}
