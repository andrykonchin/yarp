#include "yarp/enc/yp_encoding.h"

// Each element of the following table contains a bitfield that indicates a
// piece of information about the corresponding ISO-8859-3 character.
static unsigned char yp_encoding_iso_8859_3_table[256] = {
//0  1  2  3  4  5  6  7  8  9  A  B  C  D  E  F
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 0x
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 1x
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 2x
  2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 0, 0, 0, 0, 0, 0, // 3x
  0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, // 4x
  7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 0, 0, 0, 0, 0, // 5x
  0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, // 6x
  3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 0, 0, 0, 0, 0, // 7x
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 8x
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, // 9x
  0, 7, 0, 0, 0, 0, 7, 0, 0, 7, 7, 7, 7, 0, 0, 7, // Ax
  0, 3, 0, 0, 0, 3, 3, 0, 0, 3, 3, 3, 3, 0, 0, 3, // Bx
  7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, // Cx
  0, 7, 7, 7, 7, 7, 7, 0, 7, 7, 7, 7, 7, 7, 7, 3, // Dx
  3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, 3, // Ex
  0, 3, 3, 3, 3, 3, 3, 0, 3, 3, 3, 3, 3, 3, 3, 0, // Fx
};

size_t
yp_encoding_iso_8859_3_char_width(const char *c) {
  return 1;
}

size_t
yp_encoding_iso_8859_3_alpha_char(const char *c) {
  const unsigned char v = *c;
  return (yp_encoding_iso_8859_3_table[v] & YP_ENCODING_ALPHABETIC_BIT) ? 1 : 0;
}

size_t
yp_encoding_iso_8859_3_alnum_char(const char *c) {
  const unsigned char v = *c;
  return (yp_encoding_iso_8859_3_table[v] & YP_ENCODING_ALPHANUMERIC_BIT) ? 1 : 0;
}

bool
yp_encoding_iso_8859_3_isupper_char(const char *c) {
  const unsigned char v = *c;
  return (yp_encoding_iso_8859_3_table[v] & YP_ENCODING_UPPERCASE_BIT) ? true : false;
}
