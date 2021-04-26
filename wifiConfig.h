#ifndef WIFI_CONFIG_H_
#define WIFI_CONFIG_H_

//toto je test commitu

/**
 * @brief WiFi configuration
 * 
 * Change the following parameters to suite your network and target host
 */
#define WIFI_SSID   "Allegro-512"
#define WIFI_PASS   "*youarita@35"

#define WIFI_TYPE   "http"
#define WIFI_HOST   "raspberrypi.local"
#define WIFI_PORT   "1880"
#define WIFI_URL    "waspmote"

/**
 * @brief HTTP POST payload formats
 * 
 * Defines a JSON with the key "PIR" and with a %d flag as its value
 * This allows to pass it an integer value to create a formatted string using the 'createPostPayload' function
 * (for different format flags refer to https://www.lix.polytechnique.fr/~liberti/public/computing/prog/c/C/FUNCTIONS/format.html)
 * 
 * e.g.:
 * @code
 * uint8_t pirValue = 1;
 * char* payload = createPostPayload(PIR_FORMAT, pirValue);
 * @endcode
 * 
 * this example fills the 'payload' with the following JSON string:
 *  {
 *      "PIR" : 1
 *  } 
 */
#define PIR_FORMAT "{ \"PIR\": %d}"
#define AirQ_FORMAT "{ \"FAirQ\": %f}"
#define LPG_FORMAT "{ \"FLPG\": %f}"
#define LUX_FORMAT "{ \"Vluxes\": %f}"
#define Tlak_FORMAT "{ \"Ttlak\": %f}"
#define TEMP_FORMAT "{ \"temp\": %f}"
#define HMD_FORMAT "{ \"humd\": %f}"
#define PRESS_FORMAT "{ \"Apres\": %f}"
#define FALL_FORMAT "{ \"FALL\": %d}"
#define Bat_FORMAT "{ \"Blevel\": %d}"

//feel free to create your HTTP POST payload formats the existing (keep in mind, the payload has to be a JSON -> { "key1": value1, "key2": value2, ...} )
#define MESSAGE_01 "{ \"FAirQ\": \"%f\", \"FLPG\": \"%f\", \"Vluxes\": \"%f\", \"Ttlak\": %f}"
#define MESSAGE_02 "{ \"Pvalue\": \"%d\", \"temp\": \"%f\", \"humd\": \"%f\", \"Apres\": %f}"


/**
 * @brief HTTP POST PREFIX format
 * 
 * Used to feed the HTTP POST payload the devices serial number, deviceID and the rest of the POST paload
 */
#define POST_PREFIX "{ \"SN\": \"%s\", \"ID\": \"%s\", \"data\": %s}"

#endif//WIFI_CONFIG_H_
