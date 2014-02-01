//
//  BageResgisterViewController.m
//  Bage
//
//  Created by Duger on 14-1-14.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "BageResgisterViewController.h"
#import "XMPPManager.h"
#import "MMProgressHUD.h"

@interface BageResgisterViewController ()

@end

@implementation BageResgisterViewController

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
    //加观察者
    [self _addNotifications];
    
    //点击屏幕去键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self.userPassward action:@selector(resignFirstResponder)];
    [tapGes addTarget:self.userIdTextField action:@selector(resignFirstResponder)];
    [tapGes addTarget:self.userPasswardCheck action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tapGes];
    [tapGes release];
    
    [self makeViewsCornerRound];
    
    self.userPasswardCheck.delegate = self;

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [_userIdTextField release];
    [_userPassward release];
    [_resigisterButton release];
    [_titleTextField release];
    [_userPasswardCheck release];
    [super dealloc];
}

-(void)makeViewsCornerRound
{
    self.titleTextField.layer.cornerRadius = 5;
    self.titleTextField.layer.masksToBounds = YES;
    self.resigisterButton.layer.cornerRadius = 5;
    self.resigisterButton.layer.masksToBounds = YES;

    self.userIdTextField.layer.cornerRadius = 5;
    self.userIdTextField.layer.masksToBounds = YES;
    self.userPassward.layer.cornerRadius = 5;
    self.userPassward.layer.masksToBounds = YES;
    self.userPasswardCheck.layer.cornerRadius = 5;
    self.userPasswardCheck.layer.masksToBounds = YES;
    
}

- (IBAction)didClcikResigister:(UIButton *)sender {
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"注册" status:@"注册中..." cancelBlock:^{
        //取消选项
        [[XMPPManager instence].xmppStream disconnect];
    }];
    [self resigisterCheckRules];
   
}

- (IBAction)didClickBackButton:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(void)resigisterCheckRules
{
    if (self.userIdTextField.text.length < 5) {
        NSLog(@"昵称必须大于6位");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                            message:@"昵称必须大于6位！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    
    if(self.userPassward.text.length < 4)
    {
        NSLog(@"密码必须大于6位");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                            message:@"密码必须大于6位！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        return;
    }
    if(![self.userPassward.text isEqualToString: self.userPasswardCheck.text])
    {
        
        NSLog(@"两次密码不一样");
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"注册失败"
                                                            message:@"两次密码不一样！"
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
        return;
    }
   
    if (self.userIdTextField.text.length >= 5 && [self.userPassward.text isEqual:self.userPasswardCheck.text] && self.userPassward.text.length >= 4)
    {
        
        //xmppManager 注册
        [[XMPPManager instence]registerInSide:self.userIdTextField.text andPassword:self.userPassward.text];
        return;
    }
    else
    {
        NSLog(@"注册失败");
    }

}

#pragma mark - Notificaton Methods
-(void)_addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didResigterSuccess:) name:kResigterSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didResigterWithError:) name:kResigterError object:nil];
}

-(void)didResigterSuccess:(id)sender
{
   
    
    [MMProgressHUD dismissWithSuccess:@"注册成功!"];
    [self dismissViewControllerAnimated:YES completion:^{
        nil;
    }];
    
}

-(void)didResigterWithError:(id)sender
{
    NSString *message = [[sender userInfo]objectForKey:@"result"];
    [MMProgressHUD dismissWithError:message title:@"注册失败"];
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
}






#pragma - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self didClcikResigister:nil];
    [textField resignFirstResponder];
    return YES;
}


@end
