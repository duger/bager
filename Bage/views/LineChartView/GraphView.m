//
//  GraphView.m
//  Graph
//
//  Created by Lori on 13-12-23.
//  Copyright (c) 2013年 陈志文. All rights reserved.
//

#import "GraphView.h"

@implementation GraphView

- (void)dealloc
{
    [_dataArray release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)array
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
        self.dataArray = array;

        self.layer.anchorPoint = CGPointMake(0,0);      //锚点
        self.alpha = 0.8;
        self.transform = CGAffineTransformMakeRotation( - M_PI / 2);    //逆时针旋转90°
        self.layer.position = CGPointMake(40,31*kPageWidth);
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 1.0f;
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //蓝色区域
   [self startDrawWithArray:[self handleArray:[_dataArray objectAtIndex:2]]
             fillColorWithColor:[UIColor blueColor].CGColor];
    //绿色区域
    [self startDrawWithArray:[self handleWithBasedArray:[_dataArray objectAtIndex:0] array:[_dataArray objectAtIndex:1]]
          fillColorWithColor:[UIColor greenColor].CGColor];
    //红色区域
    [self startDrawWithArray:[self covertArray:[_dataArray objectAtIndex:0]]
          fillColorWithColor:[UIColor redColor].CGColor];
}

//以数组数据 和 填充颜色 开始绘图
- (void)startDrawWithArray:(NSArray *)array
                        fillColorWithColor:(CGColorRef)color
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path,NULL, 0, 0);     //坐标原点开始
    for (int i = 0; i < array.count; i++)
    {
        CGPathAddLineToPoint(path, NULL, kPageWidth*i, [[array objectAtIndex:i] floatValue]);
    }
    CGPathAddLineToPoint(path, NULL, (array.count-1)*kPageWidth, 0);
    CGPathAddLineToPoint(path, NULL, 0, 0);//坐标原点结束
    CGContextSetFillColorWithColor(context, color);
    CGContextAddPath(context, path);            //将路径添加到上下文
    CGContextFillPath(context);                 //填充路径
    CGPathRelease(path);                        //释放路径

}

//将传入的数组逆序
- (NSMutableArray *)covertArray:(NSArray *)array
{
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (int i = array.count -1; i >= 0; i--) {
        [newArray addObject:[array objectAtIndex:i]];
    }
    return [newArray autorelease];
}

//基于第一组数据(红色区域) 处理第二组数据（绿色区域）
- (NSMutableArray *)handleWithBasedArray:(NSArray *)basedArray array:(NSArray *)array
{
    NSMutableArray *temp1 = [self covertArray:basedArray];
    NSMutableArray *temp2 = [self covertArray:array];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < temp1.count; i++) {
        float temp1Value = [[temp1 objectAtIndex:i] floatValue];
        float temp2Value = [[temp2 objectAtIndex:i] floatValue];
        float value = temp1Value +temp2Value;
        [newArray addObject:[NSString stringWithFormat:@"%f",value]];
    }
    return [newArray autorelease];
}

//基于第二组数据(绿色区域)处理结果 处理第三组数据（蓝色区域）
- (NSMutableArray *)handleArray:(NSArray *)array
{
    NSMutableArray *temp1 = [self handleWithBasedArray:[_dataArray objectAtIndex:0] array:[_dataArray objectAtIndex:1]];
    NSMutableArray *temp2 = [self covertArray:array];
    NSMutableArray *newArray = [[NSMutableArray alloc] init];
    for (int i = 0; i < temp1.count; i++) {
        float temp1Value = [[temp1 objectAtIndex:i] floatValue];
        float temp2Value = [[temp2 objectAtIndex:i] floatValue];
        float value = temp1Value +temp2Value;
        [newArray addObject:[NSString stringWithFormat:@"%f",value]];
    }
    return [newArray autorelease];
}


@end
