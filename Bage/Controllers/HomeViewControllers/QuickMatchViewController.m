//
//  QuickMatchViewController.m
//  Bage
//
//  Created by Duger on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "QuickMatchViewController.h"
#import "MatchManger.h"
#import "NSString+Addtions.h"
#import "MZFormSheetController.h"

//状态栏第三方类
#import "JDStatusBarNotification.h"

#import "QucikMatchMessage.h"


@interface QuickMatchViewController ()

@end

@implementation QuickMatchViewController

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
    [_sexSegControl release];
    [_interestSegControl release];
    [super dealloc];
}
- (IBAction)didClickStartButton:(UIButton *)sender {
    
    NSString *personJid =[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    NSInteger sex = self.sexSegControl.selectedSegmentIndex;
    NSInteger toppicType = self.interestSegControl.selectedSegmentIndex;
    NSDate *dateForQuickMatch=[NSDate date];
    NSTimeInterval timeIntervalForQuickMatch=[dateForQuickMatch timeIntervalSince1970];
    
    NSString *updateStr = [NSString stringWithQuickUpdatePersonJid:personJid
                                                               Sex:sex
                                                         topicType:toppicType
                                                           topicId:-1
                                                           runTime:timeIntervalForQuickMatch
                                                   partnerSpokenLV:-1
                                                          language:-1];
//    QucikMatchMessage *matchMess = [[QucikMatchMessage alloc]init];
//    [matchMess setPersonJid:personJid];
//    [matchMess setSex:sex];
//    [matchMess setTopicType:toppicType];
//    NSString *tempStr = [matchMess createPostRequire];
//    NSLog(@"%@",tempStr);
    
    [[MatchManger defaultManager]quickMatchUpdate:updateStr];
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [JDStatusBarNotification showWithStatus:@"申请成功！" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
}
@end
