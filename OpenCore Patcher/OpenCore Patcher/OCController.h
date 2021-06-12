//
//  OCController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/7/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCController : NSObject

+ (OCController *)sharedInstance;
-(BOOL)python3IsInstalled;



@end
