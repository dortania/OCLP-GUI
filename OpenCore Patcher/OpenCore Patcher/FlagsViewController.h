//
//  FlagsViewController.h
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/17/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "OCFlagManager.h"
#import "OCController.h"

@protocol FlagsViewDelegate <NSObject>

-(void)FlagsViewChangedToHeight:(CGFloat)height;

@end

@interface FlagsViewController : NSViewController <NSPopoverDelegate, NSTableViewDelegate, NSTableViewDataSource>

@property (strong) id <FlagsViewDelegate> delegate;

@property (strong) IBOutlet NSTableView *flagsTableView;
@property (strong) IBOutlet NSPopUpButton *modelSelectionList;

- (IBAction)setDesiredModel:(id)sender;

@end
