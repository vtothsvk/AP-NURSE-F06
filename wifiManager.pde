#include "wifiManager.h"

// WiFi AP settings 
char ESSID[] = WIFI_SSID;
char PASSW[] = WIFI_PASS;

uint8_t socket = SOCKET0;
char type[] = WIFI_TYPE;
char host[] = WIFI_HOST;
char port[] = WIFI_PORT;
char url[]  = WIFI_URL;

// CA Certifikat konrektneho kusu MESHLIA
char TRUSTED_CA[] =
"-----BEGIN CERTIFICATE-----\r"\
"MIIDxTCCAq2gAwIBAgIJALzp3i3uMeiOMA0GCSqGSIb3DQEBCwUAMHgxCzAJBgNV\r"\
"BAYTAkVTMQ8wDQYDVQQIDAZBcmFnb24xETAPBgNVBAcMCFphcmFnb3phMTIwMAYD\r"\
"VQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmlidWlkYXMgUy5MLjER\r"\
"MA8GA1UEAwwIbWVzaGxpdW0wIBcNMjAwOTE2MTIwNzM5WhgPMjEyMDA4MjMxMjA3\r"\
"MzlaMHgxCzAJBgNVBAYTAkVTMQ8wDQYDVQQIDAZBcmFnb24xETAPBgNVBAcMCFph\r"\
"cmFnb3phMTIwMAYDVQQKDClMaWJlbGl1bSBDb211bmljYWNpb25lcyBEaXN0cmli\r"\
"dWlkYXMgUy5MLjERMA8GA1UEAwwIbWVzaGxpdW0wggEiMA0GCSqGSIb3DQEBAQUA\r"\
"A4IBDwAwggEKAoIBAQDFPpzKyQ/tSTpZUv9fWHt9JfIXyDbc5nZnOclaNwTUN9qi\r"\
"ULWIQuPsZS7cCqVg/se8MPRGkIqTMs7QCxnJ9XYFfRvC7PYZlp56ecjmlunNZnzk\r"\
"QQ6Xy6s8HyRLE06GgXRbX3Gj2fc/6TmRRn6716Q0T3SdRHj1+gE4WE0765VxMnAB\r"\
"T3Gsp4fDkpnG/SuAF/GjsmqRU7hdF2QE0aIsKRm2sXxBrgk2t0K7enGAdcyYPijF\r"\
"CO096oMYYdpyVzd5hisEsmjWNVKhV8GlN0syDh6HPKfM2b2tPGB/59m714o1HazP\r"\
"1vmbuPz70sGRCPV52a0VcjG4gMZhpau/Ho8Or/Z1AgMBAAGjUDBOMB0GA1UdDgQW\r"\
"BBQgqRLAmoguG1biM7C2qOMz1+hlWjAfBgNVHSMEGDAWgBQgqRLAmoguG1biM7C2\r"\
"qOMz1+hlWjAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBCwUAA4IBAQC1psOYyNBy\r"\
"HqwLu75RGnWrqH5z0m7wp82cRuzQ9jovUIZpoaVKuM4QqOmhpLbHHVy6q36nzCwd\r"\
"yuqf/347El/Lfyw7jfPYZIQIgHX9TQKnAg6DMhqKDm8DDDRKWOE65QkOJmLBPwL0\r"\
"gxxlZXsWUMdvjcmmFzrTjxwl98jcTl34lZqHgTfOEkCcx0112Fgh5ldLxxLUCBT9\r"\
"4vcAQLfNRneNL6NxN1qAaDxs1WjB9KuBY2De2gBLojH5lOextOU+5wwxrmqSZwWp\r"\
"ZG9pnN4dRhrOeI31Pp320vec1dx1aDfvrfQAZWZLorgExeKcDj0aWCALuvra174h\r"\
"NqPiNZOqk/OF\r"\
"-----END CERTIFICATE-----";

wifi_error_t startWifiManager() {
    uint8_t ret = WIFI_PRO.ON(socket);
    if (ret) return WIFI_ON_FAIL;

    ret = WIFI_PRO.setESSID(ESSID);
    if (ret) return WIFI_SSID_FAIL;

    ret = WIFI_PRO.setPassword(WPA2, PASSW);
    if (ret) return WIFI_PASS_FAIL;

    ret = WIFI_PRO.softReset();
    if (ret) return WIFI_SOFTR_FAIL;

    ret = WIFI_PRO.setURL(type, host, port, url);
    if (ret) return WIFI_URL_FAIL;

    ret = WIFI_PRO.setContentType("application/json");
    if (ret) return WIFI_TYPE_FAIL;

    delay(100);
    
    return WIFI_OK;
}//wifiRun

void checkConnection(){
    if (isConnected()) {
        logE("WiFi Connection OK");
    } else {
        logE("WiFi Connection error");
    }//if (WIFI_PRO.isConnected())
}//checkConnection

void wifiGetIp() {
    if (WIFI_PRO.getIP()) {
        logE("WiFi IP error");
    } else {
        log("WIFI IP: ");
        logE(WIFI_PRO._ip);
    }//if (WIFI_PRO.getIP()) 
}//wifiGetIp

char* createPostPayload(const char* format, ...) {
    char* out;
    va_list args;

    va_start(args, format);
    size_t len = vsnprintf(NULL, 0, format, args) + 1;
    out = (char*)malloc(len);
    vsprintf(out, format, args);
    va_end(args);

    return out;
}//createPostPayload

wifi_error_t postData(char* payload) {
    if (isConnected()) {
        size_t len = snprintf(NULL, 0, POST_PREFIX, SN, myId, payload);
        char* buffer = (char*)malloc(len) + 1;
        sprintf(buffer, POST_PREFIX, SN, myId, payload);

        if (WIFI_PRO.post(buffer)) {
            free(buffer);
            free(payload);
            
            return WIFI_POST_FAIL;
        } else {
            logE("HTTP POST OK");

            free(buffer);
            free(payload);

            return WIFI_OK;
        }//if (WIFI_PRO.post(payload))
    }//if (isConnected())

    return WIFI_NOT_CONNECTED;
}//advertiseData

void ERROR_CHECK(wifi_error_t error) {
    switch (error) {
        case WIFI_ON_FAIL :
            logE("WiFi ON error");
        break;

        case WIFI_SSID_FAIL :
            logE("WiFi SSID error");
        break;

        case WIFI_PASS_FAIL :
            logE("WiFi PASS error");
        break;

        case WIFI_SOFTR_FAIL :
            logE("WiFi softReset error");
        break;

        case WIFI_URL_FAIL :
            logE("WiFi URL error");
        break;

        case WIFI_TYPE_FAIL :
            logE("WiFi ContentType error");
        break;

        case WIFI_POST_FAIL :
            log("HTTP POST failed with ret: ");
            WIFI_PRO.printErrorCode();
        break;

        case WIFI_NOT_CONNECTED :
            logE("WiFi not connected");
        break;

        default :
            logE("WiFi OK");
        break;
    }//switch (error)
}//ERROR_CHECK

bool isConnected() {
    return WIFI_PRO.isConnected();
}//isConnected
