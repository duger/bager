//  ApplyATopicViewController.m
//  Bage
//  Created by Adozen12 on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.

#import "ApplyATopicViewController.h"
#import "MatchManger.h"
#import "NSString+Addtions.h"


#import "MZFormSheetController.h"

//状态栏第三方类
#import "JDStatusBarNotification.h"

@interface ApplyATopicViewController ()
{
    NSArray *timeTotime;
    NSDate *nowTime;
    NSString *nowTimeDate;
    NSString *nowTimeTime;
    
    BOOL isPickedDate;
    
    
    //性别 男女 上传用的text
    NSString *wantedsex;
    NSString *wantedSpokenLv;
    
}
@end

@implementation ApplyATopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        timeTotime=[[NSArray alloc]init];
        nowTime=[[NSDate alloc]init];
        isPickedDate = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _ApplyDate.hidden=YES;
    timeTotime=[@[@"00:00-02:00",@"02:00-04:00",@"04:00-06:00",@"06:00-08:00",@"08:00-10:00",@"10:00-12:00",@"12:00-14:00",@"14:00-16:00",@"16:00-18:00",@"18:00-20:00",@"20:00-22:00",@"22:00-24:00"]retain];
    
    _ApplyDate.datePickerMode=UIDatePickerModeDateAndTime;
    
    //seg
    [_wantedPartnerSex addTarget:self action:@selector(didChooseSex:) forControlEvents:UIControlEventValueChanged];
    _wantedPartnerSex.selectedSegmentIndex = 0;
    
    [_wantedPartnerSpokenLv addTarget:self action:@selector(didChooseLv:) forControlEvents:UIControlEventValueChanged];
    _wantedPartnerSpokenLv.selectedSegmentIndex = 0;
    
    [self didChooseSex:_wantedPartnerSex];
    [self didChooseLv:_wantedPartnerSpokenLv];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//seg
-(void)didChooseSex:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            wantedsex=@"男";
            break;
        case 1:
            wantedsex=@"女";
            break;
        case 2:
            wantedsex=@"随意";
            break;
        default:
            break;
    }
}

-(void)didChooseLv:(UISegmentedControl *)seg
{
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            wantedSpokenLv=@"菜鸟";
            break;
        case 1:
            wantedSpokenLv=@"一般";
            break;
        case 2:
            wantedSpokenLv=@"口水";
            break;
        default:
            break;
    }
}


- (IBAction)didClickWantApply:(id)sender {
    
    NSLog(@"sex+lv %@ --- %@",wantedsex,wantedSpokenLv);
    NSString *jid = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    //NSString *
    
    NSString *requist = [NSString stringWithQuickUpdatePersonJid:jid Sex:self.wantedPartnerSex.selectedSegmentIndex topicType:-1 topicId:-1 runTime:_applytimeInterval partnerSpokenLV:self.wantedPartnerSpokenLv.selectedSegmentIndex language:-1];
    NSLog(@"%@",requist);
    
    [[MatchManger defaultManager]quickMatchUpdate:requist];
    
    [self mz_dismissFormSheetControllerAnimated:YES completionHandler:nil];
    [JDStatusBarNotification showWithStatus:@"申请成功！" dismissAfter:2 styleName:JDStatusBarStyleSuccess];
}

- (IBAction)didClickChooseDate:(id)sender
{
    CGPoint centerPoint = self.view.frame.origin;
    [UIView animateWithDuration:0.4 animations:^{
        self.view.frame  =CGRectMake(centerPoint.x,centerPoint.y, 300, 400);
        self.confirmDateButton.frame = CGRectMake(128, 112, 57, 30);
    }];
    CATransition *transition = [[CATransition alloc]init];
    transition.duration = 0.4;
    transition.type = kCATransitionFade;
    [_ApplyDate.layer addAnimation:transition forKey:@"applyDate"];
    [_applyNow.layer addAnimation:transition forKey:@"applyNow"];
    [transition release];
    _ApplyDate.hidden=NO;
    _applyNow.hidden=YES;
    
}
- (IBAction)confirmDate:(id)sender
{
    if (isPickedDate) {
        isPickedDate = !isPickedDate;
        [_confirmDateButton setTitle:@"选取" forState:UIControlStateNormal];
        if (_ApplyDate.hidden==NO)
        {
            _ApplyDate.date=[_ApplyDate.date dateByAddingTimeInterval:8*60*60];
            NSString *mystr=[NSString stringWithFormat:@"%@",[_ApplyDate.date description]];

            _applytimeInterval= [_ApplyDate.date timeIntervalSince1970];
            //NSDate *aaaaadate=[NSDate dateWithTimeIntervalSince1970:_applytimeInterval];
            //NSLog(@"145 aaaadate===== %@",aaaaadate);
            
            NSString *datestr=[mystr substringWithRange:NSMakeRange(0, 10)];
            NSString *timestr=[mystr substringWithRange:NSMakeRange(11, 2)];
            NSInteger hour=[timestr intValue];
            NSInteger hournumber=0;
            if (hour%2==0) {
                hournumber=hour/2+1;
            }
            if (hour%2!=0) {
                hournumber=hour/2+1;
            }
            nowTime=[NSDate date];
            nowTime=[nowTime dateByAddingTimeInterval:8*60*60];
            NSString *nownow=[nowTime description];
            
            NSComparisonResult compresult=[nownow compare:mystr];
            if (compresult==-1)
            {
                if (hour>=22) {
                    _ApplyDate.date=[_ApplyDate.date dateByAddingTimeInterval:24*60*60];
                    NSString *mystr1=[NSString stringWithFormat:@"%@",[_ApplyDate.date description]];
                    NSString *datestr1=[mystr1 substringWithRange:NSMakeRange(0, 10)];
                    _dateLabel.text=datestr1;
                    _timeLabel.text=[timeTotime objectAtIndex:0];
                }
                if(hour<22)
                {
                    _dateLabel.text=datestr;
                    _timeLabel.text=[timeTotime objectAtIndex:hournumber];
                }
                
            }
        }
        _dateLabel.font=[UIFont systemFontOfSize:16.0f];
        
        CGPoint centerPoint = self.view.frame.origin;
        
        [UIView animateWithDuration:0.4 animations:^{
            
            self.view.frame  =CGRectMake(centerPoint.x,centerPoint.y, 300, 200);
            self.confirmDateButton.frame = CGRectMake(242, 112, 57, 30);
        }];
        CATransition *transition = [[CATransition alloc]init];
        transition.duration = 0.4;
        transition.type = kCATransitionFade;
        [_ApplyDate.layer addAnimation:transition forKey:@"applyDate"];
        [_applyNow.layer addAnimation:transition forKey:@"applyNow"];
        [transition release];
        _ApplyDate.hidden=YES;
        _applyNow.hidden=NO;
        
    }else{
        isPickedDate = !isPickedDate;
        [_confirmDateButton setTitle:@"确定" forState:UIControlStateNormal];
        [self didClickChooseDate:nil];
    }
    
    
    
    
}

- (void)dealloc {
    [_ApplyDate release];
    [_dateLabel release];
    [_timeLabel release];
    [_applyNow release];
    
    [_confirmDateButton release];
    
    [_wantedPartnerSex release];
    [_wantedPartnerSpokenLv release];
    
    [super dealloc];
}

@end