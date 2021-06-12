//
//  OCInstallationViewController.m
//  OpenCore Patcher
//
//  Created by Collin Mistr on 6/12/21.
//  Copyright (c) 2021 Dortania. All rights reserved.
//

#import "OCInstallationViewController.h"

@interface OCInstallationViewController ()

@end

@implementation OCInstallationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

- (IBAction)returnToMain:(id)sender {
    [self.delegate setWindowVisibleViewController:[[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil]];
}
@end
