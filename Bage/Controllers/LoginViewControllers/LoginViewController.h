//
//  LoginViewController.h
//  Bage
//
//  Created by lixinda on 13-12-29.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController<UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *headerImage;
@property (retain, nonatomic) IBOutlet UITextField *UserIDTextField;
@property (retain, nonatomic) IBOutlet UITextField *UserPasswordTextField;
@property (retain, nonatomic) IBOutlet UIButton *loginButton;
@property (retain, nonatomic) IBOutlet UIButton *registerButton;


- (IBAction)loginBtnAction:(id)sender;
- (IBAction)registerBtnAction:(id)sender;

@end
