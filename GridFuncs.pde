//final static color C_GRID_LINE = #808080; // Black + 0x80
final static color C_GRID_LINE = #C0C0C0; // Black + 0xC0
final static color C_GRID_TEXT = #404040; // Black + 0x40
//final static color C_GRID_TEXT = #808080; //Black + 0x80

int GRID_OFFSET_X = 0;
int GRID_OFFSET_Y = 0;
PImage PS_image;

void grid_draw_rotate_0()
{
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  boolean even_flag = ((SCREEN_height / 100) % 2 == 0)?true:false;
  int offset_even_odd, offset;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_0_.png");
  }
  else {
    PS_image = loadImage("PS_0.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(even_flag)
    offset_even_odd = (SCREEN_height % 100) / 2 + (GRID_OFFSET_Y % 100);
  else
    offset_even_odd = (SCREEN_height % 100) / 2 + 50 + (GRID_OFFSET_Y % 100);
  for (iy = -1; iy <= SCREEN_height / 100 + 1; iy ++) {
    line(0,            iy * 100 + offset_even_odd,
         SCREEN_width, iy * 100 + offset_even_odd);
  }
  offset = TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_X % 100);
  for (ix = 0; ix <= SCREEN_width / 100 + 1; ix ++) {
    line(ix * 100 + offset, 0,
         ix * 100 + offset, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100));
  if(even_flag)
    offset_even_odd = (SCREEN_height % 100) / 2 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
  else
    offset_even_odd = (SCREEN_height % 100) / 2 + 50 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
  for (iy = -1; iy <= SCREEN_height / 100 + 1; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((iy - SCREEN_height / 100 / 2) * 100)
            )
            -
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_height / 100 / 2 - iy) * 100)
            )
            +
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    y = iy * 100 + offset_even_odd;
    x = TEXT_MARGIN + FONT_HEIGHT / 2 - int(textWidth(string) / 2.0) + GRID_OFFSET_X;
    if (x < TEXT_MARGIN) x = TEXT_MARGIN;
    if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_y = y - FONT_HEIGHT / 2;
    }
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100));
  y = SCREEN_height / 2 + FONT_HEIGHT / 2 + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = 0; ix <= SCREEN_width / 100 + 1; ix ++) {
    if ((int(ZOOM_FACTOR / 100.0 * float(ix * 100)) - offset) >= 0) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(ix * 100)
            )
            -
            offset
          )
          / 100.0
        )
        +
        "m";
      x = ix * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_x = ix * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_X % 100);
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw_rotate_90()
{
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  boolean even_flag = ((SCREEN_width / 100) % 2 == 0)?true:false;
  int offset_even_odd, offset;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_90_.png");
  }
  else {
    PS_image = loadImage("PS_90.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(even_flag)
    offset_even_odd = (SCREEN_width % 100) / 2 + (GRID_OFFSET_X % 100);
  else
    offset_even_odd = (SCREEN_width % 100) / 2 + 50 + (GRID_OFFSET_X % 100);
  for (ix = -1; ix <= SCREEN_width / 100 + 1; ix ++) {
    line(ix * 100 + offset_even_odd, 0,
         ix * 100 + offset_even_odd, SCREEN_height);
  }
  offset = TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
  for (iy = 0; iy <= SCREEN_height / 100 + 1; iy ++) {
    line(0,            iy * 100 + offset,
         SCREEN_width, iy * 100 + offset);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100));
  y = TEXT_MARGIN + FONT_HEIGHT + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = -1; ix <= SCREEN_width / 100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_width / 100 / 2 - ix) * 100)
            )
            +
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((ix - SCREEN_width / 100 / 2) * 100)
            )
            -
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    if(even_flag)
      x = ix * 100 + (SCREEN_width % 100) / 2 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    else
      x = ix * 100 + (SCREEN_width % 100) / 2 + 50 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_x = x + int(textWidth(string) / 2.0);
    }
    //println("ix=" + ix + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100));
  for (iy = 0; iy <= SCREEN_height / 100 + 1; iy ++) {
    if ((int(ZOOM_FACTOR / 100.0 * float(iy * 100)) - offset) >= 0) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(iy * 100)
            )
            -
            offset
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_width / 2 - int(textWidth(string)/2) + GRID_OFFSET_X;
      if (x < TEXT_MARGIN) x = TEXT_MARGIN;
      if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
      y = iy * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_y = iy * 100 + TEXT_MARGIN + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw_rotate_180()
{
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  boolean even_flag = ((SCREEN_height / 100) % 2 == 0)?true:false;
  int offset_even_odd, offset;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_180_.png");
  }
  else {
    PS_image = loadImage("PS_180.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(even_flag)
    offset_even_odd = (SCREEN_height % 100) / 2 + (GRID_OFFSET_Y % 100);
  else
    offset_even_odd = (SCREEN_height % 100) / 2 + 50 + (GRID_OFFSET_Y % 100);
  for (iy = -1; iy <= SCREEN_height / 100 + 1; iy ++) {
    line(0,            iy * 100 + offset_even_odd,
         SCREEN_width, iy * 100 + offset_even_odd);
  }
  offset = TEXT_MARGIN + FONT_HEIGHT / 2 - (GRID_OFFSET_X % 100);
  for (ix = 0; ix <= SCREEN_width / 100 + 1; ix ++) {
    line(SCREEN_width - ix * 100 - offset, 0,
         SCREEN_width - ix * 100 - offset, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100));
  if(even_flag)
    offset_even_odd = (SCREEN_height % 100) / 2 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
  else
    offset_even_odd = (SCREEN_height % 100) / 2 + 50 + FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
  for (iy = -1; iy <= SCREEN_height / 100 + 1; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_height / 100 / 2 - iy) * 100)
            )
            +
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((iy - SCREEN_height / 100 / 2) * 100)
            )
            -
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    y = iy * 100 + offset_even_odd;
    x = SCREEN_width - (TEXT_MARGIN + FONT_HEIGHT / 2) - int(textWidth(string) / 2.0) + GRID_OFFSET_X;
    if (x < TEXT_MARGIN) x = TEXT_MARGIN;
    if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_y = y - FONT_HEIGHT / 2;
    }
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100));
  y = SCREEN_height / 2 + FONT_HEIGHT / 2 + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = 0; ix <= SCREEN_width / 100 + 1; ix ++) {
    if ((int(ZOOM_FACTOR / 100.0 * float(ix * 100)) + offset) >= 0) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(ix * 100)
            )
            +
            offset
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_width - ix * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_x = SCREEN_width - ix * 100 - (TEXT_MARGIN + FONT_HEIGHT / 2) + (GRID_OFFSET_X % 100);
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw_rotate_270()
{
  String string;
  int x, y;
  int ix, iy;
  int image_x = -1, image_y = -1;
  boolean even_flag = ((SCREEN_width / 100) % 2 == 0)?true:false;
  int offset_even_odd, offset;

  // Images must be in the "data" directory to load correctly
  if (MIRROR_ENABLE) {
    PS_image = loadImage("PS_270_.png");
  }
  else {
    PS_image = loadImage("PS_270.png");
  }

  // Sets the color used to draw lines and borders around shapes.
  fill(C_GRID_LINE);
  stroke(C_GRID_LINE);
  if(even_flag)
    offset_even_odd = (SCREEN_width % 100) / 2 + (GRID_OFFSET_X % 100);
  else
    offset_even_odd = (SCREEN_width % 100) / 2 + 50 + (GRID_OFFSET_X % 100);
  for (ix = -1; ix <= SCREEN_width / 100 + 1; ix ++) {
    line(ix * 100 + offset_even_odd, 0,
         ix * 100 + offset_even_odd, SCREEN_height);
  }
  offset = TEXT_MARGIN + FONT_HEIGHT / 2 - (GRID_OFFSET_Y % 100);
  for (iy = 0; iy <= SCREEN_height / 100 + 1; iy ++) {
    line(0,            SCREEN_height - iy * 100 - offset,
         SCREEN_width, SCREEN_height - iy * 100 - offset);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_X / 100 * 100));
  y = SCREEN_height - TEXT_MARGIN + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = -1; ix <= SCREEN_width / 100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((ix - SCREEN_width / 100 / 2) * 100)
            )
            -
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    else {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float((SCREEN_width / 100 / 2 - ix) * 100)
            )
            +
            offset
          )
          /
          100.0
        )
        +
        "m";
    }
    if(even_flag)
      x = ix * 100 + (SCREEN_width % 100) / 2 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    else
      x = ix * 100 + (SCREEN_width % 100) / 2 + 50 - int(textWidth(string) / 2.0) + (GRID_OFFSET_X % 100);
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_x = x + int(textWidth(string) / 2.0);
    }
    //println("ix=" + ix + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  offset = int(ZOOM_FACTOR / 100.0 * float(GRID_OFFSET_Y / 100 * 100));
  for (iy = 0; iy <= SCREEN_height / 100 + 1; iy ++) {
    if ((int(ZOOM_FACTOR / 100.0 * float(iy * 100)) + offset) >= 0) {
      string =
        (
          float(
            int(
              ZOOM_FACTOR / 100.0 * float(iy * 100)
            )
            +
            offset
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_width / 2 - int(textWidth(string)/2) + GRID_OFFSET_X;
      if (x < TEXT_MARGIN) x = TEXT_MARGIN;
      if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
      y = SCREEN_height - iy * 100 - TEXT_MARGIN + (GRID_OFFSET_Y % 100);
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_y = SCREEN_height - iy * 100 - TEXT_MARGIN - FONT_HEIGHT / 2 + (GRID_OFFSET_Y % 100);
      }
    }
  }

  if( (image_x >= 0 && image_x < SCREEN_width) && (image_y >= 0 && image_y < SCREEN_height) ) {
    //image(PS_image, image_x, image_y);
    image(PS_image, image_x - PS_image.width / 2, image_y - PS_image.height / 2);
  }
}

void grid_draw()
{
  if (ROTATE_FACTOR == 0) {
    grid_draw_rotate_0();
  } else if (ROTATE_FACTOR == 90) {
    grid_draw_rotate_90();
  } else if (ROTATE_FACTOR == 180) {
    grid_draw_rotate_180();
  } else /*if (ROTATE_FACTOR == 270)*/ {
    grid_draw_rotate_270();
  }
}