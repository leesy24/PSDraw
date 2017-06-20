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
  final int screen_width_100 = SCREEN_width / 100;
  final int screen_height_100 = SCREEN_height / 100;
  final int screen_height_100_mod_2 = screen_height_100 % 2;
  final int screen_height_100_2 = screen_height_100 / 2;
  final boolean even_flag = (screen_height_100_mod_2 == 0)?true:false;
  int offset_even_odd;
  final float zoom_factor_100 = ZOOM_FACTOR / 100.0;
  final int grid_offset_y_mod_100 = GRID_OFFSET_Y % 100;
  final int grid_offset_x_mod_100 = GRID_OFFSET_X % 100;
  final int screen_height_mod_100_2 = (SCREEN_height % 100) / 2;
  final int even_odd_offset = screen_height_mod_100_2 + FONT_HEIGHT / 2;
  final int offset_x = TEXT_MARGIN + FONT_HEIGHT / 2;
  final int offset = offset_x + grid_offset_x_mod_100;
  final int offset_ix = int(zoom_factor_100 * float(GRID_OFFSET_X / 100 * 100));
  final int offset_iy = int(zoom_factor_100 * float(GRID_OFFSET_Y / 100 * 100));

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
    offset_even_odd = screen_height_mod_100_2 + grid_offset_y_mod_100;
  else
    offset_even_odd = screen_height_mod_100_2 + 50 + grid_offset_y_mod_100;
  for (iy = -1; iy <= screen_height_100 + 1; iy ++) {
    line(0,            iy * 100 + offset_even_odd,
         SCREEN_width, iy * 100 + offset_even_odd);
  }
  for (ix = 0; ix <= screen_width_100 + 1; ix ++) {
    line(ix * 100 + offset, 0,
         ix * 100 + offset, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  if(even_flag)
    offset_even_odd = even_odd_offset + grid_offset_y_mod_100;
  else
    offset_even_odd = even_odd_offset + 50 + grid_offset_y_mod_100;
  for (iy = -1; iy <= screen_height_100 + 1; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float((iy - screen_height_100_2) * 100)
            )
            -
            offset_iy
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
              zoom_factor_100 * float((screen_height_100_2 - iy) * 100)
            )
            +
            offset_iy
          )
          /
          100.0
        )
        +
        "m";
    }
    y = iy * 100 + offset_even_odd;
    x = offset_x - int(textWidth(string) / 2.0) + GRID_OFFSET_X;
    if (x < TEXT_MARGIN) x = TEXT_MARGIN;
    if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_y = y - FONT_HEIGHT / 2;
    }
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  y = SCREEN_height / 2 + FONT_HEIGHT / 2 + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = 0; ix <= screen_width_100 + 1; ix ++) {
    if ((int(zoom_factor_100 * float(ix * 100)) - offset_ix) >= 0) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float(ix * 100)
            )
            -
            offset_ix
          )
          / 100.0
        )
        +
        "m";
      x = ix * 100 + offset_x - int(textWidth(string) / 2.0) + grid_offset_x_mod_100;
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_x = ix * 100 + offset_x + grid_offset_x_mod_100;
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
  final int screen_width_100 = SCREEN_width / 100;
  final int screen_width_100_2 = screen_width_100 / 2;
  final int screen_height_100 = SCREEN_height / 100;
  final int screen_height_100_mod_2 = screen_height_100 % 2;
  final int screen_height_100_2 = screen_height_100 / 2;
  final boolean even_flag = ((screen_width_100) % 2 == 0)?true:false;
  int offset_even_odd;
  final float zoom_factor_100 = ZOOM_FACTOR / 100.0;
  final int grid_offset_y_mod_100 = GRID_OFFSET_Y % 100;
  final int grid_offset_x_mod_100 = GRID_OFFSET_X % 100;
  final int screen_width_mod_100_2 = (SCREEN_width % 100) / 2;
  final int offset_x = TEXT_MARGIN + FONT_HEIGHT / 2;
  final int offset = offset_x + grid_offset_y_mod_100;
  final int offset_ix = int(zoom_factor_100 * float(GRID_OFFSET_X / 100 * 100));
  final int offset_iy = int(zoom_factor_100 * float(GRID_OFFSET_Y / 100 * 100));

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
    offset_even_odd = screen_width_mod_100_2 + grid_offset_x_mod_100;
  else
    offset_even_odd = screen_width_mod_100_2 + 50 + grid_offset_x_mod_100;
  for (ix = -1; ix <= screen_width_100 + 1; ix ++) {
    line(ix * 100 + offset_even_odd, 0,
         ix * 100 + offset_even_odd, SCREEN_height);
  }
  for (iy = 0; iy <= screen_height_100 + 1; iy ++) {
    line(0,            iy * 100 + offset,
         SCREEN_width, iy * 100 + offset);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  y = TEXT_MARGIN + FONT_HEIGHT + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = -1; ix <= screen_width_100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float((screen_width_100_2 - ix) * 100)
            )
            +
            offset_ix
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
              zoom_factor_100 * float((ix - screen_width_100_2) * 100)
            )
            -
            offset_ix
          )
          /
          100.0
        )
        +
        "m";
    }
    if(even_flag)
      x = ix * 100 + screen_width_mod_100_2 - int(textWidth(string) / 2.0) + grid_offset_x_mod_100;
    else
      x = ix * 100 + screen_width_mod_100_2 + 50 - int(textWidth(string) / 2.0) + grid_offset_x_mod_100;
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_x = x + int(textWidth(string) / 2.0);
    }
    //println("ix=" + ix + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  for (iy = 0; iy <= screen_height_100 + 1; iy ++) {
    if ((int(zoom_factor_100 * float(iy * 100)) - offset_iy) >= 0) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float(iy * 100)
            )
            -
            offset_iy
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_width / 2 - int(textWidth(string)/2) + GRID_OFFSET_X;
      if (x < TEXT_MARGIN) x = TEXT_MARGIN;
      if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
      y = iy * 100 + offset_x + FONT_HEIGHT / 2 + grid_offset_y_mod_100;
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_y = iy * 100 + offset_x + grid_offset_y_mod_100;
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
  final int screen_width_100 = SCREEN_width / 100;
  final int screen_height_100 = SCREEN_height / 100;
  final int screen_height_100_mod_2 = screen_height_100 % 2;
  final int screen_height_100_2 = screen_height_100 / 2;
  final boolean even_flag = (screen_height_100_mod_2 == 0)?true:false;
  int offset_even_odd;
  final float zoom_factor_100 = ZOOM_FACTOR / 100.0;
  final int grid_offset_y_mod_100 = GRID_OFFSET_Y % 100;
  final int grid_offset_x_mod_100 = GRID_OFFSET_X % 100;
  final int screen_height_mod_100_2 = (SCREEN_height % 100) / 2;
  final int even_odd_offset = screen_height_mod_100_2 + FONT_HEIGHT / 2;
  final int offset_x = TEXT_MARGIN + FONT_HEIGHT / 2;
  final int offset = offset_x - grid_offset_x_mod_100;
  final int offset_ix = int(zoom_factor_100 * float(GRID_OFFSET_X / 100 * 100));
  final int offset_iy = int(zoom_factor_100 * float(GRID_OFFSET_Y / 100 * 100));

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
    offset_even_odd = screen_height_mod_100_2 + grid_offset_y_mod_100;
  else
    offset_even_odd = screen_height_mod_100_2 + 50 + grid_offset_y_mod_100;
  for (iy = -1; iy <= screen_height_100 + 1; iy ++) {
    line(0,            iy * 100 + offset_even_odd,
         SCREEN_width, iy * 100 + offset_even_odd);
  }
  for (ix = 0; ix <= screen_width_100 + 1; ix ++) {
    line(SCREEN_width - ix * 100 - offset, 0,
         SCREEN_width - ix * 100 - offset, SCREEN_height);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  if(even_flag)
    offset_even_odd = even_odd_offset + grid_offset_y_mod_100;
  else
    offset_even_odd = even_odd_offset + 50 + grid_offset_y_mod_100;
  for (iy = -1; iy <= screen_height_100 + 1; iy ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float((screen_height_100_2 - iy) * 100)
            )
            +
            offset_iy
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
              zoom_factor_100 * float((iy - screen_height_100_2) * 100)
            )
            -
            offset_iy
          )
          /
          100.0
        )
        +
        "m";
    }
    y = iy * 100 + offset_even_odd;
    x = SCREEN_width - offset_x - int(textWidth(string) / 2.0) + GRID_OFFSET_X;
    if (x < TEXT_MARGIN) x = TEXT_MARGIN;
    if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_y = y - FONT_HEIGHT / 2;
    }
    //println("iy=" + iy + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  y = SCREEN_height / 2 + FONT_HEIGHT / 2 + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = 0; ix <= screen_width_100 + 1; ix ++) {
    if ((int(zoom_factor_100 * float(ix * 100)) + offset_ix) >= 0) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float(ix * 100)
            )
            +
            offset_ix
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_width - ix * 100 - offset_x - int(textWidth(string) / 2.0) + grid_offset_x_mod_100;
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_x = SCREEN_width - ix * 100 - offset_x + grid_offset_x_mod_100;
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
  final int screen_width_100 = SCREEN_width / 100;
  final int screen_width_100_2 = screen_width_100 / 2;
  final int screen_height_100 = SCREEN_height / 100;
  final int screen_height_100_mod_2 = screen_height_100 % 2;
  final int screen_height_100_2 = screen_height_100 / 2;
  final boolean even_flag = ((screen_width_100) % 2 == 0)?true:false;
  int offset_even_odd;
  final float zoom_factor_100 = ZOOM_FACTOR / 100.0;
  final int grid_offset_y_mod_100 = GRID_OFFSET_Y % 100;
  final int grid_offset_x_mod_100 = GRID_OFFSET_X % 100;
  final int screen_width_mod_100_2 = (SCREEN_width % 100) / 2;
  final int offset_x = TEXT_MARGIN + FONT_HEIGHT / 2;
  final int offset = offset_x - grid_offset_y_mod_100;
  final int offset_ix = int(zoom_factor_100 * float(GRID_OFFSET_X / 100 * 100));
  final int offset_iy = int(zoom_factor_100 * float(GRID_OFFSET_Y / 100 * 100));

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
    offset_even_odd = screen_width_mod_100_2 + grid_offset_x_mod_100;
  else
    offset_even_odd = screen_width_mod_100_2 + 50 + grid_offset_x_mod_100;
  for (ix = -1; ix <= screen_width_100 + 1; ix ++) {
    line(ix * 100 + offset_even_odd, 0,
         ix * 100 + offset_even_odd, SCREEN_height);
  }
  for (iy = 0; iy <= screen_height_100 + 1; iy ++) {
    line(0,            SCREEN_height - iy * 100 - offset,
         SCREEN_width, SCREEN_height - iy * 100 - offset);
  }

  // Sets the color used to draw text and borders around shapes.
  fill(C_GRID_TEXT);
  stroke(C_GRID_TEXT);
  y = SCREEN_height - TEXT_MARGIN + GRID_OFFSET_Y;
  if (y < TEXT_MARGIN + FONT_HEIGHT) y = TEXT_MARGIN + FONT_HEIGHT;
  if (y > SCREEN_height - TEXT_MARGIN) y = SCREEN_height - TEXT_MARGIN;
  for (ix = -1; ix <= screen_width_100 + 1; ix ++) {
    if (MIRROR_ENABLE) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float((ix - screen_width_100_2) * 100)
            )
            -
            offset_ix
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
              zoom_factor_100 * float((screen_width_100_2 - ix) * 100)
            )
            +
            offset_ix
          )
          /
          100.0
        )
        +
        "m";
    }
    if(even_flag)
      x = ix * 100 + screen_width_mod_100_2 - int(textWidth(string) / 2.0) + grid_offset_x_mod_100;
    else
      x = ix * 100 + screen_width_mod_100_2 + 50 - int(textWidth(string) / 2.0) + grid_offset_x_mod_100;
    text(string, x, y);
    if(string.equals("0.0m")) {
      image_x = x + int(textWidth(string) / 2.0);
    }
    //println("ix=" + ix + ", string=" + string + ", x=" + x + ", y=" + y);
  }

  for (iy = 0; iy <= screen_height_100 + 1; iy ++) {
    if ((int(zoom_factor_100 * float(iy * 100)) + offset_iy) >= 0) {
      string =
        (
          float(
            int(
              zoom_factor_100 * float(iy * 100)
            )
            +
            offset_iy
          )
          / 100.0
        )
        +
        "m";
      x = SCREEN_width / 2 - int(textWidth(string)/2) + GRID_OFFSET_X;
      if (x < TEXT_MARGIN) x = TEXT_MARGIN;
      if (x > SCREEN_width - int(textWidth(string)) - TEXT_MARGIN) x = SCREEN_width - int(textWidth(string)) - TEXT_MARGIN;
      y = SCREEN_height - iy * 100 - TEXT_MARGIN + grid_offset_y_mod_100;
      text(string, x, y);
      if(string.equals("0.0m")) {
        image_y = SCREEN_height - iy * 100 - TEXT_MARGIN - FONT_HEIGHT / 2 + grid_offset_y_mod_100;
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