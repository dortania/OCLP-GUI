//
//  OCFlagManager.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/17/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCDriveInfo.h"
#import "OCFlag.h"

#define OCFlagsPlist "OCFlags.plist"

@interface OCFlagManager : NSObject

@property (nonatomic, strong) NSArray *optionalFlags;
@property (nonatomic, strong) NSString *targetModel;
@property (nonatomic, strong) NSString *machineModel;


+ (OCFlagManager *)sharedInstance;
-(NSArray *)buildArgs;

@end
