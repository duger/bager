//
//  SingleTopicApplyerCell.m
//  Bage
//
//  Created by Adozen12 on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "SingleTopicApplyerCell.h"

@implementation SingleTopicApplyerCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _applyerImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _applyerImage.backgroundColor=[UIColor whiteColor];
        
        self.layer.cornerRadius = 3;
        self.layer.masksToBounds = YES;
        self.clipsToBounds = YES;
        
        [self addSubview:_applyerImage];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
