//  BagePersonalViewController.m
//  Bage
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.

#import "BagePersonalViewController.h"
#import "SettingViewController.h"
#import "DetailViewController.h"
#import "LineChartViewController.h"
#import "LoginViewController.h"
#import "XMPPManager.h"

@interface BagePersonalViewController ()

@end

@implementation BagePersonalViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"我的";

    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
//    NSString *jid = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
//    XMPPJID *userJID = [XMPPJID jidWithString:[NSString stringWithFormat:@"%@@%@",jid,kDOMAIN]];
    NSString *portraitUrl = @"http://124.205.147.26/student/class_10/team_six/resource/wangfu.png";
    NSURL *url = [NSURL URLWithString:portraitUrl];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        UIImage *image = [[UIImage alloc] initWithData:data];
        _photoImageView.image = image;
    }];
//    self.photoImageView.image = [[XMPPManager instence] getOneselfHeadImage:userJID];
    self.nameLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
    self.IDLabel.text = @"北京";
    
    UITapGestureRecognizer *tap = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickEnterToDetailPage:)] autorelease];
    [self.detailView addGestureRecognizer:tap];
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//tap个人资料view，push到 个人资料详情页
- (void)didClickEnterToDetailPage:(UITapGestureRecognizer *)sender
{
    DetailViewController *detailVC = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    detailVC.isSelf = YES;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
}


//点击按钮 push到 设置页
- (IBAction)didCLickSetting:(UIButton *)sender
{
    SettingViewController *settingVC = [[SettingViewController alloc] initWithNibName:@"SettingViewController" bundle:nil];
    settingVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:settingVC animated:YES];
}

//注销
- (IBAction)didClickLoginOut:(UIButton *)sender {
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self presentViewController:loginVC animated:YES completion:^{
        //退出
        [[XMPPManager instence]loginOut];
    }];
}


- (void)dealloc {
    [_photoImageView release];
    [_nameLabel release];
    [_IDLabel release];
    [_detailView release];
    [super dealloc];
}
@end