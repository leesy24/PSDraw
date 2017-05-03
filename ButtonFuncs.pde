//final boolean PRINT_ButtonFunc = true; 
final boolean PRINT_ButtonFunc = false;

int button_zoom_minus_x, button_zoom_minus_y;      // Position of square button zoom minus
int button_zoom_minus_width, button_zoom_minus_height;     // Diameter of rect
boolean button_zoom_minus_over = false;
int button_zoom_pluse_x, button_zoom_pluse_y;      // Position of square button zoom pluse
int button_zoom_pluse_width, button_zoom_pluse_height;     // Diameter of rect
boolean button_zoom_pluse_over = false;
int button_rotate_ccw_x, button_rotate_ccw_y;      // Position of square button rotate counter clock-wise
int button_rotate_ccw_width, button_rotate_ccw_height;     // Diameter of rect
boolean button_rotate_ccw_over = false;
int button_rotate_cw_x, button_rotate_cw_y;      // Position of square button rotate clock-wise
int button_rotate_cw_width, button_rotate_cw_height;     // Diameter of rect
boolean button_rotate_cw_over = false;
int button_mirror_en_x, button_mirror_en_y;      // Position of square button mirror enable
int button_mirror_en_width, button_mirror_en_height;     // Diameter of rect
boolean button_mirror_en_over = false;
int button_reset_en_x, button_reset_en_y;      // Position of square button reset enable
int button_reset_en_width, button_reset_en_height;     // Diameter of rect
boolean button_reset_en_over = false;
color button_highlight;
color button_color, button_base_color;

void button_setup()
{
  button_zoom_minus_width = FONT_HEIGHT * 2;
  button_zoom_minus_height = FONT_HEIGHT * 2;
  button_zoom_minus_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  button_zoom_minus_y = SCREEN_HEIGHT - button_zoom_minus_height - TEXT_MARGIN - FONT_HEIGHT * 1;

  button_zoom_pluse_width = FONT_HEIGHT * 2;
  button_zoom_pluse_height = FONT_HEIGHT * 2;
  button_zoom_pluse_x = TEXT_MARGIN + FONT_HEIGHT * 3;
  button_zoom_pluse_y = SCREEN_HEIGHT - button_zoom_pluse_height - TEXT_MARGIN - FONT_HEIGHT * 3;

  button_rotate_ccw_width = FONT_HEIGHT * 2;
  button_rotate_ccw_height = FONT_HEIGHT * 2;
  button_rotate_ccw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  button_rotate_ccw_y = SCREEN_HEIGHT - button_rotate_ccw_height - TEXT_MARGIN - FONT_HEIGHT * 1;

  button_rotate_cw_width = FONT_HEIGHT * 2;
  button_rotate_cw_height = FONT_HEIGHT * 2;
  button_rotate_cw_x = TEXT_MARGIN + FONT_HEIGHT * 6;
  button_rotate_cw_y = SCREEN_HEIGHT - button_rotate_cw_height - TEXT_MARGIN - FONT_HEIGHT * 3;

  button_mirror_en_width = FONT_HEIGHT * 2;
  button_mirror_en_height = FONT_HEIGHT * 2;
  button_mirror_en_x = TEXT_MARGIN + FONT_HEIGHT * 9;
  button_mirror_en_y = SCREEN_HEIGHT - button_mirror_en_height - TEXT_MARGIN - FONT_HEIGHT * 1;

  button_reset_en_width = FONT_HEIGHT * 2;
  button_reset_en_height = FONT_HEIGHT * 2;
  button_reset_en_x = TEXT_MARGIN + FONT_HEIGHT * 12;
  button_reset_en_y = SCREEN_HEIGHT - button_mirror_en_height - TEXT_MARGIN - FONT_HEIGHT * 1;

  button_color = color(0);
  button_highlight = color(51);
  button_base_color = color(102);
}

void button_draw()
{
  String string;

  // Sets the color used to draw lines and borders around shapes.
  stroke(255);

  if (button_zoom_minus_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_zoom_minus_x, button_zoom_minus_y, button_zoom_minus_width, button_zoom_minus_height);
  fill(255);
  string = "-";
  text(string, button_zoom_minus_x + button_zoom_minus_width / 2 - int(textWidth(string)) / 2, button_zoom_minus_y + button_zoom_minus_height / 2 + FONT_HEIGHT / 2);

  if (button_zoom_pluse_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_zoom_pluse_x, button_zoom_pluse_y, button_zoom_pluse_width, button_zoom_pluse_height);
  fill(255);
  string = "+";
  text(string, button_zoom_pluse_x + button_zoom_pluse_width / 2 - int(textWidth(string)) / 2, button_zoom_pluse_y + button_zoom_pluse_height / 2 + FONT_HEIGHT / 2);

  string = "Zoom";
  text(string, button_zoom_pluse_x + button_zoom_pluse_width / 2 - int(textWidth(string)) / 2, button_zoom_pluse_y - FONT_HEIGHT / 2);

  if (button_rotate_ccw_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_rotate_ccw_x, button_rotate_ccw_y, button_rotate_ccw_width, button_rotate_ccw_height);
  fill(255);
  string = "↺";
  text(string, button_rotate_ccw_x + button_rotate_ccw_width / 2 - int(textWidth(string)) / 2, button_rotate_ccw_y + button_rotate_ccw_height / 2 + FONT_HEIGHT / 2);

  if (button_rotate_cw_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_rotate_cw_x, button_rotate_cw_y, button_rotate_cw_width, button_rotate_cw_height);
  fill(255);
  string = "↻";
  text(string, button_rotate_cw_x + button_rotate_cw_width / 2 - int(textWidth(string)) / 2, button_rotate_cw_y + button_rotate_cw_height / 2 + FONT_HEIGHT / 2);

  string = "Rotate";
  text(string, button_rotate_cw_x + button_rotate_cw_width / 2 - int(textWidth(string)) / 2, button_rotate_cw_y - FONT_HEIGHT / 2);

  if (button_mirror_en_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_mirror_en_x, button_mirror_en_y, button_mirror_en_width, button_mirror_en_height);
  fill(255);
  if (ROTATE_FACTOR == 0 || ROTATE_FACTOR == 180)  string = "⇅";
  else string = "⇄";
  text(string, button_mirror_en_x + button_mirror_en_width / 2 - int(textWidth(string)) / 2, button_mirror_en_y + button_mirror_en_height / 2 + FONT_HEIGHT / 2);
  string = "Mirror";
  text(string, button_mirror_en_x + button_mirror_en_width / 2 - int(textWidth(string)) / 2, button_mirror_en_y - FONT_HEIGHT / 2);

  if (button_reset_en_over) {
    fill( button_highlight);
  } else {
    fill( button_color);
  }
  rect(button_reset_en_x, button_reset_en_y, button_reset_en_width, button_reset_en_height);
  fill(255);
  string = "0";
  text(string, button_reset_en_x + button_reset_en_width / 2 - int(textWidth(string)) / 2, button_reset_en_y + button_reset_en_height / 2 + FONT_HEIGHT / 2);
  string = "Reset";
  text(string, button_reset_en_x + button_reset_en_width / 2 - int(textWidth(string)) / 2, button_reset_en_y - FONT_HEIGHT / 2);
}

void button_update() {
  if ( button_check_over(button_zoom_minus_x, button_zoom_minus_y, button_zoom_minus_width, button_zoom_minus_height) ) {
    button_zoom_minus_over = true;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
    button_reset_en_over = false;
  }
  else if ( button_check_over(button_zoom_pluse_x, button_zoom_pluse_y, button_zoom_pluse_width, button_zoom_pluse_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = true;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
    button_reset_en_over = false;
  }
  else if ( button_check_over(button_rotate_ccw_x, button_rotate_ccw_y, button_rotate_ccw_width, button_rotate_ccw_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = true;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
    button_reset_en_over = false;
  }
  else if ( button_check_over(button_rotate_cw_x, button_rotate_cw_y, button_rotate_cw_width, button_rotate_cw_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = true;
    button_mirror_en_over = false;
    button_reset_en_over = false;
  }
  else if ( button_check_over(button_mirror_en_x, button_mirror_en_y, button_mirror_en_width, button_mirror_en_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = true;
    button_reset_en_over = false;
  }
  else if ( button_check_over(button_reset_en_x, button_reset_en_y, button_reset_en_width, button_reset_en_height) ) {
    button_zoom_minus_over = false;
    button_zoom_pluse_over = false;
    button_rotate_ccw_over = false;
    button_rotate_cw_over = false;
    button_mirror_en_over = false;
    button_reset_en_over = true;
  }
  else {
    button_zoom_minus_over =
    button_zoom_pluse_over =
    button_rotate_ccw_over =
    button_rotate_cw_over =
    button_mirror_en_over =
    button_reset_en_over =
    false;
  }
}

void button_zoom_minus() {
  if (ZOOM_FACTOR <= 3000.0) {
    if (ZOOM_FACTOR < 100.0) ZOOM_FACTOR += 10.0;
    else ZOOM_FACTOR = int(ZOOM_FACTOR + ZOOM_FACTOR / 10.0 + 5.0) / 10 * 10;
  }
  if (PRINT_ButtonFunc) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
}

void button_zoom_pluse() {
  if (ZOOM_FACTOR > 10.0) {
    if (ZOOM_FACTOR < 100.0) ZOOM_FACTOR -= 10.0;
    else ZOOM_FACTOR = int(ZOOM_FACTOR - ZOOM_FACTOR / 10.0 + 5.0) / 10 * 10;
  }
  if (PRINT_ButtonFunc) println("ZOOM_FACTOR=" + ZOOM_FACTOR);
}

boolean button_check_over(int x, int y, int width, int height) {
  if (mouseX >= x && mouseX <= x+width && 
    mouseY >= y && mouseY <= y+height) {
    return true;
  } else {
    return false;
  }
}