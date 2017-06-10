final static color C_COLORBAR_RECT_FILL = 0xC0F8F8F8; // White - 0x8 w/ Opaque 75%
final static color C_COLORBAR_RECT_STROKE = #000000; // Black
final static color C_COLORBAR_TEXT = #000000; // Black

void colorbar_draw_0()
{
  color c;
  int i;
  int pw;

  for(i = 0; i < SCREEN_HEIGHT; i ++) {
    pw = int(float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_HEIGHT) * float(i)) + DATA_MAX_PULSE_WIDTH;
    colorMode(HSB, DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    c =
      color(
        (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - pw) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(SCREEN_WIDTH - FONT_HEIGHT / 2, i, SCREEN_WIDTH, i);
  }
}

void colorbar_draw_90()
{
  color c;
  int i;
  int pw;

  for(i = 0; i < SCREEN_WIDTH; i ++) {
    pw = int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_WIDTH) * float(i)) + DATA_MIN_PULSE_WIDTH;
    colorMode(HSB, DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    c =
      color(
        (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - pw) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    //print("[" + i + "]=" + p + "," + (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 3.0 / 4.0) - p)%(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) + " ");
    //print("[" + i + "]=" + p + "," + hue(c) + " ");
    colorMode(RGB, 255);
//    print(i + "=" +
//      p + "," + 
//      int(hue(c)) + ":" +
//      (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - p) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1) + "," +
//      int(red(c)) + ":" + int(green(c)) + ":" + int(blue(c)) + " ");
    fill(c);
    stroke(c);
    line(i, SCREEN_HEIGHT - FONT_HEIGHT / 2, i, SCREEN_HEIGHT);
  }
}

void colorbar_draw_180()
{
  color c;
  int i;
  int pw;

  for(i = 0; i < SCREEN_HEIGHT; i ++) {
    pw = int(float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_HEIGHT) * float(i)) + DATA_MAX_PULSE_WIDTH;
    //print("[" + i + "]=" + p + " ");
    colorMode(HSB, DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    c =
      color(
        (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - pw) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(0, i, FONT_HEIGHT / 2, i);
  }
}

void colorbar_draw_270()
{
  color c;
  int i;
  int pw;

  for(i = 0; i < SCREEN_WIDTH; i ++) {
    pw = int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_WIDTH) * float(i)) + DATA_MIN_PULSE_WIDTH;
    //print("[" + i + "]=" + p + " ");
    colorMode(HSB, DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    c =
      color(
        (DATA_MAX_PULSE_WIDTH + int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) * 5.0 / 6.0) - pw) % (DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH + 1),
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH,
        DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH);
    colorMode(RGB, 255);
    
    fill(c);
    stroke(c);
    line(i, 0, i, FONT_HEIGHT / 2);
  }
}

void colorbar_info_draw_0()
{
  int pw;
  String string;
  int x, y, w, h, tl = 5, tr = 5, br = 0, bl = 5;

  // Check mouse pointer over color bar.  
  if( mouseX >= SCREEN_WIDTH - FONT_HEIGHT / 2 &&
      BUBBLEINFO_DISPLAY == false ) {
    // Display pulse width
    pw = int(float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_HEIGHT) * mouseY) + DATA_MAX_PULSE_WIDTH;
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
  if( mouseY >= SCREEN_HEIGHT - FONT_HEIGHT / 2 &&
      BUBBLEINFO_DISPLAY == false ) {
    // Display pulse width
    pw = int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_WIDTH) * mouseX) + DATA_MIN_PULSE_WIDTH;
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
    pw = int(float(DATA_MIN_PULSE_WIDTH - DATA_MAX_PULSE_WIDTH) / float(SCREEN_HEIGHT) * mouseY) + DATA_MAX_PULSE_WIDTH;
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
    pw = int(float(DATA_MAX_PULSE_WIDTH - DATA_MIN_PULSE_WIDTH) / float(SCREEN_WIDTH) * mouseX) + DATA_MIN_PULSE_WIDTH;
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