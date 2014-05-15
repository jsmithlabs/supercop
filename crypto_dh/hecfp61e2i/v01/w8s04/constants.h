#define CONSTANTS static const unsigned char cn[16*2] = { \
    0x65, 0xB2, 0x6C, 0x67, 0x29, 0x8C, 0xC7, 0x02, 0x15, 0x8C, 0x54, 0x1E, 0x39, 0x2C, 0x28, 0x0F, \
    0xCB, 0xD9, 0x8B, 0x5E, 0xFD, 0xD4, 0x17, 0x03, 0x3F, 0x43, 0xD9, 0xFF, 0x7E, 0x74, 0x07, 0x0E \
}
/**
 * [a3, a2] in y^2 = a5*x^5 + a4*x^4 + a3*x^3 + a2*x^2 + a1*x + a0
 *
 * a3:=1092171533470960661*i + 200282817898000997;
 * a2:=1010904730175095615*i + 222880891256166859;
 * a1:=2188897028088906113*i + 2121806688923765783;
 * a0:=2023072108862458234*i + 1545665884212463459;
 *
 **/