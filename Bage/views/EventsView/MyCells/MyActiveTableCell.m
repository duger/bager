//
//  MyActiveTableCell.m
//  Bage
//
//  Created by Adozen12 on 13-12-26.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "MyActiveTableCell.h"

@implementation MyActiveTableCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _parterHead=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 50, 50)];
        _parterHead.backgroundColor=[UIColor cyanColor];
        _parterHead.layer.cornerRadius=5;
        _parterHead.layer.masksToBounds=YES;
        
        _parterName=[[UILabel alloc]initWithFrame:CGRectMake(80, 20, 80, 30)];
        //_parterName.backgroundColor=[UIColor cyanColor];
        
        _parterActiveName=[[UILabel alloc]initWithFrame:CGRectMake(180, 20, 50, 30)];
        //_parterActiveName.backgroundColor=[UIColor cyanColor];
        
        _parterRuntime=[[UILabel alloc]initWithFrame:CGRectMake(240, 20, 70, 30)];
        //_parterRuntime.backgroundColor=[UIColor cyanColor];
        
        [self addSubview:_parterHead];
        [self addSubview:_parterName];
        [self addSubview:_parterActiveName];
        [self addSubview:_parterRuntime];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
