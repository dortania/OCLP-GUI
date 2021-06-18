//
//  FlagsViewController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/17/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "FlagsViewController.h"

@interface FlagsViewController ()

@end

@implementation FlagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}
-(void)awakeFromNib {
    
    [self.flagsTableView setFocusRingType:NSFocusRingTypeNone];
    
    //Calculate height
    CGFloat baseHeight = self.view.frame.size.height - self.flagsTableView.frame.size.height;
    CGFloat newHeight = baseHeight + (self.flagsTableView.rowHeight * ([[OCFlagManager sharedInstance] flags].count + 1));
    [self.delegate FlagsViewChangedToHeight:newHeight];
    
    [self.flagsTableView setDataSource:self];
    [self.flagsTableView setDelegate:self];
}
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[OCFlagManager sharedInstance] flags].count;
}
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([[tableColumn identifier] isEqualToString:@"enableFlag"]) {
        return [NSNumber numberWithBool:[[[OCFlagManager sharedInstance].flags objectAtIndex:row] enabled]];
    }
    else if ([[tableColumn identifier] isEqualToString:@"flagHelpString"]) {
        return [[[OCFlagManager sharedInstance].flags objectAtIndex:row] helpString];
    }
    return nil;
}
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)value forTableColumn:(NSTableColumn *)column row:(NSInteger)row {
    [[[OCFlagManager sharedInstance].flags objectAtIndex:row] setEnabled:[value boolValue]];
}
@end
