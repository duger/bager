//
//  ShowMyTopicListCell.m
//  Bage
//
//  Created by Adozen12 on 14-1-10.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "ShowMyTopicListCell.h"

@implementation ShowMyTopicListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _frameView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
        _frameView.backgroundColor=[UIColor clearColor];
        
        _backView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 150)];//左右10上下间隔5*2
        _backView.backgroundColor=[UIColor cyanColor];
        _backView.layer.cornerRadius = 7;
        _backView.layer.masksToBounds = YES;
        
        _topicImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 190, 90)];
        [_topicImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_topicImageView setClipsToBounds:YES];
        _topicImageView.layer.cornerRadius = 5;
        _topicImageView.layer.masksToBounds = YES;
//        _topicImageView.backgroundColor=[UIColor whiteColor];
        
        _topicIntroduce=[[UILabel alloc]initWithFrame:CGRectMake(25, 105, 245, 45)];
        _topicIntroduce.font=[UIFont systemFontOfSize:13.0f];
        //_topicIntroduce.lineBreakMode=UILineBreakModeCharacterWrap;
        _topicIntroduce.numberOfLines=2;
        //_topicIntroduce.backgroundColor=[UIColor whiteColor];
        
        _topicName=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 90, 30)];
        _topicName.font=[UIFont systemFontOfSize:16.0f];
        _topicName.textAlignment=NSTextAlignmentCenter;
        //_topicName.backgroundColor=[UIColor greenColor];
        
        _topicUpdateTime=[[UILabel alloc]initWithFrame:CGRectMake(20, 70, 70, 30)];
        _topicUpdateTime.font=[UIFont systemFontOfSize:10.0f];
        _topicUpdateTime.textAlignment=NSTextAlignmentCenter;
        //_topicUpdateTime.backgroundColor=[UIColor greenColor];
        
        [self addSubview:_frameView];
        [_frameView addSubview:_backView];
        [_backView addSubview:_topicImageView];
        [_backView addSubview:_topicIntroduce];
        [_backView addSubview:_topicName];
        [_backView addSubview:_topicUpdateTime];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
