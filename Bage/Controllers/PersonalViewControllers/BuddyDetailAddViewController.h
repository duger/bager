//
//  BuddyDetailAddViewController.h
//  Bage
//
//  Created by lixinda on 13-12-31.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddyItem.h"

@interface BuddyDetailAddViewController : UIViewController
- (IBAction)didClickAddBuddyAction:(id)sender;
@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) BuddyItem * buddyItem;

@end
