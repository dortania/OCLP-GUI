//
//  OCLoggingManagerClient.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/20/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCLoggingManagerClientDelegate <NSObject>

-(void)logDidUpdateWithText:(NSString *)text;

@end

@interface OCLoggingManagerClient : NSObject

@property (strong) id <OCLoggingManagerClientDelegate> delegate;

-(void)setOutputPipe:(NSPipe *)pipe;

@end
