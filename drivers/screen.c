#include "screen.h"
#include "../kernel/low_level.h"
#include "../kernel/util.h"

int get_screen_offset(int col, int row);
int get_cursor();
void set_cursor(int offset);
int handle_scrolling(int offset);

//Imprime un caracter en la columna y fila  y atributo indicados
void print_char(char character, int col, int row, char attribute_byte) {
  //Crear el puntero byte (char) y que apunte al inicio de la memoria de video
  unsigned char *vidmem = (unsigned char *) VIDEO_ADDRESS;

  //Si no hay atributo (0) asumir el default
  if(!attribute_byte){
    attribute_byte = WHITE_ON_BLACK;
  }

  //Calcular el offset de memoria para la posicion de la pantalla
  int offset;
  if (col >= 0 && row >= 0) {
    offset = get_screen_offset(col,row);
  } else{
    offset = get_cursor();
  }

  //Generar una nueva linea si se encuentra el caracter
  if(character == '\n'){
    int rows = offset / (2*MAX_COLS);
    offset = get_screen_offset(79,rows);
  } else {
    //Si no, escribir el caracter y su atributo en la memoria de video
    vidmem[offset] = character;
    vidmem[offset+1] = attribute_byte;
  }

  //Actualiza el offset para el siguiente caracter (2 bytes mas adelante)
  offset += 2;
  //Ajusta la pantalla (scrolling)
  offset = handle_scrolling(offset);
  //Actualiza la posicion del cursor en la pantalla
  set_cursor(offset);
}

int get_screen_offset(int col, int row) {
  return ((row*MAX_COLS) + col) * 2;
}

int get_cursor() {
  /*
   * El dispositivo usa el registro de control como indice
   * para seleccional su registro internlo, de los cuales estamos
   * interesados en :
   * reg 14: high byte of the cursor offset
   * reg 15: low byte of the cursor offset
   * Una vez se selecciona el registro a utilizar, se lee el dato del registro
   * en la variable offset
   */
  port_byte_out(REG_SCREEN_CTRL, 14);
  int offset = port_byte_in(REG_SCREEN_DATA) << 8;
  port_byte_out(REG_SCREEN_CTRL, 15);
  offset += port_byte_in(REG_SCREEN_DATA);

  //Ya que el cursor es un numero de caracteres, multiplicamos por 2
  //para convertilo en el offset de la celda;
  return offset*2;
}

void set_cursor(int offset) {
  //Convertir el offset de celda en offset de caracter
  offset /= 2;

  //Escribir los bytes a los registros internos del dispositivo
  port_byte_out(REG_SCREEN_CTRL, 14);
  port_byte_out(REG_SCREEN_DATA, (unsigned char) (offset >> 8));
  port_byte_out(REG_SCREEN_CTRL, 15);
  port_byte_out(REG_SCREEN_DATA, offset);
}

void print_at(char* message, int col, int row)
{
  //Posiciona el cursor si la fila y columno no son negativas
  if (col >= 0 && row >= 0) {
    set_cursor(get_screen_offset(col, row));
  }

  int i = 0;
  while(message[i] != 0) {
    print_char(message[i++], col, row, WHITE_ON_BLACK);
  }
}

void print(char* message)
{
  print_at(message, -1, -1);
}

void clear_screen()
{
  int row = 0;
  int col = 0;

  for (row = 0; row < MAX_ROWS; row++) {
    for (col = 0; col < MAX_COLS; col++) {
      print_char(' ', col, row, WHITE_ON_BLACK);
    }
  }

  set_cursor(get_screen_offset(0, 0));
}

int handle_scrolling(int cursor_offset) {
  //Avanzar el cursor, hacer scroll del buffer de video si es necesario
  //Verificar si el cursor esta dentro de la pantalla
  if (cursor_offset < MAX_ROWS*MAX_ROWS*2) {
    return cursor_offset;
  }

  //Mueve las filas hacia arriba una vez
  int i;
  for (i = 0; i < MAX_ROWS; i++) {
    memory_copy(get_screen_offset(0,i) + VIDEO_ADDRESS,
        get_screen_offset(0,i-1) + VIDEO_ADDRESS,
        MAX_COLS*2
        );
  }

  //Limpia la ultima fila
  char* last_line = get_screen_offset(0,MAX_ROWS-1) + VIDEO_ADDRESS;
  for (i = 0; i < MAX_COLS*2; i++) {
    last_line[i] = 0;
  }

  //Mueve el offset una fila hacia atras, para que sea la ultima fila
  //en vez de fuera de la pantalla
  cursor_offset -= 2*MAX_COLS;

  //Regresa la posicion actualizada del cursor
  return cursor_offset;
}
