//
//  nvram.c
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#include <stdio.h>
#include "nvram.h"

static CFTypeRef ConvertValueToCFTypeRef(CFTypeID typeID, char *value);

nvramErr getNVRAMValueForKey(char *key, char **val) {
    mach_port_t masterPort;
    int result = IOMasterPort(bootstrap_port, &masterPort);
    if (result != KERN_SUCCESS) {
        printf("Could not create mach port.\n");
        return nvramErrMachPort;
    }
    io_registry_entry_t gOptionsRef = IORegistryEntryFromPath(masterPort, "IODeviceTree:/options");
    long length = 0;
    char          *valueString = 0;
    char          *dataPtr, dataChar;
    char          *dataBuffer = 0;
    long          cnt, cnt2;
    CFTypeRef valueRef = NULL;
    CFStringRef nameRef = CFStringCreateWithCString(kCFAllocatorDefault, key,
                                                    kCFStringEncodingMacRoman);
    if (nameRef == 0) {
        printf("Error CFString for key %ld\n", (long)key);
        return nvramErrKey;
    }
    
    valueRef = IORegistryEntryCreateCFProperty(gOptionsRef, nameRef, 0, 0);
    
    if (valueRef)
    {
        length = CFDataGetLength(valueRef);
        if (length == 0) valueString = "";
        else {
            dataBuffer = malloc(length * 3 + 1);
            if (dataBuffer != 0) {
                dataPtr = (char *)CFDataGetBytePtr(valueRef);
                for (cnt = cnt2 = 0; cnt < length; cnt++) {
                    dataChar = dataPtr[cnt];
                    if (isprint(dataChar)) dataBuffer[cnt2++] = dataChar;
                    else {
                        sprintf(dataBuffer + cnt2, "%%%02x", dataChar);
                        cnt2 += 3;
                    }
                }
                dataBuffer[cnt2] = '\0';
                valueString = dataBuffer;
            }
        }
        *val = malloc(sizeof(valueString)+1);
        strcpy(*val, valueString);
        return 0;
    } else {
        return nvramErrValue;
    }
    return 0;
}

nvramErr setNVRAMValueForKey(char *name, char *value)
{
    CFStringRef   nameRef;
    CFTypeRef     valueRef;
    CFTypeID      typeID;
    kern_return_t result;
    
    mach_port_t masterPort;
    result = IOMasterPort(bootstrap_port, &masterPort);
    if (result != KERN_SUCCESS) {
        printf("Could not create mach port.\n");
        return nvramErrMachPort;
    }
    io_registry_entry_t gOptionsRef = IORegistryEntryFromPath(masterPort, "IODeviceTree:/options");
    
    nameRef = CFStringCreateWithCString(kCFAllocatorDefault, name,
                                        kCFStringEncodingUTF8);
    if (nameRef == 0) {
        printf("Error (-1) creating CFString for key %ld\n", (long)name);
        return nvramErrKey;
    }
    
    valueRef = IORegistryEntryCreateCFProperty(gOptionsRef, nameRef, 0, 0);
    if (valueRef) {
        typeID = CFGetTypeID(valueRef);
        CFRelease(valueRef);
        
        valueRef = ConvertValueToCFTypeRef(typeID, value);
        if (valueRef == 0) {
            printf("Error creating CFTypeRef for value %s", value);
            return nvramErrValue;
        }  result = IORegistryEntrySetCFProperty(gOptionsRef, nameRef, valueRef);
    } else {
        while (1) {
            // In the default case, try data, string, number, then boolean.
            
            valueRef = ConvertValueToCFTypeRef(CFDataGetTypeID(), value);
            if (valueRef != 0) {
                result = IORegistryEntrySetCFProperty(gOptionsRef, nameRef, valueRef);
                if (result == KERN_SUCCESS) break;
            }
            
            valueRef = ConvertValueToCFTypeRef(CFStringGetTypeID(), value);
            if (valueRef != 0) {
                result = IORegistryEntrySetCFProperty(gOptionsRef, nameRef, valueRef);
                if (result == KERN_SUCCESS) break;
            }
            
            valueRef = ConvertValueToCFTypeRef(CFNumberGetTypeID(), value);
            if (valueRef != 0) {
                result = IORegistryEntrySetCFProperty(gOptionsRef, nameRef, valueRef);
                if (result == KERN_SUCCESS) break;
            }
            
            valueRef = ConvertValueToCFTypeRef(CFBooleanGetTypeID(), value);
            if (valueRef != 0) {
                result = IORegistryEntrySetCFProperty(gOptionsRef, nameRef, valueRef);
                if (result == KERN_SUCCESS) break;
            }
            
            break;
        }
    }
    CFRelease(nameRef);
    return 0;
}
nvramErr deleteNVRAMValueForKey(char *name)
{
    return setNVRAMValueForKey(kIONVRAMDeletePropertyKey, name);
}
static CFTypeRef ConvertValueToCFTypeRef(CFTypeID typeID, char *value)
{
    CFTypeRef     valueRef = 0;
    long          cnt, cnt2, length;
    unsigned long number, tmp;
    
    char *temp = malloc(sizeof(value)+1);
    strcpy(temp, value);
    
    if (typeID == CFBooleanGetTypeID()) {
        if (!strcmp("true", temp)) valueRef = kCFBooleanTrue;
        else if (!strcmp("false", temp)) valueRef = kCFBooleanFalse;
    } else if (typeID == CFNumberGetTypeID()) {
        number = strtol(temp, 0, 0);
        valueRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type,
                                  &number);
    } else if (typeID == CFStringGetTypeID()) {
        valueRef = CFStringCreateWithCString(kCFAllocatorDefault, value,
                                             kCFStringEncodingUTF8);
    } else if (typeID == CFDataGetTypeID()) {
        length = strlen(temp);
        for (cnt = cnt2 = 0; cnt < length; cnt++, cnt2++) {
            if (temp[cnt] == '%') {
                if (!ishexnumber(temp[cnt + 1]) ||
                    !ishexnumber(temp[cnt + 2])) return 0;
                number = toupper(temp[++cnt]) - '0';
                if (number > 9) number -= 7;
                tmp = toupper(temp[++cnt]) - '0';
                if (tmp > 9) tmp -= 7;
                number = (number << 4) + tmp;
                temp[cnt2] = number;
            } else temp[cnt2] = temp[cnt];
        }
        valueRef = CFDataCreateWithBytesNoCopy(kCFAllocatorDefault, (const UInt8 *)temp,
                                               cnt2, kCFAllocatorDefault);
    } else return 0;
    
    return valueRef;
}
