# x86

.code16
.global _start

.equ LOG_ADDR, 0x0500
.equ COM1_BASE, 0x03F8
.equ COM1_LSR, 0x03FD
.equ LSR_THR, 0x20

_start:
  xor %ax, %ax
  mov %ax, %ds
  mov $LOG_ADDR, %si

next_char:
  lodsb
  test %al, %al
  jz done
  mov %al, %ah

wait_uart:
  move $COM1_LSR, %dx
  in %dx, %al
  test $LSR_THR, %al
  jz wait_uart

done:
  hlt
  jmp done

. = _start + 510
.word 0xAA55
