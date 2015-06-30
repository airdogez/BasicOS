;Prints a string on screen
print_string:
  pusha ;Guardamos los registros
  mov ah, 0x0e ;Indica a la interrupcion que funcion utilizar: Imprimir Caracter
continue:
  mov al, [bx] ;Mueve a AL la direccion donde se encuentra el caracter a imprimir
  int 0x10 ;Llama a la interrupcion
  cmp al, 0x00 ;Verifica que no este en el ultimo caracter de la cadena
  je end_fun ;Si es asi termina la funcion
  add bx, 1 ;Incrementa la posicion de memoria
  jmp continue ;Vuelve a realizar el proceso de impresion de caracter
end_fun:
  popa ;Recuperamos los registros
  ret
