#include "consoleLog.h"

void log(const char* message) {
    USB.print(message);
}//log

void logE(const char* message) {
    USB.println(message);
}//logE

void logA(const char* format, ...) {
    char* buffer;
    va_list args;

    va_start(args, format);
    size_t len = vsnprintf(NULL, 0, format, args) + 1;
    buffer = (char*)malloc(len);
    vsprintf(buffer, format, args);
    va_end(args);

    log(buffer);
    free(buffer);
}//logA
