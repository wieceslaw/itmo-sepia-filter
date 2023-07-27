//
// Created by wieceslaw on 06.11.22.
//

#include <sys/resource.h>
#include <stdio.h>
#include <unistd.h>
#include <stdbool.h>

#include "main.h"
#include "file.h"
#include "image_bmp.h"
#include "transform_rotate.h"
#include "transform_sepia_c.h"
#include "transform_sepia_asm.h"

typedef struct image (transformer)(struct image const * const);

bool compare(struct image const * const img1, struct image const * const img2) {
    size_t size = img1->height * img1->width;
    for (size_t i = 0; i < size; i++) {
        if (
                (img1->data[i].b != img2->data[i].b) ||
                (img1->data[i].g != img2->data[i].g) ||
                (img1->data[i].r != img2->data[i].r)
                > 0
                ) {
            return false;
        }
    }
    return true;
}

long measure_time(struct image * const dst_img, struct image const * const src_img, transformer f) {
     struct rusage r;
     struct timeval start;
     struct timeval end;
     getrusage(RUSAGE_SELF, &r );
     start = r.ru_utime;
     *dst_img = f(src_img);
     getrusage(RUSAGE_SELF, &r );
     end = r.ru_utime;
     return ((end.tv_sec - start.tv_sec) * 1000000L) + end.tv_usec - start.tv_usec;
}

int main( int argc, char** argv ) {
    if (argc != 4) {
        err(EXIT_FAILURE, "Wrong number of arguments.");
    }

    FILE* in = NULL;
    FILE* out1 = NULL;
    FILE* out2 = NULL;

    if (file_open(&in, argv[1], "rb") != FL_OPEN_OK) {
        err(EXIT_FAILURE, "Error occurred when opening an input file.");
    }
    if (file_open(&out1, argv[2], "wb") != FL_OPEN_OK) {
        err(EXIT_FAILURE, "Error occurred when opening an first output file.");
    }
    if (file_open(&out2, argv[3], "wb") != FL_OPEN_OK) {
        err(EXIT_FAILURE, "Error occurred when opening an second output file.");
    }

    struct image img = {0};

    if (from_bmp(in, &img)) {
        file_close(in);
        file_close(out1);
        file_close(out2);
        err(EXIT_FAILURE, "Error occurred when reading an input file");
    }

    struct image new_img_asm = {0};
    struct image new_img_c = {0};

    long time1 = measure_time(&new_img_asm, &img, sepia_asm);
    long time2 = measure_time(&new_img_c, &img, sepia_c);

    printf("- Time used by asm implementation: %ld microseconds \n", time1);
    printf("- Time used by C implementation: %ld microseconds \n", time2);
    printf("- Asm implementation %ld times faster than C \n", time2 / time1);

    if (compare(&new_img_c, &new_img_asm)) {
        printf("- Images are equal \n");
    } else {
        printf("- Images are not equal \n");
    }

    if (to_bmp(out1, &new_img_c)) {
        image_destroy(&img);
        image_destroy(&new_img_c);
        image_destroy(&new_img_asm);
        file_close(in);
        file_close(out1);
        file_close(out2);
        err(EXIT_FAILURE, "Error occurred when writing an input file");
    }

    if (to_bmp(out2, &new_img_asm)) {
        image_destroy(&img);
        image_destroy(&new_img_c);
        image_destroy(&new_img_asm);
        file_close(in);
        file_close(out1);
        file_close(out2);
        err(EXIT_FAILURE, "Error occurred when writing an input file");
    }

    image_destroy(&img);
    image_destroy(&new_img_c);
    image_destroy(&new_img_asm);

    if (file_close(in)) {
        file_close(out1);
        file_close(out2);
        err(EXIT_FAILURE, "Error occurred when closing input file");
    }
    if (file_close(out1)) {
        file_close(out2);
        err(EXIT_FAILURE, "Error occurred when closing output file");
    }

    if (file_close(out2)) {
        err(EXIT_FAILURE, "Error occurred when closing output file");
    }

    printf("- Successfully created file \n");
    return 0;
}
