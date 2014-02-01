//
//  SingleArrangeDetailViewController.m
//  Bage
//
//  Created by Adozen12 on 14-1-16.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "SingleArrangeDetailViewController.h"

@interface SingleArrangeDetailViewController ()

@end

@implementation SingleArrangeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withNSString:(NSString *)name
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.partnerName.text=name;
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
    [_partnerName release];
    [super dealloc];
}
@end
