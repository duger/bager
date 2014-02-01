//
//  BageHomeViewController.m
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BageHomeViewController.h"
#import "BageSetupInfomationManager.h"

#import "MatchManger.h"
#import "RankingListViewController.h"
#import "QuickMatchViewController.h"
//弹出窗第三方类
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "SystemTopicViewController.h"
#import "ShowAllGroupActiveViewController.h"
#import "GoodLuckMatchViewController.h"


#define kSafeRelease(object) [object release],object = nil

@interface BageHomeViewController ()
{
    //所有语言
    NSArray *_languageArray;
    //功能
    NSArray *_functionsArray;
    //语言选择窗口是否开启
    BOOL _isOpenedLanguageMenu;
    
}

//创建语言选择barItem
-(void)_createLanguageBarItem;
//语言选择界面添加按钮
-(void)_buttonsOnLanguageView;
//为语言选择界面添加动画
-(void)_addAnimationToLanguageViews;
//收回语言选择菜单
-(void)_getBackLanguageMenu;

@end

@implementation BageHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"主页";
        _languageArray = [[NSArray alloc]initWithArray:[[BageSetupInfomationManager defaultManager]getInfromationForKey:@"languages"]];

        _functionsArray = [[NSArray alloc]initWithArray:[[BageSetupInfomationManager defaultManager]getInfromationForKey:@"HomeViewFunction"]copyItems:YES];

        //语言选择窗口是否开启
        _isOpenedLanguageMenu = NO;
    }
    return self;
}

- (void)dealloc
{
    
    [_languageChooseView release],_languageChooseView = nil;

    [_languageArray release],_languageArray = nil;
    [_functionsArray release],_functionsArray = nil;
    [_darkView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //语言选择
    [self _createLanguageBarItem];

    //手气不错Button
    UIBarButtonItem *goodLuck = [[UIBarButtonItem alloc]initWithTitle:@"手气不错" style:UIBarButtonItemStylePlain target:self action:@selector(didClickGoodLuckButton:)];
    self.navigationItem.rightBarButtonItem = goodLuck;
    [goodLuck release];
    
    

    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor lightGrayColor]];
//    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)didClickLanguageButton:(id)sender
{
    //实例化过渡动画
    [self _addAnimationToLanguageViews];
    
    if (_isOpenedLanguageMenu) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.languageChooseView setFrame:CGRectMake(0, -150, 320, 150)];
            
        } completion:^(BOOL finished) {
            _isOpenedLanguageMenu = !_isOpenedLanguageMenu;
        }];
        self.darkView.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;

    }else{
    [UIView animateWithDuration:0.3 animations:^{
        [self.languageChooseView setFrame:CGRectMake(0, 64, 320, 150)];
       

    } completion:^(BOOL finished) {
        _isOpenedLanguageMenu = !_isOpenedLanguageMenu;
    }];
        
        self.darkView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }
}

//点击语言菜单阴影
- (IBAction)didClickDackView:(UITapGestureRecognizer *)sender {
    //退出语言菜单
    [self _getBackLanguageMenu];
}

-(void)didClickGoodLuckButton:(id)sender
{
    //退出语言菜单
    [self _getBackLanguageMenu];
    GoodLuckMatchViewController *goodLuckMatchVC = [[GoodLuckMatchViewController alloc] init];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(300, 230) viewController:goodLuckMatchVC];
    [goodLuckMatchVC release];
    [formSheet setTransitionStyle:MZFormSheetTransitionStyleFade];
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.cornerRadius = 10;
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
    
    
    NSLog(@"手气不错！");
}


#pragma mark - TalbeView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _functionsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    //3.假如真没有获取到单元格,就要实例化单元格
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName] autorelease];
        
        
    }
    
    
    cell.textLabel.text = _functionsArray[indexPath.section];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        kSafeRelease(_languageArray);
        if (_languageArray == nil) {
//            NSLog(@"安全%d",_languageArray.retainCount);
        }
        
        
    }
    switch (indexPath.section) {
        case 4: //push 到 榜单页
        {
            RankingListViewController *rankingListVC = [[RankingListViewController alloc] init];
            [self.navigationController pushViewController:rankingListVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    switch (indexPath.section) {
        case 0:
            NSLog(@"速配");
            QuickMatchViewController *quickMatchVC = [[QuickMatchViewController alloc] initWithNibName:@"QuickMatchViewController" bundle:nil];
            
            MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:quickMatchVC];
            [quickMatchVC release];
            [formSheet setTransitionStyle:MZFormSheetTransitionStyleFade];
            formSheet.shouldDismissOnBackgroundViewTap = YES;
            formSheet.cornerRadius = 10;
           
                [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
                }];
            
            break;
            
        case 1:
            NSLog(@"话题");
            SystemTopicViewController *systopicVC=[[SystemTopicViewController alloc]init];
            systopicVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:systopicVC animated:YES];
            [systopicVC release];
            break;
        case 2:
            NSLog(@"自由话题");
            
//            [[MatchManger defaultManager]getRequiredMatchOrNot:@"wangfu@lanouserver"];
            
            break;
        case 3:
            NSLog(@"小组吧");
            ShowAllGroupActiveViewController *groupActiveVC=[[ShowAllGroupActiveViewController alloc]init];
            [self.navigationController pushViewController:groupActiveVC animated:YES];
            break;
        case 4:
            NSLog(@"榜单");
            break;
            
        default:
            break;
    }
    
//    NetworkManager *netMag = [[NetworkManager alloc]init];
//    [netMag submit:nil];
}


#pragma mark - Private Methods
//创建语言选择barItem
-(void)_createLanguageBarItem
{
    UIBarButtonItem *languageItem = [[UIBarButtonItem alloc]initWithTitle:@"英语" style:UIBarButtonItemStylePlain target:self action:@selector(didClickLanguageButton:)];
    self.navigationItem.leftBarButtonItem = languageItem;
    [languageItem release];
    
    
    //语言选择界面添加按钮
    [self _buttonsOnLanguageView];
    
}
//语言选择界面添加按钮
-(void)_buttonsOnLanguageView
{
    NSInteger indexX = 0, indexY = 0,step = 32;
    
    
    for (NSInteger i = 0; i < _languageArray.count; i++) {
        NSString *str = _languageArray[i];
        if (indexX > 240) {
            indexX = step;
            indexY = 30 + step;
        }
        
        indexX = step + (40 + step) * (i % 4);
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(indexX , indexY + 20 , 40, 40)];
        [button setTitle:str forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(_didChooseLanguage:) forControlEvents:UIControlEventTouchUpInside];
        [self.languageChooseView addSubview:button];
    }
}

-(void)_didChooseLanguage:(UIButton *)sender
{
    NSString *language = [_languageArray objectAtIndex:sender.tag - 10000];
    self.navigationItem.leftBarButtonItem.title = language;
    
    [self _getBackLanguageMenu];
    
}

//为语言选择界面添加动画
-(void)_addAnimationToLanguageViews
{
    CATransition *transition = [[CATransition alloc]init];
    transition.duration = 0.4;
    transition.type = kCATransitionFade;
    [self.darkView.layer addAnimation:transition forKey:@"transition"];
    [self.tabBarController.tabBar.layer addAnimation:transition forKey:@"tabbar"];
    [transition release];
}

//收回语言选择菜单
-(void)_getBackLanguageMenu
{
    if (_isOpenedLanguageMenu) {
        [UIView animateWithDuration:0.4 animations:^{
            [self.languageChooseView setFrame:CGRectMake(0, -150, 320, 150)];
        } completion:^(BOOL finished) {
            _isOpenedLanguageMenu = !_isOpenedLanguageMenu;
        }];
        //实例化过渡动画
        [self _addAnimationToLanguageViews];
        self.darkView.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    }
    
}


@end
