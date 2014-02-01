//
//  DataTableView.h
//  Graph
//
//  Created by Lori on 13-12-24.
//  Copyright (c) 2013年 陈志文. All rights reserved.
//

//该类封装了一个逆时针旋转90°的tableView视图，上面承载了GraphView的一个实例（曲线视图）以及相关视图的所有数据。
#import <UIKit/UIKit.h>
#import "DataModel.h"

@class DataTableView;
@protocol DataTableViewDelegate <NSObject>
@optional
//返回一个DataModel实例对象(包含 日期，总和，值1，值2，值3)
- (void)dateTableView:(DataTableView*)dateTableView dataModel:(DataModel *)dataModel;

@end

@interface DataTableView : UITableView <UITableViewDataSource,UITableViewDelegate, UIScrollViewDelegate>
{
    
}

@property (nonatomic, retain)NSMutableArray    *dataArray;

@property (nonatomic, assign)id <DataTableViewDelegate> aDelegate;


//重载初始化方法，要求传入一个数组(包含折线图三种不同数据的数组)。
- (id)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)array;

@end

