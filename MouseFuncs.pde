//final boolean PRINT_MouseFunc_Pressed = true; 
final boolean PRINT_MouseFunc_Pressed = false;

//final boolean PRINT_MouseFunc_Dragged = true; 
final boolean PRINT_MouseFunc_Dragged = false;

//final boolean PRINT_MouseFunc_Wheel = true; 
final boolean PRINT_MouseFunc_Wheel = false;

float mouseXPressed = 0.0; 
float mouseYPressed = 0.0; 
float mouseXDragged = 0.0; 
float mouseYDragged = 0.0; 

void mousePressed() {
  mouseXPressed = mouseX; 
  mouseYPressed = mouseY; 

  if (button_zoom_minus_over) {
    button_zoom_minus();
  }
  if (button_zoom_pluse_over) {
    button_zoom_pluse();
  }

  if (button_rotate_ccw_over) {
    ROTATE_FACTOR -= 90;
    if (ROTATE_FACTOR == -90) ROTATE_FACTOR = 270;
  }
  if (button_rotate_cw_over) {
    ROTATE_FACTOR += 90;
    if (ROTATE_FACTOR == 360) ROTATE_FACTOR = 0;
  }
  if (PRINT_MouseFunc_Pressed) println("ROTATE_FACTOR=" + ROTATE_FACTOR);

  if (button_mirror_en_over) {
    MIRROR_ENABLE = !MIRROR_ENABLE;
  }
  if (PRINT_MouseFunc_Pressed) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
}

void mouseDragged() 
{
  mouseXDragged = mouseX-mouseXPressed; 
  mouseYDragged = mouseY-mouseYPressed;
  if (PRINT_MouseFunc_Dragged) println("Mouse dragged! dx:" + mouseXDragged + ",dy:" + mouseYDragged);
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();

  if (PRINT_MouseFunc_Wheel) println("Mouse wheeled! count=" + e);
  if (e > 0) {
    for (; e > 0; e -= 1) {  
      button_zoom_minus();
    }
  }
  else if (e < 0)
    for (; e < 0; e += 1) {  
      button_zoom_pluse();
    }
}