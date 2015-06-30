;Load DH sectors to ES:BX from drive DL
disk_load:
  push dx ;Guarda DX
  mov ah, 0x02 ;indica leer de un dispositivo
  mov al, dh ;La cantidad de sectores
  mov ch, 0x00 ;El cilindro
  mov dh, 0x00 ;La cabeza
  mov cl, 0x02 ;El sector

  int 0x13 ;LLama a la interrupcion
  
  jc disk_error ;Si CF = 1 salta al sector de error

  pop dx ;Recupera DX
  cmp dh, al ;Verifica que se haya leido todo
  jne disk_error
  ret

disk_error:
  mov bx, DISK_ERROR_MSG
  call print_string
  jmp $

;DATA
DISK_ERROR_MSG db "Disk read error!", 0
