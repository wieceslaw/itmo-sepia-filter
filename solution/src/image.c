//
// Created by wieceslaw on 06.11.22.
//

#include "image.h"

struct image image_initialize(uint64_t width, uint64_t height) {
    struct image img = {
            .height = height,
            .width = width,
            .data = malloc(width * height * sizeof(struct pixel))
    };
    return img;
}

void image_destroy(struct image * const img) {
    free(img->data);
    img->data = NULL;
}

struct pixel* image_get(struct image const * const img, uint64_t x, uint64_t y) {
    return &img->data[y * img->width + x];
}

void image_set(struct image * const img, uint64_t x, uint64_t y, struct pixel const * const px) {
    img->data[y * img->width + x] = *px;
}
