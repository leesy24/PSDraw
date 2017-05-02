// Get 32bits data by network byte order(big-endian)
int get_int32_bytes(byte data[], int i) {
  return ((data[i + 0] & 0xff) << 24) +
    ((data[i + 1] & 0xff) << 16) +
    ((data[i + 2] & 0xff) << 8) +
    ((data[i + 3] & 0xff) << 0);
}