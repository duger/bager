//
//  FriendsPersonalCell.h
//  Bage
//
//  Created by lixinda on 13-12-24.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuddyItem.h"


@interface FriendsPersonalCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UIImageView *headerImageView;
@property (retain, nonatomic) IBOutlet UILabel *userNameLabel;
@property (retain, nonatomic) IBOutlet UIImageView *backImageView;
@property (retain, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic,retain) XMPPJID *toSomeOne;

- (IBAction)chatWithThisFucker:(id)sender;

@property (retain, nonatomic) IBOutlet UIView *BackGroundView;


-(void) setPersonAtrributeWithBuddyItem:(BuddyItem *) buddy;

@end
