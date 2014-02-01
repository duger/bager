//
//  ShowMyGroupActiveCell.m
//  Bage
//
//  Created by Adozen12 on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "ShowMyGroupActiveCell.h"

@implementation ShowMyGroupActiveCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _frameView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 160)];
        _frameView.backgroundColor=[UIColor clearColor];
        
        _backView=[[UIView alloc]initWithFrame:CGRectMake(10, 10, 300, 150)];//左右10上下间隔5*2
        _backView.backgroundColor=[UIColor cyanColor];
        
        _GroupActiveImageView=[[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 190, 90)];
        [_GroupActiveImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_GroupActiveImageView setClipsToBounds:YES];
        //        _GroupActiveImageView=[UIColor whiteColor];
        
        _GroupActiveIntroduce=[[UILabel alloc]initWithFrame:CGRectMake(30, 105, 240, 40)];
        _GroupActiveIntroduce.font=[UIFont systemFontOfSize:10.0f];
        //_GroupActiveIntroduce=UILineBreakModeCharacterWrap;
        _GroupActiveIntroduce.numberOfLines=2;
        //_GroupActiveIntroduce=[UIColor whiteColor];
        
        _GroupActiveName=[[UILabel alloc]initWithFrame:CGRectMake(10, 20, 90, 30)];
        _GroupActiveName.font=[UIFont systemFontOfSize:14.0f];
        _GroupActiveName.textAlignment=NSTextAlignmentCenter;
        //_GroupActiveName.backgroundColor=[UIColor greenColor];
        
        _GroupActiveRunTime=[[UILabel alloc]initWithFrame:CGRectMake(20, 60, 70, 30)];
        _GroupActiveRunTime.font=[UIFont systemFontOfSize:12.0f];
        _GroupActiveRunTime.textAlignment=NSTextAlignmentCenter;
        //_GroupActiveRunTime.backgroundColor=[UIColor greenColor];
        
        [self addSubview:_frameView];
        [_frameView addSubview:_backView];
        [_backView addSubview:_GroupActiveImageView];
        [_backView addSubview:_GroupActiveIntroduce];
        [_backView addSubview:_GroupActiveName];
        [_backView addSubview:_GroupActiveRunTime];
        
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
