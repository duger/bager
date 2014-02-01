//
//  MyArrangeTimingCell.m
//  AllCell
//
//  Created by Adozen12 on 13-12-23.
//  Copyright (c) 2013年 lanou. All rights reserved.
//

#import "MyArrangeTimingCell.h"

@implementation MyArrangeTimingCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _testLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        _testLabel.backgroundColor=[UIColor whiteColor];
        [self addSubview:_testLabel];
        
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
