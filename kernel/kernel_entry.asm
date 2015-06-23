;Programa que llama al main del codigo de alto nivel
;Permite saltar directamente a la funcion de entrada del kernel (main)
[bits 32] ;Estamos en modo protegido, usamos intrucciones de 32 bits
[extern main] ;Declamarmos que usaramos un simbolo externo
  call main   ;Asi el linker substituira la direccion del main, se invoka
  jmp $       ;Un loop infinito cuando se regrese del kernel
