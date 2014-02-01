//  LineChartViewController.m
//  Bage
//  Created by Lori on 14-1-9.
//  Copyright (c) 2014年 Duger. All rights reserved.

#import "LineChartViewController.h"
#import "DataTableView.h"

@interface LineChartViewController ()

@end

@implementation LineChartViewController

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
    NSArray *array1 = @[@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20,@30,@40,@20];
    NSArray *array2 = @[@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30,@40,@50,@30];
    NSArray *array3 = @[@40,@90,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40,@50,@60,@40];
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:array1,array2,array3, nil];
    DataTableView *dataTableView = [[DataTableView alloc] initWithFrame:CGRectMake(0, 0, 200, 320) dataArray:array] ;

    [self.view addSubview:dataTableView];
    [dataTableView release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end