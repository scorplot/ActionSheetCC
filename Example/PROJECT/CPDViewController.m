//
//  CPDViewController.m
//  PROJECT
//
//  Created by PROJECT_OWNER on TODAYS_DATE.
//  Copyright (c) TODAYS_YEAR PROJECT_OWNER. All rights reserved.
//

#import "CPDViewController.h"
#import <CCActionSheet.h>
@interface CPDViewController ()

@end

@implementation CPDViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}
- (IBAction)buttonClicked:(id)sender {
//       CCActionSheet *action = [[CCActionSheetFactory shareInstance] createActionSheetWithTitle:@"aaa" style:UIActionSheetStyleDefault cancelAction:[CCActionSheetAction actionSheetWithTitle:@"bbb" handler:^(CCActionSheetAction * _Nullable action) {
//            NSLog(@"%@",action.title);
//        }] otherActions:[CCActionSheetAction actionSheetWithTitle:@"ccc" handler:^(CCActionSheetAction * _Nullable action) {
//            NSLog(@"%@",action.title);
//        }],[CCActionSheetAction actionSheetWithTitle:@"ddd" handler:^(CCActionSheetAction * _Nullable action) {
//            NSLog(@"%@",action.title);
//        }], nil];
    
    CCActionSheet *action = [[CCActionSheetFactory shareInstance] createActionSheet];
    [action addAction:[CCActionSheetAction actionSheetWithTitle:@"bbb" handler:nil]];
    [action addAction:[CCActionSheetAction actionSheetWithTitle:@"eee" handler:^(CCActionSheetAction * _Nullable action) {
    }]];
    action.title= @"修改了";
    [action show];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
