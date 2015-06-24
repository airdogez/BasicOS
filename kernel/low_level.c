unsigned char port_byte_in(unsigned short port)
{
  //Wrapper que lee un byte del puerto especificado
  //"=a" (result): guarda el valor de AL en la variable RESULT
  //"d" (port): carga EDX con PORT
  unsigned char result;
  __asm__("in %%dx, %%al" : "=a" (result) : "d" (port));
  return result;
}

void port_byte_out(unsigned short port, unsigned char data)
{
  //"a" (data): carga EAX con DATA
  //"d" (port): carga EDX con PORT
  __asm__("out %%al, %%dx" : : "a" (data), "d" (port));
}

unsigned short port_word_in(unsigned short port)
{
  unsigned short result;
  __asm__("in %%dx, %%ax" : "=a" (result) : "d" (port));
  return result;
}

void port_word_out(unsigned short port, unsigned short data)
{
  __asm__("out %%ax, %%dx" : : "a" (data), "d" (port));
}
