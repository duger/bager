//
//  BagePersonalViewController.h
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BagePersonalViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIView *detailView;


@property (retain, nonatomic) IBOutlet UIImageView *photoImageView;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *IDLabel;


- (IBAction)didCLickSetting:(UIButton *)sender;
- (IBAction)didClickLoginOut:(UIButton *)sender;

@end
