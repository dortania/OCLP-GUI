//
//  nvram.h
//  Chime Enabler
//
//  Created by Collin Mistr on 2/22/20.
//  Copyright (c) 2020 dosdude1 Apps. All rights reserved.
//

#ifndef Chime_Enabler_nvram_h
#define Chime_Enabler_nvram_h

typedef enum {
    nvramErrMachPort = 1,
    nvramErrKey = 2,
    nvramErrValue = 3
}nvramErr;

#include <CoreFoundation/CoreFoundation.h>
#include <SystemConfiguration/SystemConfiguration.h>
#include <IOKit/IOKitLib.h>
#include <IOKit/IOCFPlugIn.h>
#include <string.h>


nvramErr getNVRAMValueForKey(char *key, char **val);
nvramErr setNVRAMValueForKey(char *name, char *value);
nvramErr deleteNVRAMValueForKey(char *name);

#endif
