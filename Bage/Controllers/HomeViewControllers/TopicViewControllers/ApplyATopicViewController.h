//
//  ApplyATopicViewController.h
//  Bage
//
//  Created by Adozen12 on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyATopicViewController : UIViewController
- (IBAction)didClickWantApply:(id)sender;
- (IBAction)didClickChooseDate:(id)sender;
- (IBAction)confirmDate:(id)sender;


@property (retain, nonatomic) IBOutlet UIDatePicker *ApplyDate;
@property (retain, nonatomic) IBOutlet UILabel *dateLabel;
@property (retain, nonatomic) IBOutlet UILabel *timeLabel;
@property (retain, nonatomic) IBOutlet UIButton *applyNow;

@property (retain, nonatomic) IBOutlet UIButton *confirmDateButton;

@property (retain, nonatomic) IBOutlet UISegmentedControl *wantedPartnerSex;
@property (retain, nonatomic) IBOutlet UISegmentedControl *wantedPartnerSpokenLv;

@property (nonatomic,assign) NSTimeInterval applytimeInterval;
@end
