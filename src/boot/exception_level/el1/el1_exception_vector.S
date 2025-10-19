#include "../save_stack_macros.S"

.global el1_irq_init_vectors
el1_irq_init_vectors:
    adr x0, el1_vectors
    msr VBAR_EL1, x0
    ret


//Exception vectors table
.macro	ventry	label
.align	7
    b	\label
.endm

.align	11
.globl el1_vectors 
el1_vectors:
    // EL1t
    ventry __sync_el1t     // Synchronous EL1t
    ventry __irq_el1t      // IRQ EL1t
    ventry __fiq_el1t      // FIQ EL1t
    ventry __err_el1t      // Error EL1t

    // EL1h
    ventry __sync_el1h     // Synchronous EL1h
    ventry __irq_el1h      // IRQ EL1h
    ventry __fiq_el1h      // FIQ EL1h
    ventry __err_el1h      // Error EL1h

    // EL0 64-bit
    ventry __sync_el0_64   // Synchronous 64-bit EL0
    ventry __irq_el0_64    // IRQ 64-bit EL0
    ventry __fiq_el0_64    // FIQ 64-bit EL0
    ventry __err_el0_64    // Error 64-bit EL0

    // EL0 32-bit
    ventry __sync_el0_32   // Synchronous 32-bit EL0
    ventry __irq_el0_32    // IRQ 32-bit EL0
    ventry __fiq_el0_32    // FIQ 32-bit EL0
    ventry __err_el0_32    // Error 32-bit EL0

// Revisar las macros usadas si no se entiende (es un wrapper que englobba las definiciones y llama a la fn de cpp)
__sync_el1t:
    wrap_vector sync_el1t
    eret

__irq_el1t:
    wrap_vector irq_el1t
    eret

__fiq_el1t:
    wrap_vector fiq_el1t
    eret

__err_el1t:
    wrap_vector serror_el1t
    eret

__sync_el1h:
    wrap_vector sync_el1h
    eret

__irq_el1h:
    wrap_vector irq_el1h
    eret

__fiq_el1h:
    wrap_vector fiq_el1h
    eret

__err_el1h:
    wrap_vector serror_el1h
    eret

__sync_el0_64:
    wrap_vector sync_el0_64
    eret

__irq_el0_64:
    wrap_vector irq_el0_64
    eret

__fiq_el0_64:
    wrap_vector fiq_el0_64
    eret

__err_el0_64:
    wrap_vector serror_el0_64
    eret

__sync_el0_32:
    wrap_vector sync_el0_32
    eret

__irq_el0_32:
    wrap_vector irq_el0_32
    eret

__fiq_el0_32:
    wrap_vector fiq_el0_32
    eret

__err_el0_32:
    wrap_vector serror_el0_32
    eret
