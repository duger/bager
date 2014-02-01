//  DataTableView.m
//  Graph
//  Created by Lori on 13-12-24.
//  Copyright (c) 2013年 陈志文. All rights reserved.


#import "DataTableView.h"
#import "GraphView.h"
#import "DataCell.h"


@implementation DataTableView
{
    UIImageView         *_horizLine;        //水平线
    UILabel             *_horizData;        //水平线的数据标签
    GraphView           *_graphView;        //折线图
    UILabel             *_verticLine;       //垂直线
    UILabel             *_verticData;       //垂直线的数据标签
    NSInteger           _cellIndex;         //用于标记当前的Cell的值
    DataModel           *_dataModel;        //数据模型对象
}
- (void)dealloc
{
    [_dataArray release];
    [_horizLine release];
    [_horizData release];
    [_graphView release];
    [_verticLine release];
    [_verticData release];
    [_dataModel release];
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame dataArray:(NSMutableArray *)array
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
//        self.frame = CGRectMake(5, 0, 100, 260);
        self.dataSource = self;
        self.delegate = self;
        self.layer.anchorPoint = CGPointMake(0, 0); //锚点
        self.transform = CGAffineTransformMakeRotation( - M_PI / 2);//旋转
        if (IS_IPHONE5) {
            if (ScreenHeight) {
                self.layer.position = CGPointMake(10, 520); //原点
            }
            else{
                self.layer.position = CGPointMake(10, 450); //原点
            }
        }
        else{
            if (ScreenHeight) {
                self.layer.position = CGPointMake(10, 450); //原点
            }
            else{
                self.layer.position = CGPointMake(10, 430); //原点
            }
        }
        self.clipsToBounds = NO;
        self.showsVerticalScrollIndicator = NO;
    
        self.dataArray = array; //接收传进来的数组
        _dataModel = [[DataModel alloc] init];
      
        //折线图
        _graphView = [[GraphView alloc] initWithFrame:CGRectMake(0, 20, 31*kPageWidth, 200 )
                                                array:_dataArray];
        [self addSubview:_graphView];
        
        //水平线及其数据视图
        [self _addHorizLine];
        //垂直线及其数据视图
        [self _addVerticLine];
        
        //添加长按手势 用于显示和隐藏水平标尺线
        UILongPressGestureRecognizer * longPressGesture = [[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(showHoriz:)] autorelease];
        longPressGesture.minimumPressDuration = 0.2;
        [self addGestureRecognizer:longPressGesture];
        
        //让表视图默认活动到最后一行Cell
        [self _tableViewScrcrollToBottom];
        }
    return self;
}

#pragma mark ***Private Methods***
//添加水平线
- (void)_addHorizLine
{
    _horizLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _graphView.frame.size.height, 10)];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"xuxian" ofType:@"png"];
    
    _horizLine.image = [UIImage imageWithContentsOfFile:path];
    _horizLine.userInteractionEnabled = YES;
    _horizLine.hidden = YES;
    _horizLine.alpha = 0.7;
    _horizLine.layer.anchorPoint = CGPointMake(0, 0);
    _horizLine.transform = CGAffineTransformMakeRotation( - M_PI / 2);
    _horizLine.layer.position = CGPointMake(50,  _graphView.frame.size.height); //原点
    [self addSubview:_horizLine];
    //显示用来显示水平线的值的label
    _horizData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    _horizData.layer.anchorPoint = CGPointMake(0, 0);
    _horizData.transform = CGAffineTransformMakeRotation( M_PI / 2);
    _horizData.hidden = YES;
    _horizData.textAlignment = 1;
    _horizData.textColor = [UIColor blueColor];
    _horizData.font = [UIFont systemFontOfSize:8];
    _horizData.backgroundColor = [UIColor clearColor];
    [self addSubview:_horizData];
}
//添加水平线的子视图
- (void)_addVerticLineSubviews
{
    for (int i = 0; i < 11; i++) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(-1, 20*(i+1) - 2,4,4)];
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"circle" ofType:@"png"];
        UIImage *image = [UIImage imageWithContentsOfFile:path];
        [button setImage:image forState:UIControlStateNormal];
        [_verticLine addSubview:button];
        if (i == 10) {
            button.bounds = CGRectMake(0, 0, 8, 8);
            NSString *path = [[NSBundle mainBundle] pathForResource:@"bigCircle" ofType:@"png"];
            UIImage *tempImage = [UIImage imageWithContentsOfFile:path];
            [button setImage:tempImage forState:UIControlStateNormal];
        }
        [button release];
    }
}
//添加垂直线
- (void)_addVerticLine
{
    _verticLine = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 2, 220)];
    [self addSubview:_verticLine];
    _verticLine.backgroundColor = [UIColor grayColor];
    _verticLine.layer.anchorPoint = CGPointMake(0,0);//锚点
    _verticLine.transform = CGAffineTransformMakeRotation(- M_PI / 2);//旋转
    _verticLine.clipsToBounds = NO;
    [self _addVerticLineSubviews];
    
    //显示数据视图
    _verticData  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 40)];
    [self addSubview:_verticData];
    _verticData.font = [UIFont systemFontOfSize:12.0f];
    _verticData.textAlignment = 1;
    _verticData.backgroundColor = [UIColor grayColor];
    _verticData.layer.anchorPoint = CGPointMake(0,0);
    _verticData.transform = CGAffineTransformMakeRotation( M_PI / 2);
    [self _addVerticDataSubViews]; //为_verticData添加一些显示数据的子视图
}
//添加垂直线的子视图
- (void)_addVerticDataSubViews
{
    //显示5组数据的标签
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(2+_verticData.frame.size.height/4*i,18,_verticData.frame.size.height/4 -4,20)] autorelease];
        label.textAlignment = 1;
        label.tag = 10000+i;
        label.backgroundColor = [UIColor grayColor];
        label.font = [UIFont systemFontOfSize:10.0f];
        [_verticData addSubview:label];
        switch (i) {
            case 1:
                label.textColor = [UIColor redColor];
                break;
            case 2:
                label.textColor = [UIColor greenColor];
                break;
            case 3:
                label.textColor = [UIColor blueColor];
                break;
                
            default:label.textColor = [UIColor whiteColor];
                break;
        }
        if (i == 4) {
            label.frame = CGRectMake(2+_verticData.frame.size.height/5*i,18,_verticData.frame.size.height/5,20);
        }
    }
    NSArray * array = @[@"时间",@"经验",@"积分",@"时长",];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_verticData.frame.size.height/4*i,0,_verticData.frame.size.height/4,20)];
        label.text = [array objectAtIndex:i];
        label.textAlignment = 1;
        label.font = [UIFont systemFontOfSize:14.0f];
        [_verticData addSubview:label];
        [label release];
    }
}

//手势方法 以触摸点位置显示水平线及数据视图
- (void)showHoriz:(UIPanGestureRecognizer *)gesture
{
    CGPoint current = [gesture locationInView:self];
    switch (gesture.state) {
        case 1:
            _horizLine.hidden = NO;
            _horizData.hidden = NO;
            break;
        case 2:
            _horizLine.layer.position = CGPointMake(current.x, _graphView.frame.size.height);
            _horizData.layer.position = CGPointMake(current.x +20 , current.y - 35);
            _horizData.text = [NSString stringWithFormat:@"%0.2f",current.x -35];
            break;
        case 3:
            [NSTimer scheduledTimerWithTimeInterval:8.0f target:self selector:@selector(horizLineWillHide) userInfo:nil repeats:NO];
            break;
        default:
            break;
    }
}
//水平线和水平线数据视图将要消失
- (void)horizLineWillHide
{
    _horizLine.hidden = YES;
    _horizData.hidden = YES;
}

//表视图滑动到最底部
- (void)_tableViewScrcrollToBottom
{
    NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:[[self.dataArray lastObject] count] - 1 inSection:0];
    [self scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    //以下操作，纯粹是为了当表视图在最后一行Cell 显示数据视图上有它对应的数据

//    UILabel *dateLabel   = (UILabel *)[self viewWithTag:10000];
    UILabel *value1Label = (UILabel *)[self viewWithTag:10001];
    UILabel *value2Label = (UILabel *)[self viewWithTag:10002];
    UILabel *value3Label = (UILabel *)[self viewWithTag:10003];
    UILabel *sumLabel    = (UILabel *)[self viewWithTag:10004];
    
    NSString *value1 = [[self.dataArray objectAtIndex:0] objectAtIndex:_cellIndex];//值1 红
    NSString *value2 = [[self.dataArray objectAtIndex:1] objectAtIndex:_cellIndex];//值2 绿
    NSString *value3 = [[self.dataArray objectAtIndex:2] objectAtIndex:_cellIndex];//值3 蓝
    CGFloat  lastSum = [value1 floatValue] +[value2 floatValue] + [value3 floatValue];
#warning 默认时间接口
    value1Label.text = [[[self.dataArray objectAtIndex:0] lastObject] description];
    value2Label.text = [[[self.dataArray objectAtIndex:1] lastObject] description];
    value3Label.text = [[[self.dataArray objectAtIndex:2] lastObject] description];
    sumLabel.text    = [NSString stringWithFormat:@"%0.0f",lastSum];
}
//verticData上的数据保持同步
- (void)synchronouslyVerticData
{
    //_cellIndex发生变化时，对应改变 显示标签上的数据
    if (_cellIndex >= 0 && _cellIndex <  [[self.dataArray objectAtIndex:0] count]) {
        
        NSString *value1 = [[self.dataArray objectAtIndex:0] objectAtIndex:_cellIndex];//值1 红
        NSString *value2 = [[self.dataArray objectAtIndex:1] objectAtIndex:_cellIndex];//值2 绿
        NSString *value3 = [[self.dataArray objectAtIndex:2] objectAtIndex:_cellIndex];//值3 蓝
        CGFloat  tempSum = [value1 floatValue] +[value2 floatValue] + [value3 floatValue];
        NSString *sum    = [NSString stringWithFormat:@"%.0f",tempSum];   //总和
        
        //取出对应cell上的日期
        DataCell *cell = (DataCell *)[self viewWithTag:100 + _cellIndex];
        NSString *date = cell.dateLabel.text;
        
        //将对应的数据添加到数组里 可以方便使用以及其代理对象接收数据
        if (date != nil) {
            _dataModel.date = date;
            _dataModel.value1 = [value1 description];
            _dataModel.value2 = [value2 description];
            _dataModel.value3 = [value3 description];
            _dataModel.sum  = sum;
            
            //每次滑动 更改显示数据视图上对应的数据
            UILabel *dateLabel   = (UILabel *)[self viewWithTag:10000];
            UILabel *value1Label = (UILabel *)[self viewWithTag:10001];
            UILabel *value2Label = (UILabel *)[self viewWithTag:10002];
            UILabel *value3Label = (UILabel *)[self viewWithTag:10003];
            UILabel *sumLabel    = (UILabel *)[self viewWithTag:10004];
            
            dateLabel.text   = _dataModel.date;
            value1Label.text = _dataModel.value1;
            value2Label.text = _dataModel.value2;
            value3Label.text = _dataModel.value3;
            sumLabel.text    = _dataModel.sum;
            
            //如果其代理对象存在
            if (self.delegate && [self.delegate respondsToSelector:@selector(dateTableView:dataModel:)])
            {
                [self.aDelegate dateTableView:self dataModel:_dataModel];
            }
        }
    }
    //_cellIndex发生变化时，相应改变 显示线和显示数据视图的位置
    _verticLine.layer.position = CGPointMake(40,45*(_cellIndex+1));
    _verticData.layer.position = CGPointMake(_graphView.frame.size.width +40 + 20,45*(_cellIndex+1));
    if (_cellIndex+1 > [[self.dataArray lastObject] count] /2) {
        _verticData.layer.position = CGPointMake(_graphView.frame.size.width +40 + 20,45*(_cellIndex+1) - _verticData.frame.size.height - 2);
    }
}

//VerticData上的动画
- (void)transitionForVerticData
{
    [UIView animateWithDuration:0.18f
                          delay:0
                        options:UIViewAnimationOptionTransitionFlipFromTop
                     animations:^(void){
                         _verticData.alpha = 0.0f;
                         _verticLine.alpha = 0.0f;
                         _horizLine.hidden = NO;
                         _horizLine.alpha = 0.0f;
                         _horizData.hidden = NO;
                         _horizData.alpha = 0.0f;
                         
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.2f
                                               delay:0
                                             options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat
                                          animations:^(void){
                                              [UIView setAnimationRepeatCount:2.5];
                                              _verticData.alpha = 1.0f;
                                              _verticLine.alpha = 1.0f;
                                              _horizLine.alpha = 1.0f;
                                              _horizData.alpha = 1.0f;
                                          }
                                          completion:^(BOOL finished){
                                              for (int i = 0; i < 5; i++)
                                              {//动画效果
                                                  UILabel * label = (UILabel *)[self viewWithTag:10000+i];
                                                  CATransition *transition = [[CATransition alloc] init];
                                                  transition.duration = 0.25+0.1*i*i;
                                                  transition.startProgress = 0.4;
                                                  transition.type = kCATransitionReveal;
                                                  transition.subtype = kCATransitionFromBottom;
                                                  [label.layer addAnimation:transition forKey:@"过渡动画"];
                                                  [transition release];
                                                  _horizLine.hidden = YES;
                                                  _horizData.hidden = YES;
                                              } }];
                     }];
}

#pragma mark ***UIScrollViewDelegate Methods***
//重载父类方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
{
    //根据滚动时当前的y坐标和页宽度计算出当前的cell
    _cellIndex = floor(( [[self.dataArray lastObject] count] * kPageWidth / ([[self.dataArray lastObject] count] * kPageWidth -320 - 45)) * (scrollView.contentOffset.y -45)/kPageWidth) ;

    //确保CellIndex在有效范围类【0 —— [self.dataArray lastObject] count]-1】
    if (_cellIndex <= 0) {
        _cellIndex = 0;
    }
    if (_cellIndex >= [[self.dataArray lastObject] count]) {
        _cellIndex = [[self.dataArray lastObject] count]-1;
    }

    [self synchronouslyVerticData]; //ShowData上的数据保持同步
    [self reloadData];  //同时刷新表视图
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    [self transitionForVerticData];   //为VerticData上添加动画
}

#pragma mark ***UITableViewDataSource Methods***
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArray lastObject] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuesIdentifier = @"Cell";
    DataCell *cell = [tableView dequeueReusableCellWithIdentifier:reuesIdentifier];
    if (cell == nil) {
        cell = [[[DataCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuesIdentifier] autorelease];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.tag = 100 +indexPath.row;
#warning 时间接口
    cell.dateLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    return cell;
}

#pragma mark ***UITableViewDelegate Methods***
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kPageWidth;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _cellIndex = indexPath.row;
    [self synchronouslyVerticData];
    [self transitionForVerticData];
}


@end
