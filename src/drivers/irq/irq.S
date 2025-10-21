.globl irq_enable
cpu_irq_enable:
    msr daifclr, #2
    ret

.globl irq_disable
cpu_irq_disable:
    msr daifset, #2
    ret