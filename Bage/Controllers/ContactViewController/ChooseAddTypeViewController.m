//
//  ChooseAddTypeViewController.m
//  Bage
//
//  Created by lixinda on 13-12-29.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "ChooseAddTypeViewController.h"
#import "AddBuddyViewController.h"
#import "CreateTeamViewController.h"

@interface ChooseAddTypeViewController ()

@end

@implementation ChooseAddTypeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"添加";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setBackBarButtonItemWithTitle:@"返回"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickToAddBuddyVC:(id)sender {
    AddBuddyViewController * addBuddyVC = [[AddBuddyViewController alloc]initWithNibName:@"AddBuddyViewController" bundle:nil];
    [self.navigationController pushViewController:addBuddyVC animated:YES];
    [addBuddyVC release];
}

- (IBAction)didClickToSeachTeamVC:(id)sender {
}

- (IBAction)didClickToCreateTeamVC:(id)sender {
    CreateTeamViewController * createTeamVC = [[CreateTeamViewController alloc]initWithNibName:@"CreateTeamViewController" bundle:nil];
    [self.navigationController pushViewController:createTeamVC animated:YES];
}
#pragma mark - private methods -
-(void)didClickToBackVC:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
