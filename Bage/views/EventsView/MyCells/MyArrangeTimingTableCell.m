//
//  MyArrangeTimingTableCell.m
//  AllCell
//
//  Created by Adozen12 on 13-12-25.
//  Copyright (c) 2013年 lanou. All rights reserved.
//

#import "MyArrangeTimingTableCell.h"

@implementation MyArrangeTimingTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _timeToTime=[[UILabel alloc]initWithFrame:CGRectMake(2, 10, 48, 30)];
        
        [self addSubview:_timeToTime];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
