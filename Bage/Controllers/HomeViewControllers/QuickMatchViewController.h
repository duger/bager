//
//  QuickMatchViewController.h
//  Bage
//
//  Created by Duger on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuickMatchViewController : UIViewController
@property (retain, nonatomic) IBOutlet UISegmentedControl *sexSegControl;
@property (retain, nonatomic) IBOutlet UISegmentedControl *interestSegControl;

- (IBAction)didClickStartButton:(UIButton *)sender;

@end
