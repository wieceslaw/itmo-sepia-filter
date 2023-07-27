//
// Created by wieceslaw on 06.11.22.
//

#include "file.h"

enum file_close_status file_close(FILE* const file) {
    if (fclose(file) != 0) {
        switch (errno) {
            default: return FL_CLOSE_ERR;
        }
    }
    return FL_CLOSE_OK;
}

enum file_open_status file_open(FILE** const file, char const * const file_name, char const * const mode) {
    *file = fopen(file_name, mode);
    if (*file == NULL) {
        switch (errno) {
            case 2: return FL_OPEN_NOT_FOUND;
            default: return FL_OPEN_ERR;
        }
    }
    return FL_OPEN_OK;
}
