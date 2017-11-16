#include <inttypes.h>
#include <memory.h>
#include <stdio.h>
#include <stdlib.h>

extern void start(int w, int h, char *brd);
extern void run(int steps);

struct board {
    uint8_t *mem;
    int w;
    int h;
};

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

    if (!brd.w || !brd.h)
        return 0;

    brd.mem = malloc(sizeof(uint8_t) * brd.w * brd.h);
    if (!brd.mem) {
        fprintf(stderr, "Board size too large.");
        return 1;
    }
    memset(brd.mem, 0, sizeof(uint8_t) * brd.w * brd.h);

    for (int x = 0; x < brd.h; ++x)
        for (int y = 0; y < brd.w; ++y)
            scanf("%hhu", brd.mem + brd.w*x + y);

    int steps = 0;
    scanf("%d", &steps);

    if (steps) {
        start(brd.w, brd.h, (char *) brd.mem);
        run(steps);
    }

    print(brd);

    free(brd.mem);
    return 0;
}
