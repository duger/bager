//
//  GraphView.h
//  Graph
//
//  Created by Lori on 13-12-23.
//  Copyright (c) 2013年 陈志文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GraphView : UIView
{
    
}

@property (nonatomic, retain)NSMutableArray    *dataArray;


//重载初始化，外界传入一个数组，以这些数组建立路径绘图
- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)array;
@end
