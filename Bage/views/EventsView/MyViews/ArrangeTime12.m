//
//  ArrangeTime12.m
//  AllCell
//
//  Created by Adozen12 on 13-12-24.
//  Copyright (c) 2013年 lanou. All rights reserved.
//

#import "ArrangeTime12.h"
#import "MyArrangeTimingTableCell.h"

@implementation ArrangeTime12

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.frame=CGRectMake(0, 0, 50, 455-14+200+150+100+100);
        self.dataSource=self;
        self.delegate=self;
        self.userInteractionEnabled=NO;
        self.bounces=NO;
    }
    return self;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 12+1;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54.0f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MyArrangeTimingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell=[[[MyArrangeTimingTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    int num=0;
    num=indexPath.row;
    NSString *timeListShow=[NSString stringWithFormat:@"%d:00-%d:00",num*2,(num+1)*2];
    cell.timeToTime.text=timeListShow;
    cell.timeToTime.textAlignment=NSTextAlignmentCenter;
    cell.timeToTime.font=[UIFont systemFontOfSize:8.0f];
    
    
    //NSLog(@"%@",timeListShow);
    return cell;
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
