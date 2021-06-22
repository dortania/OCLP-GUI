//
//  OCDriveInfo.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/8/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCDriveInfo.h"

@implementation OCDriveInfo

-(id)init {
    self = [super init];
    _physical = YES;
    return self;
}

-(id)initWithDiskRef:(DADiskRef)ref {
    self = [self init];
    NSDictionary *diskInfo = (__bridge NSDictionary *)DADiskCopyDescription(ref);
    NSDictionary *icon = [diskInfo objectForKey:@"DAMediaIcon"];
    _name = [[diskInfo objectForKey:@"DADeviceModel"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _bsdName = [[diskInfo objectForKey:@"DAMediaBSDName"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    _size = [[diskInfo objectForKey:@"DAMediaSize"] integerValue];
    _iconBundle = [icon objectForKey:@"CFBundleIdentifier"];
    _iconName = [icon objectForKey:@"IOBundleResourceFile"];
    _appearanceTime = [[diskInfo objectForKey:@"DAAppearanceTime"] doubleValue];
    if ([diskInfo objectForKey:@"DAMediaUUID"]) {
        _physical = NO;
    }
    return self;
}

-(NSString *)iconBundlePath {
    NSURL *bundlePath = (__bridge NSURL *)KextManagerCreateURLForBundleIdentifier(kCFAllocatorDefault, (__bridge CFStringRef)(_iconBundle));
    return [bundlePath path];
}

-(BOOL)isEqual:(OCDriveInfo *)other {
    return _appearanceTime == other.appearanceTime;
}


@end
