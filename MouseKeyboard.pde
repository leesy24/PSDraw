import java.awt.event.KeyEvent;

//final static boolean PRINT_MOUSEFUNC_DBG_ALL = true;
final static boolean PRINT_MOUSEFUNC_DBG_ALL = false;

//final static boolean PRINT_MOUSEFUNC_DBG_POS = true;
final static boolean PRINT_MOUSEFUNC_DBG_POS = false;

//final static boolean PRINT_MOUSEFUNC_Pressed = true; 
final static boolean PRINT_MOUSEFUNC_Pressed = false;

//final static boolean PRINT_MOUSEFUNC_Released = true; 
final static boolean PRINT_MOUSEFUNC_Released = false;

//final static boolean PRINT_MOUSEFUNC_Dragged = true; 
final static boolean PRINT_MOUSEFUNC_Dragged = false;

//final static boolean PRINT_MOUSEFUNC_Wheel = true; 
final static boolean PRINT_MOUSEFUNC_Wheel = false;

boolean mousePressed = false;
int mousePressedX;
int mousePressedY;

/**/
void keyPressed()
{
  //println("keyPressed " + int(key) + " " + keyCode);
  if(key == CODED)
  {
    if(keyCode == KeyEvent.VK_F10)
    {
      UDP_get_src_ip_port_enable = !UDP_get_src_ip_port_enable;
      SN_get_src_ip_port_enable = !SN_get_src_ip_port_enable;
    }
    else if(keyCode == KeyEvent.VK_F9)
    {
      UART_get_take_time_enable = !UART_get_take_time_enable;
      UDP_get_take_time_enable = !UDP_get_take_time_enable;
      SN_get_take_time_enable = !SN_get_take_time_enable;
    } 
    else if(keyCode == KeyEvent.VK_F8)
    {
      DATA_draw_params_enable = !DATA_draw_params_enable;
    } 
  }
}
/**/
/*
void keyTyped()
{
  println("keyTyped " + int(key) + " " + keyCode);
}
*/
/*
void keyReleased()
{
  println("released " + int(key) + " " + keyCode);
}
*/

void mousePressed()
{
  if (PRINT_MOUSEFUNC_Pressed || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse pressed! ");

  if (PRINT_MOUSEFUNC_Pressed || PRINT_MOUSEFUNC_DBG_ALL || PRINT_MOUSEFUNC_DBG_POS) println("mouseX=" + mouseX + ", mouseY=" + mouseY);
  //if (PRINT_MOUSEFUNC_Pressed) println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);

  mousePressedX = mouseX - GRID_OFFSET_X;
  mousePressedY = mouseY - GRID_OFFSET_Y;
  mousePressed = true;

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
      GRID_OFFSET_X =  int(save_oy - (float(SCREEN_height) / 2.0) + (float(SCREEN_width)  / 2.0));
      GRID_OFFSET_Y = -int(save_ox);
    }
    else if (ROTATE_FACTOR == 90) { // OK
      GRID_OFFSET_Y = -int(save_ox + (float(SCREEN_width)  / 2.0) - (float(SCREEN_height) / 2.0));
      GRID_OFFSET_X =  int(save_oy);
    }
    else if (ROTATE_FACTOR == 180) { // OK
      GRID_OFFSET_X =  int(save_oy + (float(SCREEN_height) / 2.0) - (float(SCREEN_width)  / 2.0));
      GRID_OFFSET_Y = -int(save_ox);
    }
    else /*if (ROTATE_FACTOR == 270)*/ { // OK
      GRID_OFFSET_Y = -int(save_ox - (float(SCREEN_width)  / 2.0) + (float(SCREEN_height) / 2.0));
      GRID_OFFSET_X =  int(save_oy);
    }
    if (PRINT_MOUSEFUNC_Pressed) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
    grid_ready();
    config_save();
  }
  if (button_rotate_cw_over) {
    float save_ox, save_oy;
    ROTATE_FACTOR += 90;
    if (ROTATE_FACTOR == 360) ROTATE_FACTOR = 0;
    save_ox = float(GRID_OFFSET_X);
    save_oy = float(GRID_OFFSET_Y);
    if (ROTATE_FACTOR == 0) { // OK
      GRID_OFFSET_X = -int(save_oy + (float(SCREEN_height) / 2.0) - (float(SCREEN_width)  / 2.0));
      GRID_OFFSET_Y =  int(save_ox);
    }
    else if (ROTATE_FACTOR == 90) { // OK
      GRID_OFFSET_Y =  int(save_ox - (float(SCREEN_width)  / 2.0) + (float(SCREEN_height) / 2.0));
      GRID_OFFSET_X = -int(save_oy);
    }
    else if (ROTATE_FACTOR == 180) { // OK
      GRID_OFFSET_X = -int(save_oy - (float(SCREEN_height) / 2.0) + (float(SCREEN_width)  / 2.0));
      GRID_OFFSET_Y =  int(save_ox);
    }
    else /*if (ROTATE_FACTOR == 270)*/ { // OK
      GRID_OFFSET_Y =  int(save_ox + (float(SCREEN_width)  / 2.0) - (float(SCREEN_height) / 2.0));
      GRID_OFFSET_X = -int(save_oy);
    }
    if (PRINT_MOUSEFUNC_Pressed) println("ROTATE_FACTOR=" + ROTATE_FACTOR);
    grid_ready();
    config_save();
  }
  //println("new GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);

  if (button_mirror_en_over) {
    MIRROR_ENABLE = !MIRROR_ENABLE;
    if (PRINT_MOUSEFUNC_Pressed) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
    grid_ready();
    config_save();
  }

  if (button_reset_en_over) {
    if (PRINT_MOUSEFUNC_Pressed) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
    if (PRINT_MOUSEFUNC_Pressed) println("MIRROR_ENABLE=" + MIRROR_ENABLE);
    if (PRINT_MOUSEFUNC_Pressed) println("GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    GRID_OFFSET_X = GRID_OFFSET_Y = 0;
    MIRROR_ENABLE = false;
    ZOOM_FACTOR = 100;
    grid_ready();
    config_save();
  }
}

void mouseReleased()
{
  if (PRINT_MOUSEFUNC_Released || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse released! ");
  interface_mouseReleased();
  mousePressed = false;
}

void mouseDragged() 
{
  if (PRINT_MOUSEFUNC_Dragged || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse dragged!");
  if (PRINT_MOUSEFUNC_Dragged || PRINT_MOUSEFUNC_DBG_ALL || PRINT_MOUSEFUNC_DBG_POS) println("\t mouseX=" + mouseX + ", mouseY=" + mouseY);
  if (PRINT_MOUSEFUNC_Dragged) println("\t mousePressedX=" + mousePressedX + ", mousePressedY=" + mousePressedY);
  if (mousePressed == true)
  {
    GRID_OFFSET_X = mouseX - mousePressedX;
    GRID_OFFSET_Y = mouseY - mousePressedY;
    config_save();
  }
  if (PRINT_MOUSEFUNC_Dragged) println("\t GRID_OFFSET_X:" + GRID_OFFSET_X + ", GRID_OFFSET_Y:" + GRID_OFFSET_Y);
}

void mouseWheel(MouseEvent event)
{
  int wheel_count = event.getCount();
  //float zoom_factor_save = ZOOM_FACTOR;
  int zoom_factor_save = ZOOM_FACTOR;

  if (PRINT_MOUSEFUNC_Wheel || PRINT_MOUSEFUNC_DBG_ALL) println("Mouse wheeled! count=" + wheel_count);

  if (wheel_count > 0)
  {
    for (; wheel_count > 0; wheel_count -= 1)
    {  
      button_zoom_minus();
    }
  }
  else if (wheel_count < 0)
  {
    for (; wheel_count < 0; wheel_count += 1)
    {  
      button_zoom_pluse();
    }
  }

  // Check zoom factor changed.
  if (zoom_factor_save != ZOOM_FACTOR)
  {
    //final float const_x_base = (ROTATE_FACTOR == 180)?float(SCREEN_width + GRID_OFFSET_X - mouseX):float(mouseX - GRID_OFFSET_X);
    //final float const_y_base = (ROTATE_FACTOR == 270)?float(SCREEN_height + GRID_OFFSET_Y - mouseY):float(mouseY - GRID_OFFSET_Y);
    final int const_x_base = (ROTATE_FACTOR == 180)?(SCREEN_width + GRID_OFFSET_X - mouseX):(mouseX - GRID_OFFSET_X);
    final int const_y_base = (ROTATE_FACTOR == 270)?(SCREEN_height + GRID_OFFSET_Y - mouseY):(mouseY - GRID_OFFSET_Y);
    //final float const_x_offset = (ROTATE_FACTOR == 0 || ROTATE_FACTOR == 180)?(float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0):(float(SCREEN_width) / 2.0);
    //final float const_y_offset = (ROTATE_FACTOR == 90 || ROTATE_FACTOR == 270)?(float(TEXT_MARGIN) + float(FONT_HEIGHT) / 2.0):(float(SCREEN_height) / 2.0);
    //final float const_x_offset = (ROTATE_FACTOR == 0 || ROTATE_FACTOR == 180)?float(TEXT_MARGIN + FONT_HEIGHT / 2):float(SCREEN_width / 2);
    //final float const_y_offset = (ROTATE_FACTOR == 90 || ROTATE_FACTOR == 270)?float(TEXT_MARGIN + FONT_HEIGHT / 2):float(SCREEN_height / 2);
    final int const_x_offset = (ROTATE_FACTOR == 0 || ROTATE_FACTOR == 180)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_width / 2);
    final int const_y_offset = (ROTATE_FACTOR == 90 || ROTATE_FACTOR == 270)?(TEXT_MARGIN + FONT_HEIGHT / 2):(SCREEN_height / 2);
    final float const_x_ratio = (ROTATE_FACTOR == 180)?(float(zoom_factor_save) / float(ZOOM_FACTOR) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR));
    final float const_y_ratio = (ROTATE_FACTOR == 270)?(float(zoom_factor_save) / float(ZOOM_FACTOR) - 1.0):(1.0 - float(zoom_factor_save) / float(ZOOM_FACTOR));

    //println("old ZOOM_FACTOR=" + zoom_factor_save + ", new ZOOM_FACTOR=" + ZOOM_FACTOR);
    //println("SCREEN_width - mouseX=" + (SCREEN_width - mouseX) + ", mouseY=" + mouseY);
    //println("GRID_OFFSET_X=" + GRID_OFFSET_X + ", GRID_OFFSET_Y=" + GRID_OFFSET_Y);
    //println("(SCREEN_height - mouseY - GRID_OFFSET_Y) * const_ratio=" + ((SCREEN_height - mouseY - GRID_OFFSET_Y) * const_ratio));
    //println("(SCREEN_height - mouseY - GRID_OFFSET_Y)=" + ((SCREEN_height - mouseY - GRID_OFFSET_Y)));

    GRID_OFFSET_X += int((const_x_base - const_x_offset) * const_x_ratio);
    GRID_OFFSET_Y += int((const_y_base - const_y_offset) * const_y_ratio);

    config_save();
  }
}
