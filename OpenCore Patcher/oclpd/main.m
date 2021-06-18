//
//  main.m
//  oclpd
//
//  Created by Collin Mistr on 6/16/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCPatchHandler.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        OCPatchHandler *handler = [[OCPatchHandler alloc] init];
        [handler startIPCService];
    }
    return 0;
}
