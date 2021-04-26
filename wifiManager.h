#ifndef WIFIMANAGER_H_
#define WIFIMANAGER_H_

#include "AP-NURSEF05.h"

/**
 * WiFi Manager return codes
 */
typedef enum wifi_error_codes{
    WIFI_OK = 0,
    WIFI_ON_FAIL = 1,
    WIFI_SSID_FAIL = 2,
    WIFI_PASS_FAIL = 3,
    WIFI_SOFTR_FAIL = 4,
    WIFI_URL_FAIL = 5,
    WIFI_TYPE_FAIL = 6,
    WIFI_POST_FAIL = 7,
    WIFI_NOT_CONNECTED = 8
}wifi_error_t;

/**
 * @brief Start WiFi Manager
 * 
 * Used to connect the waspmote unit to a WiFi network defined by the WiFi configuration in the wifiConfig.h header file
 * 
 * @return 
 *      'WIFI_OK' on success
 *      'WIFI_ERR' otherwise
 */
wifi_error_t startWifiManager(void);

/**
 * @brief WiFi connection check
 * 
 * Used to check whether the waspmote has active WiFi connection
 */
void checkConnection(void);

/**
 * @brief WiFi IP address check
 * 
 * Used to check WiFi connection and print out waspmote unit's IP address
 */
void wifiGetIp(void);

/**
 * @brief Creates formatted HTTP POST payload
 * 
 * Used to create a formatted HTTP POST payload using a format string that is filled with the specified data
 * (similiar to using a sprintf function to create a formatted string, see usage example in the waspmote main loop)
 * 
 * @param format    C string to be printed out with %[flags] consuming given arguments
 * @param ...       arguments to be printed into the %[flags] fields
 * 
 * @return 
 *      formatted HTTP POST payload string
 */
char* createPostPayload(const char* format, ...);

/**
 * @brief HTTP POST
 * 
 * Used for a HTTP POST request with the given payload to a host specified in the WiFi configuration
 * 
 * @param payload   data to be posted
 * 
 * @return
 *      'WIFI_OK' on success
 *      'WIFI_ERR' otherwise
 */
wifi_error_t postData(char* payload);

/**
 * @brief Error checking function
 * 
 * Used to error check WiFi Manager return codes
 */
void ERROR_CHECK(wifi_error_t error);

/**
 * @brief Internal connection check
 * 
 * Internal connection check function used by the checkConnection() function
 * 
 * @return
 *      'true' if connected
 *      'false' otherwise
 */
bool isConnected(void);

#endif//WIFIMANAGER_H_
