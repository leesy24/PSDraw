//final boolean PRINT_MouseFunc_Pressed = true; 
final boolean PRINT_MouseFunc_Pressed = false;

//final boolean PRINT_MouseFunc_Released = true; 
final boolean PRINT_MouseFunc_Released = false;

//final boolean PRINT_MouseFunc_Dragged = true; 
final boolean PRINT_MouseFunc_Dragged = false;

//final boolean PRINT_MouseFunc_Wheel = true; 
final boolean PRINT_MouseFunc_Wheel = false;

int mouseXPressed = -1; 
int mouseYPressed = -1; 

void mousePressed() {
  if (PRINT_MouseFunc_Pressed) println("Mouse pressed! ");

  if (PRINT_MouseFunc_Pressed) println("mouseX=" + mouseX + ", mouseY=" + mouseY);
  //if (PRINT_MouseFunc_Pressed) println("SCREEN_WIDTH - mouseX=" + (SCREEN_WIDTH - mouseX) + ", mouseY=" + mouseY);

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
    float save_ox, save_oy;
    ROTATE_FACTOR -= 90;
    if (ROTATE_FACTOR == -90) ROTATE_FACTOR = 270;
    save_ox = float(GRID_OFFSET_X);
    save_oy = float(GRID_OFFSET_Y);
    if (ROTATE_FACTOR == 0) { // OK
      GRID_OFFSET_X =  int(save_oy - (float(SCREEN_HEIGHT) / 2.0) + (float(SCREEN_WIDTH)  / 2.0));
      GRID_OFFSET_Y = -int(save_ox);
    }
    else if (ROTATE_FACTOR == 90) { // OK
      GRID_OFFSET_Y = -int(save_ox + (float(SCREEN_WIDTH)  / 2.0) - (float(SCREEN_HEIGHT) / 2.0));
      GRID_OFFSET_X =  int(save_oy);
    }
    else if (ROTATE_FACTOR == 180) { // OK
      GRID_OFFSET_X =  int(save_oy + (float(SCREEN_HEIGHT) / 2.0) - (float(SCREEN_WIDTH)  / 2.0));
      GRID_OFFSET_Y = -int(save_ox);
    }
    else /*if (ROTATE_FACTOR == 270)*/ { // OK
      GRID_OFFSET_Y = -int(save_ox - (float(SCREEN_WIDTH)  / 2.0) + (float(SCREEN_HEIGHT) / 2.0));
      GRID_OFFSET_X =  int(save_oy);
    }
    if (PRINT_MouseFunc_Pressed) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
  }
  if (button_rotate_cw_over) {
    float save_ox, save_oy;
    ROTATE_FACTOR += 90;
    if (ROTATE_FACTOR == 360) ROTATE_FACTOR = 0;
    save_ox = float(GRID_OFFSET_X);
    save_oy = float(GRID_OFFSET_Y);
    if (ROTATE_FACTOR == 0) { // OK
      GRID_OFFSET_X = -int(save_oy + (float(SCREEN_HEIGHT) / 2.0) - (float(SCREEN_WIDTH)  / 2.0));
      GRID_OFFSET_Y =  int(save_ox);
    }
    else if (ROTATE_FACTOR == 90) { // OK
      GRID_OFFSET_Y =  int(save_ox - (float(SCREEN_WIDTH)  / 2.0) + (float(SCREEN_HEIGHT) / 2.0));
      GRID_OFFSET_X = -int(save_oy);
    }
    else if (ROTATE_FACTOR == 180) { // OK
      GRID_OFFSET_X = -int(save_oy - (float(SCREEN_HEIGHT) / 2.0) + (float(SCREEN_WIDTH)  / 2.0));
      GRID_OFFSET_Y =  int(save_ox);
    }
    else /*if (ROTATE_FACTOR == 270)*/ { // OK
      GRID_OFFSET_Y =  int(save_ox + (float(SCREEN_WIDTH)  / 2.0) - (float(SCREEN_HEIGHT) / 2.0));
      GRID_OFFSET_X = -int(save_oy);
    }
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
  mouseXPressed = -1;
  mouseYPressed = -1;
}

void mouseDragged() 
{
  if (PRINT_MouseFunc_Dragged) println("Mouse dragged!");
  if (PRINT_MouseFunc_Dragged) println("\t mouseX=" + mouseX + ", mouseY=" + mouseY);
  if (PRINT_MouseFunc_Dragged) println("\t mouseXPressed=" + mouseXPressed + ", mouseYPressed=" + mouseYPressed);
  if (mouseXPressed >= 0 && mouseYPressed >= 0) {
    GRID_OFFSET_X = mouseX - mouseXPressed;
    GRID_OFFSET_Y = mouseY - mouseYPressed;
  }
  if (PRINT_MouseFunc_Dragged) println("\t GRID_OFFSET_X:" + GRID_OFFSET_X + ", GRID_OFFSET_Y:" + GRID_OFFSET_Y);
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
          (
            mouseX - float(GRID_OFFSET_X)
            -
            (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
          )
          -
          (
            (
              mouseX - float(GRID_OFFSET_X)
              -
              (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
            )
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
        );
      dy =
        int(
          (mouseY - float(SCREEN_HEIGHT) / 2.0 - float(GRID_OFFSET_Y))
          -
          (
            (mouseY - float(SCREEN_HEIGHT) / 2.0 - float(GRID_OFFSET_Y))
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
        );
    }
    else if (ROTATE_FACTOR == 90) { // C
      dx = 
        int(
          (mouseX - float(SCREEN_WIDTH) / 2.0 - float(GRID_OFFSET_X))
          -
          (
            (mouseX - float(SCREEN_WIDTH) / 2.0 - float(GRID_OFFSET_X))
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
        );
      dy =
        int(
          (
            mouseY - float(GRID_OFFSET_Y)
            -
            (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
          )
          -
          (
            (
              mouseY - float(GRID_OFFSET_Y)
              -
              (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
            )
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
        );
    }
    else if (ROTATE_FACTOR == 180) {
      //println("(SCREEN_WIDTH - mouseX + GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR=" + ((SCREEN_WIDTH - mouseX + GRID_OFFSET_X) * zoom_factor_save / ZOOM_FACTOR));
      //println("(SCREEN_WIDTH - mouseX + GRID_OFFSET_X)=" + ((SCREEN_WIDTH - mouseX + GRID_OFFSET_X)));
      dx = 
        int(
          (
            (
              float(SCREEN_WIDTH) - mouseX + float(GRID_OFFSET_X)
              -
              (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
            )
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
          -
          (
            float(SCREEN_WIDTH) - mouseX + float(GRID_OFFSET_X)
            -
            (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
          )
        );
      dy =
        int(
          (mouseY - float(SCREEN_HEIGHT) / 2.0 - float(GRID_OFFSET_Y))
          -
          (
            (mouseY - float(SCREEN_HEIGHT) / 2.0 - float(GRID_OFFSET_Y))
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
        );
    }
    else //if (ROTATE_FACTOR == 270)
    {
      //println("(SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR=" + ((SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y) * zoom_factor_save / ZOOM_FACTOR));
      //println("(SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y)=" + ((SCREEN_HEIGHT - mouseY - GRID_OFFSET_Y)));
      dx = 
        int(
          (mouseX - float(SCREEN_WIDTH) / 2.0 - float(GRID_OFFSET_X))
          -
          (
            (mouseX - float(SCREEN_WIDTH) / 2.0 - float(GRID_OFFSET_X))
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
        );
      dy =
        int(
          (
            (
              float(SCREEN_HEIGHT) - mouseY + float(GRID_OFFSET_Y)
              -
              (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
            )
            *
            zoom_factor_save
            /
            ZOOM_FACTOR
          )
          -
          (
            float(SCREEN_HEIGHT) - mouseY + float(GRID_OFFSET_Y)
            -
            (float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0)
          )
        );
    }
    GRID_OFFSET_X += dx;
    GRID_OFFSET_Y += dy;
    //println("dx=" + dx + ", dy=" + dy);
  }
}