//
//  DataModel.h
//  Graph
//
//  Created by Lori on 13-12-25.
//  Copyright (c) 2013年 陈志文. All rights reserved.
//

//该类用于封装折线视图上数据
#import <Foundation/Foundation.h>

@interface DataModel : NSObject
{
    
}
@property (nonatomic,copy)NSString   *date;     //日期
@property (nonatomic,copy)NSString   *sum;      //总和
@property (nonatomic,copy)NSString   *value1;   //值1 （红色）
@property (nonatomic,copy)NSString   *value2;   //值2  (绿色）
@property (nonatomic,copy)NSString   *value3;   //值3 （蓝色）

- (id)initWithDataWithDate:(NSString *)date
                       sum:(NSString *)sum
                    value1:(NSString *)value1
                    value2:(NSString *)value2
                    value3:(NSString *)value3;

@end
