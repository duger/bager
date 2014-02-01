//
//  CreateTeamViewController.h
//  Bage
//
//  Created by lixinda on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"


@interface CreateTeamViewController : UIViewController <UITextFieldDelegate,UITextViewDelegate>
- (IBAction)didClickCreatTeamAction:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *roomNameTextField;
@property (retain, nonatomic) IBOutlet UITextView *roomInforTextView;

@end
