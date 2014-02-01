//
//  BageHomeViewController.h
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BageHomeViewController : UIViewController
//语言选择界面
@property (retain, nonatomic) IBOutlet UIView *languageChooseView;

//显示的主界面
@property (strong, nonatomic) IBOutlet UITableView *mainTableView;
@property (retain, nonatomic) IBOutlet UIView *darkView;
- (IBAction)didClickDackView:(UITapGestureRecognizer *)sender;

@end
