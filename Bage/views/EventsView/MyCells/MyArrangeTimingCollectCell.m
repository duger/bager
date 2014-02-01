//
//  MyArrangeTimingCollectCell.m
//  AllCell
//
//  Created by Adozen12 on 13-12-25.
//  Copyright (c) 2013年 lanou. All rights reserved.
//

#import "MyArrangeTimingCollectCell.h"

@implementation MyArrangeTimingCollectCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _weekToWeek=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 49)];
        
        [self addSubview:_weekToWeek];
        
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
