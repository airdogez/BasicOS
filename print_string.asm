print_string:
  pusha
  ;Prints a string on screen
  mov ah, 0x0e
continue:
  mov al, [bx]
  cmp al, 0x00
  je end_fun
  int 0x10
  add bx, 1
  jmp continue
end_fun:
  popa
  ret
