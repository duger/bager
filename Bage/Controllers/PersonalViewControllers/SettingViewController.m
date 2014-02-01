//  SettingViewController.m
//  Bage
//  Created by Lori on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.

#import "SettingViewController.h"
#import "BageCell.h"

@interface SettingViewController ()
{
    UISegmentedControl *_segmentedControl;
    UIButton           *_cachButton;
    NSArray            *_settingArray;
    UIView             *testView;
    UIView             *testView1;
    UIView             *testView2;
}

@end

@implementation SettingViewController

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
    UITableView *aTableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 500) style:UITableViewStyleGrouped] autorelease];
    [self.view addSubview:aTableView];
    aTableView.allowsSelection = NO;
    aTableView.dataSource = self;
    aTableView.delegate = self;
    aTableView.sectionHeaderHeight = 20;
    testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    testView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    testView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    _segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"蓝调",@"绿调",@"红调"]];
    _segmentedControl.frame = CGRectMake(0, 0,120, 40);
    _segmentedControl.tintColor = [UIColor whiteColor];
    [_segmentedControl addTarget:self action:@selector(changeChemes:) forControlEvents:UIControlEventValueChanged];
    
    _cachButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 120, 40)];
    [_cachButton addTarget:self action:@selector(clearCach:) forControlEvents:UIControlEventTouchUpInside];
    [_cachButton setTitle:@"清理缓存" forState:UIControlStateNormal];
    
    _settingArray = [NSArray arrayWithObjects:@"主题风格",@"清理缓存",@"绑定账号",@"意见反馈",@"关于巴哥", nil];
    
}
- (void)changeChemes:(UISegmentedControl *)sender
{
    UIColor *tempColor;
    switch (sender.selectedSegmentIndex) {
        case 0:
            tempColor = [UIColor blueColor];
            _segmentedControl.backgroundColor = [UIColor blueColor];
            _cachButton.backgroundColor = [UIColor blueColor];
            testView.backgroundColor = [UIColor blueColor];
            testView1.backgroundColor = [UIColor blueColor];
            testView2.backgroundColor = [UIColor blueColor];
            break;
        case 1:
            tempColor = [UIColor greenColor];
            _segmentedControl.backgroundColor = [UIColor greenColor];
            _cachButton.backgroundColor = [UIColor greenColor];
            testView.backgroundColor = [UIColor greenColor];
            testView1.backgroundColor = [UIColor greenColor];
            testView2.backgroundColor = [UIColor greenColor];
            break;
        case 2:
            tempColor = [UIColor redColor];
            _segmentedControl.backgroundColor = [UIColor redColor];
            _cachButton.backgroundColor = [UIColor redColor];
            testView.backgroundColor = [UIColor redColor];
            testView1.backgroundColor = [UIColor redColor];
            testView2.backgroundColor = [UIColor redColor];
            break;
        default: tempColor = nil;
            break;
    }
   [[NSNotificationCenter defaultCenter] postNotificationName:@"changeChemes" object:nil userInfo:@{@"color":tempColor}];
}
- (void)clearCach:(UIButton *)button
{
    //获取缓存的路径
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //从路径删除缓存
    [[NSFileManager defaultManager] removeItemAtPath:cachesPath error:nil];
     [_cachButton setTitle:@"清理成功" forState:UIControlStateNormal];
    [NSTimer scheduledTimerWithTimeInterval:0.35f target:self selector:@selector(refreshCaches) userInfo:nil repeats:NO];
    
}
- (void)refreshCaches
{
    [_cachButton setTitle:@"清理缓存" forState:UIControlStateNormal];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuse = @"reuse";
    BageCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse];
    if (cell == nil) {
        cell = [[[BageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuse  cellType:BageCellTypeWithAcceroryView ] autorelease];
    }
    cell.textLabel.text =[_settingArray objectAtIndex:indexPath.section];
      switch (indexPath.section ) {
          case 0:
              [cell.aView addSubview:_segmentedControl];
            break;
          case 1:
              [cell.aView addSubview:_cachButton];
              break;
          case 2:
              [cell.aView addSubview:testView1];
              break;
          case 3:
              [cell.aView addSubview:testView2];
              break;
          case 4:
              [cell.aView addSubview:testView];
              break;
        default:
            break;
    }
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.0f;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end