void main(){
  //Crear un puntero a un char, y hacer que apunte a la direccion de memeoria
  //de la primera celda de la memoria de video
  char* video_memory = (char*) 0xb8000;
  //En la direccion indicada hacer que alamacene el caracter 'X'
  //Esto hace que lo muestre en pantalla
  *video_memory = 'X';
}
