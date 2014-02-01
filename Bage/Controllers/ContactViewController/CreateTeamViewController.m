//
//  CreateTeamViewController.m
//  Bage
//
//  Created by lixinda on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "CreateTeamViewController.h"

@interface CreateTeamViewController ()

@end

@implementation CreateTeamViewController
{
    NSString * fieldTempStr;
    NSString * viewTempStr;
    BOOL editType;//yes:fieldTempStr no:viewTempStr
}
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
    self.roomInforTextView.inputAccessoryView = [self keyboardAddButton];
    self.roomNameTextField.inputAccessoryView = [self keyboardAddButton];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didClickCreatTeamAction:(id)sender {
    if ([self.roomNameTextField.text isEqualToString:@""]) {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入房间名" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alertView show];
    }
    [[XMPPManager instence]createXMPPRoom:self.roomNameTextField.text];

}
- (void)dealloc {
    [_roomNameTextField release];
    [_roomInforTextView release];
    [super dealloc];
}
#pragma mark - textField Delegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.roomNameTextField resignFirstResponder];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    fieldTempStr =textField.text;
    editType = YES;
}
#pragma mark - textView Delegate -
- (void)textViewDidBeginEditing:(UITextView *)textView{
    viewTempStr = textView.text;
    editType = NO;
}
#pragma mark - private methods -
-(UIView *) keyboardAddButton{
    UIView * keyboardView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    keyboardView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:246.0/255.0 blue:247.0/255.0 alpha:1];
    CGRect btnRect = CGRectMake(0, 0, 30, 24);
    
    UIButton * compBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [compBtn setTitle:@"完成" forState:UIControlStateNormal];
    [compBtn addTarget:self action:@selector(didClickCompletedKeboard:) forControlEvents:UIControlEventTouchUpInside];
    compBtn.bounds = btnRect;
    compBtn.center = CGPointMake(320-10-15, 15);
    [keyboardView addSubview:compBtn];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelBtn.center = CGPointMake(10+15, 15);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(didClickCancelKeboard:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.bounds = btnRect;
    [keyboardView addSubview:cancelBtn];
    
    return keyboardView;
}

-(void)didClickCancelKeboard:(id)sender{
    if (editType) {
        self.roomNameTextField.text = fieldTempStr;
        [self.roomNameTextField resignFirstResponder];
    }else{
        self.roomInforTextView.text = viewTempStr;
        [self.roomInforTextView resignFirstResponder];
    }
}
-(void)didClickCompletedKeboard:(id)sender{
    [self.roomNameTextField resignFirstResponder];
    [self.roomInforTextView resignFirstResponder];
}
@end
