//
//  OCDriveInfo.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/8/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/kext/KextManager.h>
#import <DiskArbitration/DiskArbitration.h>

@interface OCDriveInfo : NSObject

-(id)initWithDiskRef:(DADiskRef)ref;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *bsdName;
@property (nonatomic, assign) NSInteger size;
@property (nonatomic, strong) NSString *iconBundle;
@property (nonatomic, strong) NSString *iconName;
@property (nonatomic, assign) double appearanceTime;
@property (nonatomic, assign) BOOL physical;
-(NSString *)iconBundlePath;
-(BOOL)isEqual:(OCDriveInfo *)other;


@end
