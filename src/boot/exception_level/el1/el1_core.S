.global switch_to_el1
switch_to_el1:
    ldr x0, =__stack_el1_top
    msr SP_EL1, x0

    ldr x0, =__stack_el0_top
    msr SP_EL0, x0

    /* EL1 AArch64 */
    mov x0, #(1 << 31)
    msr HCR_EL2, x0

    mov x0, #0x3c5
    msr SPSR_EL2, x0

    ldr x0, =el1_entry
    msr ELR_EL2, x0

    eret

.global el1_entry
el1_entry:
    mov x0, #1
    msr spsel, x0

    bl el1_irq_init_vectors    /* hace msr VBAR_EL1, x0 y ret */

    bl kernel_main
