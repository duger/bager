//
//  SingleGroupActiveViewController.h
//  Bage
//
//  Created by Adozen12 on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleGroupActiveViewController : UIViewController


@property (retain, nonatomic) IBOutlet UILabel *groupActiveName;

@property (retain, nonatomic) IBOutlet UILabel *groupName;

@property (retain, nonatomic) IBOutlet UILabel *groupActiveRuntime;
@property (retain, nonatomic) IBOutlet UIImageView *groupActiveImage;

@property (retain, nonatomic) IBOutlet UILabel *groupActiveIntroduce;

- (IBAction)didClickWantApply:(id)sender;






@end
