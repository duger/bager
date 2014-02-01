//
//  FriendsPersonalCell.m
//  Bage
//
//  Created by lixinda on 13-12-24.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "FriendsPersonalCell.h"

@implementation FriendsPersonalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        //_headerImageView.backgroundColor=[UIColor cyanColor];
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    _BackGroundView.layer.cornerRadius = 5;
    _BackGroundView.layer.masksToBounds = YES;
    _headerImageView.layer.cornerRadius = 5;
    _headerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void) setPersonAtrributeWithDic:(NSMutableDictionary *) dic{
    
}


- (IBAction)chatWithThisFucker:(id)sender{
    NSLog(@"点到聊天啦%@",_userNameLabel.text);
    NSString *temp = _userNameLabel.text;
    [[NSNotificationCenter defaultCenter]postNotificationName:kLetsChart object:nil userInfo:@{@"result": temp}];
}

-(void) setPersonAtrributeWithBuddyItem:(BuddyItem *) buddy{
    self.headerImageView.image = buddy.headerImage;
    self.userNameLabel.text = buddy.buddyName;
}
- (void)dealloc {
    [_toSomeOne release];
    [_headerImageView release];
    [_userNameLabel release];
    [_backImageView release];
    [_BackGroundView release];
    [_detailLabel release];
    [super dealloc];
}
@end
