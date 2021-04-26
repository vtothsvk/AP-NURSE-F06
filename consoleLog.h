#ifndef CONSOLELOG_H_
#define CONSOLELOG_H_

#include "AP-NURSEF05.h"

/**
 * @brief Console log
 * 
 * Used to log errors and other useful debug information to the serial port console
 * 
 * @param message   string to be printed out
 */
void log(const char* message);

/**
 * @brief Console log + \n
 * 
 * Used to log errors and other useful debug information to the serial port console
 * 
 * @param message   string to be printed out
 */
void logE(const char* message);

/**
 * @brief Console log with variable arguments
 * 
 * Used to log errors and other useful debug information to the serial port (just like using the standart C funcion printf)
 * 
 * @param format    C string to be printed out with %[flags] consuming given arguments
 * @param ...       arguments to be printed into the %[flags] fields
 */
void logA(const char* format, ...);

#endif//CONSOLELOG_H_
