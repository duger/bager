//  DetailViewController.h
//  Bage
//  Created by Lori on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController <UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property(assign, nonatomic) BOOL      isSelf;  //判断是否是自己

@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *sexLabel;
@property (retain, nonatomic) IBOutlet UILabel *IDLabel;
@property (retain, nonatomic) IBOutlet UILabel *areaLabel;
@property (retain, nonatomic) IBOutlet UILabel *signatureLabel;

@property (retain, nonatomic) IBOutlet UIButton *activeRecordButton;
@property (retain, nonatomic) IBOutlet UIButton *studyProgressButton;
@property (retain, nonatomic) IBOutlet UIButton *scheduleButton;
@property (retain, nonatomic) IBOutlet UIButton *sendMessageOrAddFriendButton;
@property (retain, nonatomic) IBOutlet UIButton *applyforPartnerButton;
@property (retain, nonatomic) IBOutlet UITextField *nicknameField;
@property (retain, nonatomic) IBOutlet UITextField *sexfield;
@property (retain, nonatomic) IBOutlet UITextField *idfield;
@property (retain, nonatomic) IBOutlet UITextField *gradeField;
@property (retain, nonatomic) IBOutlet UITextField *addressField;
@property (retain, nonatomic) IBOutlet UITextField *signatureFiled;


- (IBAction)didClickCheckActiveRecord:(UIButton *)sender;
- (IBAction)didClickCheckStudyProgress:(UIButton *)sender;
- (IBAction)didClickCheckSchedule:(UIButton *)sender;
- (IBAction)didClickSendMessageOrAddFriend:(UIButton *)sender;
- (IBAction)didClickApplyforPartner:(UIButton *)sender;


@end