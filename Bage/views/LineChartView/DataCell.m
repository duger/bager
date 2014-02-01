//
//  DataCell.m
//  Graph
//
//  Created by Lori on 13-12-24.
//  Copyright (c) 2013年 陈志文. All rights reserved.
//

#import "DataCell.h"

@implementation DataCell
- (void)dealloc
{
    [_dateLabel release];
    [super dealloc];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.dateLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 0, 38, 45)] autorelease];
        _dateLabel.transform = CGAffineTransformMakeRotation(M_PI / 2);
        _dateLabel.textAlignment = 1;
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        [self addSubview:_dateLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
