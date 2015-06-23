[bits 16]

switch_to_pm:
  cli ;Limpia el switch de interrupciones hasta haber 
      ;iniciado el vector de  modo protegido
      ;caso contrario las interrupciones entrarian en conflicto
  lgdt [gdt_descriptor] ;carga la tabla global del descriptor,
                        ;la cual define el modo protegido de los segmentos

  mov eax, cr0 ;Para hacer el cambio a modo protegido se cambia el primer bit
  or eax, 0x1 ;del registro cr0 a 1.
  mov cr0, eax

  jmp CODE_SEG:init_pm ;Se hace un salto largo(a un nuevo segmento)
                       ;Ademas fuerza al cpu a limpiar su cache

[bits 32]
;Inicializa los registro y la pila al entrar a PM
init_pm:
  mov ax, DATA_SEG ;Estadno en PM se inicializan todos los antiguos segmentos
  mov ds, ax       ;para que apunten al segmento de datos definido en el GDT
  mov ss, ax
  mov es, ax
  mov fs, ax
  mov gs, ax

  mov ebp, 0x90000 ;Se actualiza la posicion de la pila para que
  mov esp, ebp     ;apunte al tope del espacio libre

  call BEGIN_PM    ;Llamado a un espacio conocido


