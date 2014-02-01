//
//  AddBuddyViewController.h
//  Bage
//
//  Created by lixinda on 13-12-29.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddBuddyViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
@property (retain, nonatomic) IBOutlet UITextField *seachTextField;
- (IBAction)seachButtonAction:(id)sender;
@property (retain, nonatomic) IBOutlet UITableView *seachResultTableView;

@end
