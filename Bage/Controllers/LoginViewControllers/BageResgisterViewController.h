//
//  BageResgisterViewController.h
//  Bage
//
//  Created by Duger on 14-1-14.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BageResgisterViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *titleTextField;
@property (retain, nonatomic) IBOutlet UITextField *userIdTextField;
@property (retain, nonatomic) IBOutlet UITextField *userPassward;
@property (retain, nonatomic) IBOutlet UITextField *userPasswardCheck;
@property (retain, nonatomic) IBOutlet UIButton *resigisterButton;
- (IBAction)didClcikResigister:(UIButton *)sender;
- (IBAction)didClickBackButton:(UIButton *)sender;

@end
