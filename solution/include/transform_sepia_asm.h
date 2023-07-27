//
// Created by wieceslaw on 29.11.22.
//

#ifndef ASSIGNMENT_5_SEPIA_FILTER_TRANSFORM_SEPIA_ASM_H
#define ASSIGNMENT_5_SEPIA_FILTER_TRANSFORM_SEPIA_ASM_H

#include <stdint.h>
#include <memory.h>
#include "image.h"

extern uint8_t sepia_asm_inplace(struct image* img);

struct image sepia_asm(struct image const * source);

#endif //ASSIGNMENT_5_SEPIA_FILTER_TRANSFORM_SEPIA_ASM_H
