;GDT
gdt_start:

gdt_null: ;Null descriptor, obligatorio 2 double words de 0
  dd 0x0
  dd 0x0

gdt_code: ;Code segment descriptor
  ; BASE: 0x0, LIMiTE: 0xffff, (WORDS)
  ; FLAGS: Present: 1, Privilege: 00, Descriptor Type: 1 -> 1001b
  ; Type FLAGS: Code: 1, Conforming: 0, Readable: 1, Accessed: 0 -> 1010
  ; FLAGS: Granularity: 1, 32bit default: 1, 64bit seg: 0, AVL: 0 -> 1100b
  dw 0xffff ;LIMITE (0-15)
  dw 0x0     ;BASE (0-15)
  db 0x0     ;BASE (16-23)
  db 10011010b ;FLAGS + type Flags
  db 11001111b ;FLAGS + Limit (16-19)
  db 0x0       ;BASE (24-31)

gdt_data:
  ;Type flags change:
  ;Code: 0, expand Down: 0, Writable: 1, Accessed: 0 -> 0010b
  dw 0xffff
  dw 0x0
  db 0x0
  db 10010010b
  db 11001111b
  db 0x0

gdt_end: ;Nos da la direccion de memoria donde terminan las definiciones del GDT

gdt_descriptor:
  dw gdt_end - gdt_start - 1 ;Tamanho del GDT menos 1
  dd gdt_start               ;Direccion de inicio del GDT

;Se definen constantes del segmento de codigo y datos
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start
