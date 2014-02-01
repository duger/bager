//
//  GoodLuckMatchViewController.m
//  Bage
//
//  Created by Duger on 14-1-14.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "GoodLuckMatchViewController.h"
#import "MZCustomTransition.h"
#import "MatchManger.h"
#import "JDStatusBarNotification.h"

@interface GoodLuckMatchViewController ()

@end

@implementation GoodLuckMatchViewController

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

- (IBAction)didClickButton:(UIButton *)sender {
    NSString *personJid = [[NSUserDefaults standardUserDefaults]objectForKey:kUserName];
    //runTime空值为0  其他为-1 或0
    NSString *updateStr = [NSString stringWithQuickUpdatePersonJid:personJid
                                                               Sex:0
                                                         topicType:0
                                                           topicId:0
                                                           runTime:0
                                                   partnerSpokenLV:0
                                                          language:0];

    
    [[MatchManger defaultManager]quickMatchUpdate:updateStr];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [JDStatusBarNotification showWithStatus:@"申请成功！" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
    
}
@end
