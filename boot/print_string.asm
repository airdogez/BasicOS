;Prints a string on screen
print_string:
  pusha
  mov ah, 0x0e
continue:
  mov al, [bx]
  int 0x10
  cmp al, 0x00
  je end_fun
  add bx, 1
  jmp continue
end_fun:
  popa
  ret
