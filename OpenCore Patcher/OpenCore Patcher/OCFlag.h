//
//  OCFlag.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/17/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kArg "arg"
#define kHelpString "help"
#define kDefaultModels "default_models"

@interface OCFlag : NSObject

-(id)init;
-(id)initWithDict:(NSDictionary *)d;

@property (nonatomic, strong) NSString *arg;
@property (nonatomic, strong) NSString *helpString;
@property (nonatomic, assign) BOOL enabled;
@property (nonatomic, strong) NSArray *defaultModels;

@end
