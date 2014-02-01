//
//  LoginViewController.m
//  Bage
//
//  Created by lixinda on 13-12-29.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "LoginViewController.h"
#import "MMProgressHUD.h"
#import "BageResgisterViewController.h"
#import "BageRootViewController.h"
#import "XMPPManager.h"

@interface LoginViewController ()

-(void)_addNotifications;


@end

@implementation LoginViewController

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
    //界面圆角
    [self _makeViewsCornerRound];
    //加观察者
    [self _addNotifications];
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID]) {
        self.UserIDTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyPassword]) {
        self.UserPasswordTextField.text = [[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyPassword];
    }
    
    //点击屏幕去键盘
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self.UserIDTextField action:@selector(resignFirstResponder)];
    [tapGes addTarget:self.UserPasswordTextField action:@selector(resignFirstResponder)];
    [self.view addGestureRecognizer:tapGes];
    [tapGes release];
    
    self.UserPasswordTextField.delegate = self;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kLoginedError object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kLoginedSuccess object:nil];
    [_headerImage release];
    [_UserIDTextField release];
    [_UserPasswordTextField release];
    [_loginButton release];
    [_registerButton release];
    [super dealloc];
}

//登陆
- (IBAction)loginBtnAction:(id)sender {
    NSLog(@"登陆成功");

    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleFade];
    [MMProgressHUD showWithTitle:@"登陆" status:@"连接中..." cancelBlock:^{
    //取消选项
        [[XMPPManager instence].xmppStream disconnect];
    }];
    
    [self _loginCheckRules];
    
}

-(void)_loginCheckRules
{
    if ( [self.UserIDTextField.text isEqualToString:@""]||[self.UserPasswordTextField.text isEqualToString:@""])
    {
        
        [MMProgressHUD dismissWithError:@"请输入用户名或者密码!" title:@"错误"];
        NSLog(@"登陆错误");
        
    }else
    {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
        [[NSUserDefaults standardUserDefaults] setObject:self.UserIDTextField.text forKey:kXMPPmyJID];
        [[NSUserDefaults standardUserDefaults] setObject:self.UserPasswordTextField.text forKey:kXMPPmyPassword];
        //连接网络
        [[XMPPManager instence]connect];
        [self performSelector:@selector(isConectedOrNot:) withObject:nil afterDelay:kLoginOutOfTime];
    }

}

-(void)isConectedOrNot:(id)sender
{
    if ([[XMPPManager instence].xmppStream isDisconnected]) {
        [MMProgressHUD dismissWithError:@"请检查网络!" title:@"登陆超时" afterDelay:1.0f];
    }
    
}

//注册
- (IBAction)registerBtnAction:(id)sender {
    BageResgisterViewController *resigsterVC = [[BageResgisterViewController alloc]init];
    [self presentViewController:resigsterVC animated:YES completion:nil];
    [resigsterVC release];
    
}

#pragma mark - Private Methods
-(void)_makeViewsCornerRound
{
    self.loginButton.layer.cornerRadius = 5;
    self.loginButton.layer.masksToBounds = YES;
    self.registerButton.layer.cornerRadius = 5;
    self.registerButton.layer.masksToBounds = YES;
    self.headerImage.layer.cornerRadius = 10;
    self.headerImage.layer.masksToBounds = YES;
    self.UserIDTextField.layer.cornerRadius = 5;
    self.UserIDTextField.layer.masksToBounds = YES;
    self.UserPasswordTextField.layer.cornerRadius = 5;
    self.UserPasswordTextField.layer.masksToBounds = YES;
    

}




#pragma mark - Notificaton Methods
-(void)_addNotifications
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginedSuccess:) name:kLoginedSuccess object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didLoginedWithError:) name:kLoginedError object:nil];
}

-(void)didLoginedSuccess:(id)sender
{
//    NSString *message = [[[sender userInfo]objectForKey:@"result"] copy];
    if (![[NSUserDefaults standardUserDefaults]boolForKey:kLoginOrNot]) {
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:kLoginOrNot];
    }
    
    [MMProgressHUD dismissWithSuccess:@"Enjoy!"];
    
    BageRootViewController *rootVC = [[BageRootViewController alloc]init];
    rootVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    rootVC.modalPresentationStyle = UIModalPresentationCurrentContext;
    [self presentViewController:rootVC animated:YES completion:^{
        [[[UIApplication sharedApplication]keyWindow]setRootViewController:rootVC];
    }];
}

-(void)didLoginedWithError:(id)sender
{
    NSString *message = [[sender userInfo]objectForKey:@"result"];
    [MMProgressHUD dismissWithError:message title:@"登陆失败" afterDelay:1.3f];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
}



#pragma mark - textField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self loginBtnAction:nil];
    [textField resignFirstResponder];
    return YES;
}
@end
