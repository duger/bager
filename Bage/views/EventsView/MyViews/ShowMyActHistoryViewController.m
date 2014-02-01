//
//  ShowMyActHistoryViewController.m
//  Bage
//
//  Created by Adozen12 on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "ShowMyActHistoryViewController.h"
#import "MyActiveTableCell.h"
@interface ShowMyActHistoryViewController ()

@end

@implementation ShowMyActHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _historyArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	// Do any additional setup after loading the view.
    UIBarButtonItem *back=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(didClickBack:)];
    self.navigationItem.leftBarButtonItem=back;
    
    _showHistoryTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, 320, self.view.frame.size.height-64) style:UITableViewStyleGrouped];
    
    _showHistoryTable.delegate=self;
    _showHistoryTable.dataSource=self;
    
    [self.view addSubview:_showHistoryTable];
    
}

-(void)didClickBack:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    [_historyArray removeAllObjects];
    [_showHistoryTable reloadData];
}

#pragma mark - Uitableviewdelegate -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_historyArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  54.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    MyActiveTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil){
        cell = [[[MyActiveTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName]autorelease];
    }
    
    NSInteger row=indexPath.row;
    //NSLog(@"  his  ==  %d",[_historyArray count]);
    NSDictionary *showDic=[_historyArray objectAtIndex:row];
    NSString *showtimeStr=[showDic objectForKey:@"party_runtime"];
    NSString *showtimeok=[showtimeStr substringWithRange:NSMakeRange(5, 8)];
    NSString *showtimeN=[NSString stringWithFormat:@"%@:00",showtimeok];
    NSString *parterName=[showDic objectForKey:@"anti_parter_name"];
    NSString *partyName=[showDic objectForKey:@"party_name"];
    cell.parterName.text=parterName;
    cell.parterActiveName.text=partyName;
    cell.parterRuntime.text=showtimeN;
    cell.parterRuntime.font=[UIFont systemFontOfSize:8.0f];
    
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
