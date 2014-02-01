//
//  BageCell.m
//  Bage
//
//  Created by Lori on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "BageCell.h"

@implementation BageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier cellType:(BageCellType)type
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        switch (type) {
            case 0:
                self.aView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width - 140,(self.frame.size.height - 40)/2, 120, 40)];
                [self addSubview:_aView];
                [_aView release];
                _aView.backgroundColor = [UIColor blueColor];
                break;
            case 1:
            {
                //名次标签
                self.aRank = [[UILabel alloc] initWithFrame:CGRectMake(3, 5, 40, 40)];
                [self addSubview: _aRank];
                [_aRank release];
                _aRank.backgroundColor = [UIColor redColor];
                
                //头像视图
                self.aImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.aRank.frame.size.width + 5, 5, 40, 40)];
                [self addSubview:_aImageView];
                self.aImageView.layer.cornerRadius = 18.0f;
                [_aImageView release];
                _aImageView.backgroundColor = [UIColor greenColor];
                
                //账号标签
                self.aID = [[UILabel alloc] initWithFrame:CGRectMake(self.aImageView.frame.origin.x + self.aImageView.frame.size.width + 5, 5, 130, 40)];
                [self addSubview: _aID];
                [_aID release];
                _aID.backgroundColor = [UIColor redColor];
                
                //名次标签
                self.aScore = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 90, 5, 80, 40)];
                [self addSubview: _aScore];
                [_aScore release];
                _aScore.backgroundColor = [UIColor blackColor];
            }
                break;
                
            default:
                break;
        }
      
    }
    return self;
}
- (void)dealloc
{
    [_aView release];
    
    [_aRank release];
    [_aImageView release];
    [_aID release];
    [_aScore release];
    [super dealloc];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
