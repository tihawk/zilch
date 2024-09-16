typedef void (*function)();
char program[32];

unsigned char getch() {
    unsigned char c;
    // BIOS interrupt 0x16, AH = 0x00 to read a key press
    __asm__ __volatile__ (
        "mov $0x00, %%ah\n"
        "int $0x16\n"
        "mov %%al, %0\n"
        : "=r"(c)         // Output
        :                 // Input (none)
        : "%ax"           // Clobbered registers
    );
    return c;
}

void main() {
    char *t = program;
    unsigned i, n;
    for (;;) {
        for (i = 3; i; i--) {
            n = getch() - '0';
            if (n > 7) {
                ((function)program)();
            }
            *t = *t * 8 + n;
        }
        t++;
    }
}

