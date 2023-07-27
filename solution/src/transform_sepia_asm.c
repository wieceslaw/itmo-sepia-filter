//
// Created by wieceslaw on 29.11.22.
//

#include "transform_sepia_asm.h"
#include "transform_sepia_c.h"

struct image sepia_asm(struct image const * const source) {
    struct image img = image_initialize(source->width, source->height);
    memcpy(img.data, source->data, sizeof(struct pixel) * source->height * source->width);
    int n = sepia_asm_inplace(&img);
    size_t size = source->height * source->width;
    for (size_t i = 1; i <= n; i++) {
        sepia_one(&img.data[size - i]);
    }
    return img;
}
