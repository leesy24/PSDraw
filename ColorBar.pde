final static color C_COLORBAR_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
final static color C_COLORBAR_RECT_STROKE = #000000; // Black
final static color C_COLORBAR_TEXT = #000000; // Black

void colorbar_draw_0()
{
  color c;
  int i;
  int pw;
  final float pw_const = float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_height);
  final int color_HSB_max_const = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH;
  final int color_H_offset = DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0);
  final int color_H_modular = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1;
  final int x_const = SCREEN_width - FONT_HEIGHT / 2;

  for(i = 0; i < SCREEN_height; i ++) {
    pw = int(pw_const * float(i)) + DATA_MAX_PULSE_WIDTH;
    colorMode(HSB, color_HSB_max_const);
    c =
      color(
        (color_H_offset - pw) % color_H_modular,
        color_HSB_max_const,
        color_HSB_max_const);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(x_const, i, SCREEN_width, i);
  }
}

void colorbar_draw_90()
{
  color c;
  int i;
  int pw;
  final float pw_const = float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_width);
  final int color_HSB_max_const = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH;
  final int color_H_offset = DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0);
  final int color_H_modular = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1;
  final int y_const = SCREEN_height - FONT_HEIGHT / 2;

  for(i = 0; i < SCREEN_width; i ++) {
    pw = int(pw_const * float(i)) + DATA_MIN_PULSE_WIDTH;
    colorMode(HSB, color_HSB_max_const);
    c =
      color(
        (color_H_offset - pw) % color_H_modular,
        color_HSB_max_const,
        color_HSB_max_const);
    colorMode(RGB, 255);
    fill(c);
    stroke(c);
    line(i, y_const, i, SCREEN_height);
  }
}

void colorbar_draw_180()
{
  color c;
  int i;
  int pw;
  final float pw_const = float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_height);
  final int color_HSB_max_const = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH;
  final int color_H_offset = DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0);
  final int color_H_modular = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1;
  final int x_const = FONT_HEIGHT / 2;


  for(i = 0; i < SCREEN_height; i ++) {
    pw = int(pw_const * float(i)) + DATA_MAX_PULSE_WIDTH;
    //print("[" + i + "]=" + p + " ");
    colorMode(HSB, color_HSB_max_const);
    c =
      color(
        (color_H_offset - pw) % color_H_modular,
        color_HSB_max_const,
        color_HSB_max_const);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(0, i, x_const, i);
  }
}

void colorbar_draw_270()
{
  color c;
  int i;
  int pw;
  final float pw_const = float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_width);
  final int color_HSB_max_const = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH;
  final int color_H_offset = DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0);
  final int color_H_modular = DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1;
  final int y_const = FONT_HEIGHT / 2;

  for(i = 0; i < SCREEN_width; i ++) {
    pw = int(pw_const * float(i)) + DATA_MIN_PULSE_WIDTH;
    //print("[" + i + "]=" + p + " ");
    colorMode(HSB, color_HSB_max_const);
    c =
      color(
        (color_H_offset - pw) % color_H_modular,
        color_HSB_max_const,
        color_HSB_max_const);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(i, 0, i, y_const);
  }
}

void colorbar_info_draw_0()
{
  int pw;
  String string;
  int x, y, w, h, tl = 5, tr = 5, br = 0, bl = 5;

  // Check mouse pointer over color bar.  
  if( mouseX >= SCREEN_width - FONT_HEIGHT / 2 &&
      BUBBLEINFO_DISPLAY == false ) {
    // Display pulse width
    pw = int(float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_height) * mouseY) + DATA_MAX_PULSE_WIDTH;
    string = "Pulse width:" + pw;
    w = int(textWidth(string));
    w += TEXT_MARGIN + TEXT_MARGIN;
    h = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;
    x = mouseX - w;
    y = mouseY - h;
    if(y < 0) {
      br = 5;
      tr = 0;
      y = mouseY;
    }
    // Sets the color used to draw box and borders around shapes.
    fill(C_COLORBAR_RECT_FILL);
    stroke(C_COLORBAR_RECT_STROKE);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_COLORBAR_TEXT);
    stroke(C_COLORBAR_TEXT);
    text(string, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 1);
  }
}

void colorbar_info_draw_90()
{
  int pw;
  String string;
  int x, y, w, h, tl = 5, tr = 5, br = 0, bl = 5;

  // Check mouse pointer over color bar.  
  if( mouseY >= SCREEN_height - FONT_HEIGHT / 2 &&
      BUBBLEINFO_DISPLAY == false ) {
    // Display pulse width
    pw = int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_width) * mouseX) + DATA_MIN_PULSE_WIDTH;
    string = "Pulse width:" + pw;
    w = int(textWidth(string));
    w += TEXT_MARGIN + TEXT_MARGIN;
    h = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;
    x = mouseX - w;
    y = mouseY - h;
    if(x < 0) {
      br = 5;
      bl = 0;
      x = mouseX;
    }
    // Sets the color used to draw box and borders around shapes.
    fill(C_COLORBAR_RECT_FILL);
    stroke(C_COLORBAR_RECT_STROKE);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_COLORBAR_TEXT);
    stroke(C_COLORBAR_TEXT);
    text(string, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 1);
  }
}

void colorbar_info_draw_180()
{
  int pw;
  String string;
  int x, y, w, h, tl = 5, tr = 5, br = 5, bl = 0;

  // Check mouse pointer over color bar.  
  if( mouseX <= FONT_HEIGHT / 2 &&
      BUBBLEINFO_DISPLAY == false ) {
    // Display pulse width
    pw = int(float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_height) * mouseY) + DATA_MAX_PULSE_WIDTH;
    string = "Pulse width:" + pw;
    w = int(textWidth(string));
    w += TEXT_MARGIN + TEXT_MARGIN;
    h = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;
    x = mouseX;
    y = mouseY - h;
    if(y < 0) {
      bl = 5;
      tl = 0;
      y = mouseY;
    }
    // Sets the color used to draw box and borders around shapes.
    fill(C_COLORBAR_RECT_FILL);
    stroke(C_COLORBAR_RECT_STROKE);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_COLORBAR_TEXT);
    stroke(C_COLORBAR_TEXT);
    text(string, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 1);
  }
}

void colorbar_info_draw_270()
{
  int pw;
  String string;
  int x, y, w, h, tl = 5, tr = 0, br = 5, bl = 5;

  // Check mouse pointer over color bar.  
  if( mouseY <= FONT_HEIGHT / 2 &&
      BUBBLEINFO_DISPLAY == false ) {
    // Display pulse width
    pw = int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_width) * mouseX) + DATA_MIN_PULSE_WIDTH;
    string = "Pulse width:" + pw;
    w = int(textWidth(string));
    w += TEXT_MARGIN + TEXT_MARGIN;
    h = TEXT_MARGIN + FONT_HEIGHT * 1 + TEXT_MARGIN;
    x = mouseX - w;
    y = mouseY;
    if(x < 0) {
      tr = 5;
      tl = 0;
      x = mouseX;
    }
    // Sets the color used to draw box and borders around shapes.
    fill(C_COLORBAR_RECT_FILL);
    stroke(C_COLORBAR_RECT_STROKE);
    rect(x, y, w, h, tl, tr, br, bl);
    // Sets the color used to draw text and borders around shapes.
    fill(C_COLORBAR_TEXT);
    stroke(C_COLORBAR_TEXT);
    text(string, x + TEXT_MARGIN, y + TEXT_MARGIN + FONT_HEIGHT * 1);
  }
}

void colorbar_draw()
{
  if (ROTATE_FACTOR == 0) {
    colorbar_draw_0();
  } else if (ROTATE_FACTOR == 90) {
    colorbar_draw_90();
  } else if (ROTATE_FACTOR == 180) {
    colorbar_draw_180();
  } else /*if (ROTATE_FACTOR == 270)*/ {
    colorbar_draw_270();
  }
}

void colorbar_info_draw()
{
  if (ROTATE_FACTOR == 0) {
    colorbar_info_draw_0();
  } else if (ROTATE_FACTOR == 90) {
    colorbar_info_draw_90();
  } else if (ROTATE_FACTOR == 180) {
    colorbar_info_draw_180();
  } else /*if (ROTATE_FACTOR == 270)*/ {
    colorbar_info_draw_270();
  }
}