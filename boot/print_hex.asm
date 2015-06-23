;Imprime el valor del registro DX en hexadecimal
print_hex:
  pusha
  mov si, HEX_OUT+2
start_hex:
  mov bx, dx
  shr bx, 4
  add bh, 0x30
  cmp bh, 0x39
  jg add_7

print_char:
  mov [si], bh
  inc si
  shl dx, 4
  or dx, dx
  jnz start_hex
  mov bx, HEX_OUT
  call print_string
  popa
  ret

add_7:
  add bh, 0x7
  jmp print_char


HEX_OUT:
  db '0x0000',0
