//
//  SingleGroupActiveViewController.m
//  Bage
//
//  Created by Adozen12 on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "SingleGroupActiveViewController.h"

@interface SingleGroupActiveViewController ()

@end

@implementation SingleGroupActiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_groupActiveName release];
    [_groupName release];
    [_groupActiveRuntime release];
    [_groupActiveImage release];
    [_groupActiveIntroduce release];
    [super dealloc];
}

- (IBAction)didClickWantApply:(id)sender {
}
@end
