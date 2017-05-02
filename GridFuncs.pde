void grid_draw()
{
  String string;

  if (ROTATE_FACTOR == 0) {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2);
    stroke(128);
    string = "0m";
    text(string, TEXT_MARGIN, SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2);
    for (int j = 100; j < SCREEN_HEIGHT / 2; j += 100) {
      stroke(64);
      line(0, SCREEN_HEIGHT / 2 - j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - j);
      line(0, SCREEN_HEIGHT / 2 + j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 + j);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, TEXT_MARGIN, SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 - j);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, TEXT_MARGIN, SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 + j);
    }

    for (int j = 100; j < SCREEN_WIDTH; j += 100) {
      stroke(64);
      line(j, 0, j, SCREEN_HEIGHT);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, j - int(textWidth(string) / 2.0), TEXT_MARGIN + FONT_HEIGHT);
    }
  } else if (ROTATE_FACTOR == 90) {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT);
    stroke(128);
    string = "0m";
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), TEXT_MARGIN + FONT_HEIGHT);
    for (int j = 100; j < SCREEN_WIDTH / 2; j += 100) {
      stroke(64);
      line(SCREEN_WIDTH / 2 + j, 0, SCREEN_WIDTH / 2 + j, SCREEN_HEIGHT);
      line(SCREEN_WIDTH / 2 - j, 0, SCREEN_WIDTH / 2 - j, SCREEN_HEIGHT);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) + j, TEXT_MARGIN + FONT_HEIGHT);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) - j, TEXT_MARGIN + FONT_HEIGHT);
    }

    for (int j = 100; j < SCREEN_HEIGHT; j += 100) {
      stroke(64);
      line(0, j, SCREEN_WIDTH, j);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH - int(textWidth(string)) - TEXT_MARGIN, j + FONT_HEIGHT / 2);
    }
  } else if (ROTATE_FACTOR == 180) {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, SCREEN_HEIGHT / 2);
    stroke(128);
    string = "0m";
    text(string, SCREEN_WIDTH - TEXT_MARGIN - int(textWidth(string)), SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2);
    for (int j = 100; j < SCREEN_HEIGHT / 2; j += 100) {
      stroke(64);
      line(0, SCREEN_HEIGHT / 2 + j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 + j);
      line(0, SCREEN_HEIGHT / 2 - j, SCREEN_WIDTH, SCREEN_HEIGHT / 2 - j);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH - TEXT_MARGIN - int(textWidth(string)), SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 + j);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH - TEXT_MARGIN - int(textWidth(string)), SCREEN_HEIGHT / 2 + FONT_HEIGHT / 2 - j);
    }

    for (int j = SCREEN_WIDTH - 100; j >= 0; j -= 100) {
      stroke(64);
      line(j, 0, j, SCREEN_HEIGHT);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(SCREEN_WIDTH - j))) / 100.0) + "m";
      text(string, j - int(textWidth(string) / 2.0), SCREEN_HEIGHT - TEXT_MARGIN);
    }
  } else /*if (ROTATE_FACTOR == 270)*/ {
    // Sets the color used to draw lines and borders around shapes.
    stroke(64);
    line(SCREEN_WIDTH / 2, 0, SCREEN_WIDTH / 2, SCREEN_HEIGHT);
    stroke(128);
    string = "0m";
    text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0), SCREEN_HEIGHT - TEXT_MARGIN);
    for (int j = 100; j < SCREEN_WIDTH / 2; j += 100) {
      stroke(64);
      line(SCREEN_WIDTH / 2 - j, 0, SCREEN_WIDTH / 2 - j, SCREEN_HEIGHT);
      line(SCREEN_WIDTH / 2 + j, 0, SCREEN_WIDTH / 2 + j, SCREEN_HEIGHT);
      stroke(128);
      if (MIRROR_ENABLE)
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) - j, SCREEN_HEIGHT - TEXT_MARGIN);
      if (MIRROR_ENABLE)
        string = "+" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      else
        string = "-" + (float(int(ZOOM_FACTOR / 100.0 * float(j))) / 100.0) + "m";
      text(string, SCREEN_WIDTH / 2 - int(textWidth(string) / 2.0) + j, SCREEN_HEIGHT - TEXT_MARGIN);
    }

    for (int j = SCREEN_HEIGHT - 100; j >= 0; j -= 100) {
      stroke(64);
      line(0, j, SCREEN_WIDTH, j);
      stroke(128);
      string = (float(int(ZOOM_FACTOR / 100.0 * float(SCREEN_HEIGHT - j))) / 100.0) + "m";
      text(string, TEXT_MARGIN, j + FONT_HEIGHT / 2);
    }
  }
}