#include <inttypes.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>

#define ALIVE(cell) ((cell) & 1)
#define REVIVE(cell) ((cell) |= (1 << 1))

struct board {
    uint8_t *mem;
    int w;
    int h;
};

struct board evolve(struct board brd, int x, int y) {
    int n = 0;

    for (int x1 = x - 1; x1 <= x + 1; ++x1)
        for (int y1 = y - 1; y1 <= y + 1; ++y1)
            if (x1 < 0 || x1 >= brd.h || y1 < 0 || y1 >= brd.w)
                continue;
            else if (ALIVE(*(brd.mem + brd.w*x1 + y1)))
                ++n;

    if (ALIVE(*(brd.mem + brd.w*x + y)))
        --n;

    if (n == 3 || (n == 2 && ALIVE(*(brd.mem + brd.w*x + y))))
        REVIVE(*(brd.mem + brd.w*x + y));

    return brd;
}

void print(struct board brd) {
    for (int x = 0; x < brd.h; ++x) {
        for (int y = 0; y < brd.w; ++y) {
            printf("%hhu", *(brd.mem + brd.w * x + y));
            if (y < brd.w - 1)
                printf(" ");
            else
                printf("\n");
        }
    }
}

int main() {
    struct board brd;
    scanf("%d %d", &brd.h, &brd.w);

    brd.mem = malloc(sizeof(uint8_t) * brd.w * brd.h);
    if (!brd.mem) {
        fprintf(stderr, "Board size too large.");
        return 1;
    }
    memset(brd.mem, 0, sizeof(uint8_t) * brd.w * brd.h);

    for (int x = 0; x < brd.h; ++x)
        for (int y = 0; y < brd.w; ++y)
            scanf("%hhu", brd.mem + brd.w*x + y);

    for (int x = 0; x < brd.h; ++x)
        for (int y = 0; y < brd.w; ++y)
            evolve(brd, x, y);

    for (int x = 0; x < brd.h; ++x)
        for (int y = 0; y < brd.w; ++y)
            *(brd.mem + brd.w*x + y) >>= 1;

    print(brd);

    free(brd.mem);
    return 0;
}
