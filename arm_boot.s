# akita ARM bootloader

.global _start

.equ LOG_ADDR, 0xA3F00000
.equ UART_BASE, 0x40100000
.equ UART_THR, 0x0
.equ UART_LSR, 0x14
.equ LSR_THR, 0x20

_start:
.align 5
trap_tab:
  ldr pc, =reset
  ldr pc, =reset
  ldr pc, =reset
  ldr pc, =reset
  ldr pc, =reset
  nop
  ldr pc, =reset
  ldr pc, =reset

reset:
  mrs r0, cpsr
  bic r0, r0, #0xFF
  orr r0, r0, #0xD3
  msr cpsr_fc, r0

  ldr sp, =0xA0000000
  ldr r4, =LOG_ADDR
  ldr r5, =UART_BASE

send:
  ldrb r0, [r4], #1
  cmp r0, #0
  beq halt

wait_thr_empty:
  ldr r1, [r5, #UART_LSR]
  tst r1, #LSR_THR
  beq wait_thr_empty
  strb r0, [r5, #UART_THR]
  b send

halt:
  b halt
