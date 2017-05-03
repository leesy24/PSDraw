//final boolean PRINT_MouseFunc_Pressed = true; 
final boolean PRINT_MouseFunc_Pressed = false;

//final boolean PRINT_MouseFunc_Released = true; 
final boolean PRINT_MouseFunc_Released = false;

//final boolean PRINT_MouseFunc_Dragged = true; 
final boolean PRINT_MouseFunc_Dragged = false;

//final boolean PRINT_MouseFunc_Wheel = true; 
final boolean PRINT_MouseFunc_Wheel = false;

int mouseXPressed = 0; 
int mouseYPressed = 0; 

void mousePressed() {
  //println("SCREEN_WIDTH - mouseX=" + (SCREEN_WIDTH - mouseX) + ", mouseY=" + mouseY);
  //println("mouseX=" + mouseX + ", mouseY=" + mouseY);
  mouseXPressed = mouseX - GRID_OFFSET_X; 
  mouseYPressed = mouseY - GRID_OFFSET_Y; 

  if (button_zoom_minus_over) {
    button_zoom_minus();
  }
  if (button_zoom_pluse_over) {
    button_zoom_pluse();
  }

  //println("old GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
  if (button_rotate_ccw_over) {
    int save;
    ROTATE_FACTOR -= 90;
    if (ROTATE_FACTOR == -90) ROTATE_FACTOR = 270;
    save = GRID_OFFSET_X;
    GRID_OFFSET_X = int(float(GRID_OFFSET_Y) * float(SCREEN_WIDTH) / float(SCREEN_HEIGHT));
    GRID_OFFSET_Y = int(-1.0 * float(save) * float(SCREEN_HEIGHT) / float(SCREEN_WIDTH));
    if (PRINT_MouseFunc_Pressed) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
  }
  if (button_rotate_cw_over) {
    int save;
    ROTATE_FACTOR += 90;
    if (ROTATE_FACTOR == 360) ROTATE_FACTOR = 0;
    save = GRID_OFFSET_X;
    GRID_OFFSET_X = int(-1.0 * float(GRID_OFFSET_Y) * float(SCREEN_WIDTH) / float(SCREEN_HEIGHT));
    GRID_OFFSET_Y = int(float(save) * float(SCREEN_HEIGHT) / float(SCREEN_WIDTH));
    if (PRINT_MouseFunc_Pressed) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
  }
  //println("new GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);

  if (button_mirror_en_over) {
    MIRROR_ENABLE = !MIRROR_ENABLE;
    if (PRINT_MouseFunc_Pressed) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
  }

  if (button_reset_en_over) {
    if (PRINT_MouseFunc_Pressed) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
    if (PRINT_MouseFunc_Pressed) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
    if (PRINT_MouseFunc_Pressed) println("GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    GRID_OFFSET_X = GRID_OFFSET_Y = 0;
    MIRROR_ENABLE = false;
    ZOOM_FACTOR = 100;
  }
}

void mouseReleased() {
  if (PRINT_MouseFunc_Released) println("Mouse released! ");
}

void mouseDragged() 
{
  GRID_OFFSET_X = mouseX - mouseXPressed;
  GRID_OFFSET_Y = mouseY - mouseYPressed;
  
  if (PRINT_MouseFunc_Dragged) println("Mouse dragged! dx:" + GRID_OFFSET_X + ",dy:" + GRID_OFFSET_Y);
}

void mouseWheel(MouseEvent event) {
  int wheel_count = event.getCount();
  float zoom_factor_save = ZOOM_FACTOR;
  int dx=0, dy=0;

  if (PRINT_MouseFunc_Wheel) println("Mouse wheeled! count=" + wheel_count);
  if (wheel_count > 0) {
    for (; wheel_count > 0; wheel_count -= 1) {  
      button_zoom_minus();
    }
  }
  else if (wheel_count < 0) {
    for (; wheel_count < 0; wheel_count += 1) {  
      button_zoom_pluse();
    }
  }

  // Check zoom factor changed.
  if (zoom_factor_save != ZOOM_FACTOR) {
    //println("old ZOOM_FACTOR=" + zoom_factor_save + ", new ZOOM_FACTOR=" + ZOOM_FACTOR);
    //println("SCREEN_WIDTH - mouseX=" + (SCREEN_WIDTH - mouseX) + ", mouseY=" + mouseY);
    //println("GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    if (ROTATE_FACTOR == 0) {
      dx = 
        int(
          (mouseX - GRID_OFFSET_X)
          -
          (mouseX - GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR
        );
      dy =
        int(
          (mouseY - SCREEN_HEIGHT / 2 - GRID_OFFSET_Y)
          -
          (mouseY - SCREEN_HEIGHT / 2 - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR
        );
    }
    else if (ROTATE_FACTOR == 90) {
      dx = 
        int(
          (mouseX - SCREEN_WIDTH / 2 - GRID_OFFSET_X)
          -
          (mouseX - SCREEN_WIDTH / 2 - GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR
        );
      dy =
        int(
          (mouseY - GRID_OFFSET_Y)
          -
          (mouseY - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR
        );
    }
    else if (ROTATE_FACTOR == 180) {
      //println("(SCREEN_WIDTH - mouseX + GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR=" + ((SCREEN_WIDTH - mouseX + GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR));
      //println("(SCREEN_WIDTH - mouseX + GRID_OFFSET_X)=" + ((SCREEN_WIDTH - mouseX + GRID_OFFSET_X)));
      dx = 
        int(
          (SCREEN_WIDTH - mouseX + GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR
          -
          (SCREEN_WIDTH - mouseX + GRID_OFFSET_X)
        );
      dy =
        int(
          (mouseY - SCREEN_HEIGHT / 2 - GRID_OFFSET_Y)
          -
          (mouseY - SCREEN_HEIGHT / 2 - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR
        );
    }
    else //if (ROTATE_FACTOR == 270)
    {
      //println("(SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR=" + ((SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR));
      //println("(SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y)=" + ((SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y)));
      dx = 
        int(
          (mouseX - SCREEN_WIDTH / 2 - GRID_OFFSET_X)
          -
          (mouseX - SCREEN_WIDTH / 2 - GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR
        );
      dy =
        int(
          (SCREEN_HEIGHT - mouseY + GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR
          -
          (SCREEN_HEIGHT - mouseY + GRID_OFFSET_Y)
        );
    }
    GRID_OFFSET_X += dx;
    GRID_OFFSET_Y += dy;
    //println("dx=" + dx + ", dy=" + dy);
  }
}