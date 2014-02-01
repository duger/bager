//
//  BageEventsViewController.m
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BageEventsViewController.h"
#import "ShowMyActHistoryViewController.h"
#import "ShowMyGActViewController.h"
#import "BageSetupInfomationManager.h"
#import "SingleArrangeDetailViewController.h"

#import "MyActiveTableCell.h"
#import "MyArrangeTimingCell.h"
#import "ArrangeTime12.h"
#import "MyArrangeTimingCollectCell.h"
//弹出窗第三方类
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"

#import "JSONKit.h"

#define DOWNLOAD_PARTINGACTIVITY_URL @"http://124.205.147.26/student/class_10/team_six/test.php"


@interface BageEventsViewController ()
{
    //分组名
    NSArray *_functionsArray;
    //周次信息
    NSArray *_weeksArray;
    UIBarButtonItem *chooseWeekButton;
    //周次选择菜单是否开启
    BOOL _isOpenedWeekMenu;
    //星期的信息
    NSString *nextWeek;
    NSString *nextnextWeek;
    //三个星期的日期信息
    NSMutableArray *firstWeek;
    NSMutableArray *secondWeek;
    NSMutableArray *thirdWeek;
    NSMutableArray *chooseMyWeek;
    //星期一到七的汉字
    NSArray *weekInCN;
    //小组活动接受请求数据的数组
    NSDictionary *myGActiveDic;
    NSMutableArray *myGActiveArr;
    //NSMutableArray *history
    //匹配活动接受请求数据的数组
    NSDictionary *myPActiveDic;
    NSMutableArray *myPActiveArr;
    //匹配活动记录 前后数组
    NSMutableArray *historyPActArray;
    NSMutableArray *undoPActArray;
    
    //
    MyArrangeTimingCell *arrangeCell;
}

//获取下周和下下周的日期信息
-(void)_getNextweekInfomation;
//比较匹配活动数组的时间先后
-(void)_comparePActtime;
//分段视图 活动和日程
-(void)_segmentedCtrl;
//添加活动 或 日程 button
-(void)_addEventButton;
//添加 周次选择barItem
-(void)_addChooseWeekButton;
//布局周次选择按钮
-(void)_buttonsOnChooseWeekView;
//为周次选择界面添加动画
-(void)_addAnimationToWeekViews;
//收回周次选择菜单
-(void)_getBackWeekMenu;

@end

@implementation BageEventsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"活动";
        NSArray *tempArr = [[BageSetupInfomationManager defaultManager]getInfromationForKey:@"EventsViewFunction"];
        _functionsArray = [[NSArray alloc]initWithArray:tempArr];
        
        _isOpenedWeekMenu = NO;
        
        firstWeek=[[NSMutableArray alloc]init];
        secondWeek=[[NSMutableArray alloc]init];
        thirdWeek=[[NSMutableArray alloc]init];
        chooseMyWeek=[[NSMutableArray alloc]init];
        [self _getNextweekInfomation];
        
        weekInCN=[[NSArray alloc]initWithObjects:@"一",@"二",@"三",@"四",@"五",@"六",@"日", nil];
        _weeksArray = [[NSArray alloc]initWithObjects:@"本周",nextWeek,nextnextWeek, nil];
        
        myGActiveArr=[[NSMutableArray alloc]init];
        myGActiveDic=[[NSDictionary alloc]init];
        myPActiveArr=[[NSMutableArray alloc]init];
        myPActiveDic=[[NSDictionary alloc]init];
        historyPActArray=[[NSMutableArray alloc]init];
        undoPActArray=[[NSMutableArray alloc]init];
    }
    return self;
}
- (void)dealloc
{
//    [_scheduleView release],_scheduleView = nil;
//    [_eventsView release],_eventsView = nil;
    //[_eventTableView release],_eventTableView = nil;
//    [_chooseWeekView release],_chooseWeekView = nil;
//    [_darkView release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *jid=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
    
    [[MatchManger defaultManager]getMatchedPartner:jid];
    [[MatchManger defaultManager]setDelegate:self];
    
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor lightGrayColor]];
    //    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
    
//    RequestManager *request1=[[RequestManager alloc]init];
//    request1.delegate=self;
//    request1.requestTag=@"myPartyAct";
//    [request1 requestWithParameter:nil andRequestString:DOWNLOAD_PARTINGACTIVITY_URL];
//    RequestManager *request2=[[RequestManager alloc]init];
//    request2.delegate=self;
//    request2.requestTag=@"myGroupAct";
//    [request2 requestWithParameter:nil andRequestString:DOWNLOAD_PARTINGACTIVITY_URL];
    
    //分段视图 活动和日程
    [self _segmentedCtrl];
    //添加活动 或 日程
    //[self _addEventButton];
    //周次 时间
    [self _addChooseWeekButton];
    
    //日程视图的控件
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    _scrollMyView=[[UIScrollView alloc]initWithFrame:CGRectMake(50, 114, 320-50, 405-20+5+14)];
    _scrollMyView.contentOffset=CGPointMake(0, 0);
    _scrollMyView.contentSize=CGSizeMake(400, 650);
    _scrollMyView.pagingEnabled=NO;
    _scrollMyView.bounces=NO;
    _scrollMyView.delegate=self;
    _scrollMyView.backgroundColor=[UIColor cyanColor];
    [_scheduleView addSubview:_scrollMyView];
    //scrollView加testview用来隔层
    UIView *mytestview=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 400, 650+140)];
    mytestview.backgroundColor=[UIColor greenColor];
    [_scrollMyView addSubview:mytestview];
    //在mytestview上添加collectionview日程表
    UICollectionViewFlowLayout *aFlowLayout=[[UICollectionViewFlowLayout alloc]init];
    aFlowLayout.itemSize=CGSizeMake(50, 50+1+1+0.5);
    aFlowLayout.minimumInteritemSpacing=2.0f;
    aFlowLayout.minimumLineSpacing=2.0f;
    aFlowLayout.scrollDirection=UICollectionViewScrollPositionNone;
    _arrange=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 400, 650) collectionViewLayout:aFlowLayout];
    _arrange.backgroundColor=[UIColor cyanColor];
    _arrange.bounces=NO;
    _arrange.delegate=self;
    _arrange.dataSource=self;
    [_arrange registerClass:[MyArrangeTimingCell class] forCellWithReuseIdentifier:@"cell"];
    [mytestview addSubview:_arrange];
    [_arrange release];
    //周一到周末的表 底层的scrollview
    _weekList=[[UIScrollView alloc]initWithFrame:CGRectMake(50, 64, 400+50, 50)];
    _weekList.backgroundColor=[UIColor orangeColor];
    _weekList.bounces=NO;
    _weekList.showsHorizontalScrollIndicator=NO;
    _weekList.contentOffset=CGPointMake(0, 0);
    _weekList.contentSize=CGSizeMake(450+100+50-20, 50);
    [_scheduleView addSubview:_weekList];
    [_weekList release];
    //接上collectionview
    UICollectionViewFlowLayout *anotherFlowLayout=[[UICollectionViewFlowLayout alloc]init];
    anotherFlowLayout.itemSize=CGSizeMake(52, 48);
    anotherFlowLayout.minimumInteritemSpacing=5.0f;
    anotherFlowLayout.minimumLineSpacing=5.0f;
    anotherFlowLayout.scrollDirection=UICollectionViewScrollDirectionHorizontal;
    _weekListView=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 400, 50) collectionViewLayout:anotherFlowLayout];
    _weekListView.backgroundColor=[UIColor cyanColor];
    _weekListView.delegate=self;
    _weekListView.dataSource=self;
    _weekListView.showsHorizontalScrollIndicator=NO;
    [_weekListView registerClass:[MyArrangeTimingCollectCell class] forCellWithReuseIdentifier:@"cell"];
    [_weekList addSubview:_weekListView];
    
    //时间轴底层view
    UIView *timeListBackView=[[UIView alloc]initWithFrame:CGRectMake(0, 64+50, 50, 455-50-14+13)];
    timeListBackView.backgroundColor=[UIColor clearColor];
    [_scheduleView addSubview:timeListBackView];
    //接上scrollview
    _timeList=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 2, 50, 455-14-50+13)];
    _timeList.backgroundColor=[UIColor orangeColor];
    _timeList.contentOffset=CGPointMake(0, 0);
    _timeList.contentSize=CGSizeMake(50, 455-14-50+130+100+50);
    _timeList.bounces=NO;
    _timeList.showsVerticalScrollIndicator=NO;
    [timeListBackView addSubview:_timeList];
    //接上tableiview
    ArrangeTime12 *timeLabelShow=[[ArrangeTime12 alloc]init];
    timeLabelShow.backgroundColor=[UIColor redColor];
    timeLabelShow.bounces=NO;
    timeLabelShow.showsVerticalScrollIndicator=NO;
    [_timeList addSubview:timeLabelShow];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    //
    
    
}
-(void)viewDidAppear:(BOOL)animated
{
    _eventTableView.delegate=self;
    _eventTableView.dataSource=self;
    [_eventTableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
//连带滑动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:_scrollMyView])
    {
        _weekList.delegate=nil;
        [_weekList setContentOffset:_scrollMyView.contentOffset];
        _weekList.alwaysBounceHorizontal=YES;
        _weekList.delegate=self;
        
        _timeList.delegate=nil;
        [_timeList setContentOffset:_scrollMyView.contentOffset];
        _timeList.alwaysBounceVertical=YES;
        _timeList.delegate=self;
    }
    if ([scrollView isEqual:_weekList]) {
        _scrollMyView.delegate=nil;
        [_scrollMyView setContentOffset:_weekList.contentOffset];
        _scrollMyView.alwaysBounceHorizontal=YES;
        _scrollMyView.delegate=self;
    }
    if ([scrollView isEqual:_timeList]) {
        _scrollMyView.delegate=nil;
        [_scrollMyView setContentOffset:_timeList.contentOffset];
        _scrollMyView.alwaysBounceVertical=YES;
        _scrollMyView.delegate=self;
    }
}

#pragma mark - matchedDelegate -

//收到配对的Partner回调方法
-(void)didReceivedMatchedPartners:(NSArray *)partners
{
    [myPActiveArr addObjectsFromArray:partners];
    NSLog(@"  addadad ===  %@",myPActiveArr);
    //[self _comparePActtime];
    [_eventTableView reloadData];
    [_arrange reloadData];
}

#pragma mark - Private Methods
//获取最近三周的周一周日的日期信息
-(void)_getNextweekInfomation
{
    unsigned units=NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit|NSWeekdayCalendarUnit;
    NSCalendar *mycal=[[NSCalendar alloc]initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now=[NSDate date];
    now=[now dateByAddingTimeInterval:8*60*60];
    NSString *ifhoursixteen=[now description];
    NSString *sixteen=[ifhoursixteen substringWithRange:NSMakeRange(11, 2)];
    NSInteger letmeif=[sixteen intValue];
    if(letmeif>=16){
        now=[now dateByAddingTimeInterval:-8*60*60];
    }
    NSLog(@"date at this moment:%@",now);
    //下周
    NSDateComponents *comp=[mycal components:units fromDate:now];
    NSInteger month=[comp month];
    NSInteger day=[comp day];
    NSCalendar *yangLi=[NSCalendar currentCalendar];
    NSDateComponents *dateComps=[yangLi components:NSWeekdayCalendarUnit fromDate:now];
    
    int daycount=[dateComps weekday]-2-7;
    //NSLog(@"weekday  +++ %d",[dateComps weekday]);
    NSDate *weekdaybegin=[now dateByAddingTimeInterval:-daycount*60*60*24];
    NSDate *weekdayend=[now dateByAddingTimeInterval:(6-daycount)*60*60*24];
    //NSLog(@" begin=%@  end=%@",weekdaybegin,weekdayend);
    now=weekdaybegin;
    comp=[mycal components:units fromDate:now];
    month=[comp month];
    day=[comp day];
    //NSLog(@"ssss%d",day);
    NSString *nextMonday=[NSString stringWithFormat:@"%02d.%02d",month,day];
    now=weekdayend;
    comp=[mycal components:units fromDate:now];
    month=[comp month];
    day=[comp day];
    NSString *nextSunday=[NSString stringWithFormat:@"%02d.%02d",month,day];
    nextWeek=[NSString stringWithFormat:@"%@-%@",nextMonday,nextSunday];
    //NSLog(@"nextWeek==== %@",nextWeek);
    //下下周
    NSDate *nextweekdaybegin=[weekdaybegin dateByAddingTimeInterval:7*60*60*24];
    NSDate *nextweekdayend=[weekdayend dateByAddingTimeInterval:7*60*60*24];
    now=nextweekdaybegin;
    comp=[mycal components:units fromDate:now];
    month=[comp month];
    day=[comp day];
    NSString *nextnextMonday=[NSString stringWithFormat:@"%02d.%02d",month,day];
    now=nextweekdayend;
    comp=[mycal components:units fromDate:now];
    month=[comp month];
    day=[comp day];
    NSString *nextnextSunday=[NSString stringWithFormat:@"%02d.%02d",month,day];
    nextnextWeek=[NSString stringWithFormat:@"%@-%@",nextnextMonday,nextnextSunday];
    //根据下周一获取本周的日期数组
    //weekdaybegin=[weekdaybegin dateByAddingTimeInterval:8*60*60];
    NSDate *thisweekalldays=[weekdaybegin dateByAddingTimeInterval:-8*24*60*60];
    //NSLog(@" nsdate == %@",thisweekalldays);
    for (int i=0; i<7; i++)
    {
        thisweekalldays=[thisweekalldays dateByAddingTimeInterval:24*60*60];
        [firstWeek addObject:thisweekalldays];
    }
    //根据下周一获取下周的日期数组
    //weekdaybegin=[weekdaybegin dateByAddingTimeInterval:8*60*60];
    NSDate *nextweekalldays=[weekdaybegin dateByAddingTimeInterval:-1*24*60*60];
    for (int i=0; i<7; i++) {
        nextweekalldays=[nextweekalldays dateByAddingTimeInterval:24*60*60];
        [secondWeek addObject:nextweekalldays];
    }
    //根据下下周一获取下下周的日期数组
    //nextweekdaybegin=[nextweekdaybegin dateByAddingTimeInterval:8*60*60];
    NSDate *nextnextweekalldays=[nextweekdaybegin dateByAddingTimeInterval:-1*24*60*60];
    for (int i=0; i<7; i++) {
        nextnextweekalldays=[nextnextweekalldays dateByAddingTimeInterval:24*60*60];
        [thirdWeek addObject:nextnextweekalldays];
    }
}
//比较匹配活动数组的时间先后
-(void)_comparePActtime
{
    NSDate *forNow=[NSDate date];
    forNow=[forNow dateByAddingTimeInterval:8*60*60];
    NSString *nowtime=[NSString stringWithFormat:@"%@",forNow];
    //NSLog(@"fornow = = %@",nowtime);
    for(int i=0;i<[myPActiveArr count];i++)
    {
        //NSLog(@" myPActiveArr count=== %d ",[myPActiveArr count]);
        NSDictionary *dicdic=[myPActiveArr objectAtIndex:i];
        NSString *testtime=[dicdic objectForKey:@"mp_created_date"];
        NSString *testTime=[testtime substringWithRange:NSMakeRange(0, 18)];
        
        NSComparisonResult compValue=[nowtime compare:testTime];
        if (compValue==1)
        {
            [historyPActArray addObject:[myPActiveArr objectAtIndex:i]];
        }
        else if ((compValue==-1) | (compValue==0)){
            [undoPActArray addObject:[myPActiveArr objectAtIndex:i]];
        }
    }
    //NSLog(@" his undo  %d%d",[historyPActArray count],[undoPActArray count]);
}
//分段视图 活动和日程
-(void)_segmentedCtrl
{
    //分段选择 活动  或者 日程
    UISegmentedControl *segmentedCtrl = [[UISegmentedControl alloc]initWithItems:@[@"活动",@"日程"]];
    [segmentedCtrl setFrame:CGRectMake(0, 0, 120, 30)];
    segmentedCtrl.selectedSegmentIndex = 0;
    segmentedCtrl.multipleTouchEnabled = NO;
    [segmentedCtrl addTarget:self action:@selector(segmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedCtrl;
    [segmentedCtrl release];
}
//分段视图回调
-(void)segmentedControlAction:(UISegmentedControl *)seg
{
    //收回菜单
    [self _getBackWeekMenu];
    NSInteger index = seg.selectedSegmentIndex;
    switch (index) {
        case 0:
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionShowHideTransitionViews animations:^{
                [self.eventsView setAlpha:1];
                [self.scheduleView setAlpha:0];
                [chooseWeekButton setTitle:@" "];
            } completion:^(BOOL finished) {
                [self.view insertSubview:self.eventsView aboveSubview:self.scheduleView];
            }];
            break;
        case 1:[UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut|UIViewAnimationOptionShowHideTransitionViews animations:^{
            [self.eventsView setAlpha:0];
            [self.scheduleView setAlpha:1];
            [chooseWeekButton setTitle:@"选择周次"];
        } completion:^(BOOL finished) {
            [self.view insertSubview:self.scheduleView aboveSubview:self.eventsView];
        }];
            break;
        default:
            break;
    }
}
//添加活动 或 日程 button
//-(void)_addEventButton
//{
//    UIBarButtonItem *addEventsButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(didClickAddEventButton:)];
//    self.navigationItem.rightBarButtonItem = addEventsButton;
//    [addEventsButton release];
//}
//-(void)didClickAddEventButton:(id)sender
//{
//    //收回菜单
//    [self _getBackWeekMenu];
//    NSLog(@"添加活动");
//}
//添加 周次选择barItem
-(void)_addChooseWeekButton
{
    chooseWeekButton = [[UIBarButtonItem alloc]initWithTitle:@" " style:UIBarButtonItemStylePlain target:self action:@selector(didClickChooseWeekButton:)];
    self.navigationItem.leftBarButtonItem = chooseWeekButton;
    
    [chooseWeekButton release];
    //周次选择视图
    [self _buttonsOnChooseWeekView];
}
-(void)didClickChooseWeekButton:(UIBarButtonItem *)sender
{
    //为语言选择界面添加动画
    [self _addAnimationToWeekViews];
    //弹出选择框动画
    if (_isOpenedWeekMenu) {
        [UIView animateWithDuration:0.5 animations:^{
            [self.chooseWeekView setFrame:CGRectMake(0, -75, 320, 75)];
        } completion:^(BOOL finished) {
            _isOpenedWeekMenu = !_isOpenedWeekMenu;
        }];
        //阴影不显示
        self.darkView.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            [self.chooseWeekView setFrame:CGRectMake(0, 64, 320, 75)];
        } completion:^(BOOL finished) {
            _isOpenedWeekMenu = !_isOpenedWeekMenu;
        }];
        //阴影显示
        self.darkView.hidden = NO;
        self.tabBarController.tabBar.hidden = YES;
    }
}
//布局周次选择按钮
-(void)_buttonsOnChooseWeekView
{
    NSInteger indexX = 0, indexY = 0,buttonWith = 80;
    NSInteger step = (self.view.bounds.size.width - _weeksArray.count * buttonWith) / (_weeksArray.count + 1);
    
    for (NSInteger i = 0; i < _weeksArray.count; i++)
    {
        NSString *str = _weeksArray[i];
        indexX = step + (buttonWith + step) * i;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(indexX , indexY + 20 , 80, 40)];
        [button setTitle:str forState:UIControlStateNormal];
        button.titleLabel.font=[UIFont systemFontOfSize:14.0f];
        //button setTitleColor:<#(UIColor *)#> forState:<#(UIControlState)#>
        //button.backgroundColor=[UIColor cyanColor];
        button.tag = 10000 + i;
        [button addTarget:self action:@selector(didchooseWeek:) forControlEvents:UIControlEventTouchUpInside];
        [self.chooseWeekView addSubview:button];
    }
}
-(void)didchooseWeek:(UIButton *)sender
{
    //收回菜单
    [self _getBackWeekMenu];
    switch (sender.tag - 10000) {
        case 0:
            [chooseMyWeek removeAllObjects];
            [chooseMyWeek addObjectsFromArray:firstWeek];
            [_weekListView reloadData];
            [_arrange reloadData];
            break;
        case 1:
            [chooseMyWeek removeAllObjects];
            [chooseMyWeek addObjectsFromArray:secondWeek];
            [_weekListView reloadData];
            [_arrange reloadData];
            break;
        case 2:
            [chooseMyWeek removeAllObjects];
            [chooseMyWeek addObjectsFromArray:thirdWeek];
            [_weekListView reloadData];
            [_arrange reloadData];
            break;
        default:
            break;
    }
}
//为语言选择界面添加动画
-(void)_addAnimationToWeekViews
{
    CATransition *transition = [[CATransition alloc]init];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    [self.darkView.layer addAnimation:transition forKey:@"transition"];
    [self.tabBarController.tabBar.layer addAnimation:transition forKey:@"tabbar"];
    [transition release];
}
//收回周次选择菜单
-(void)_getBackWeekMenu
{
    if (_isOpenedWeekMenu) {
        
        [self _addAnimationToWeekViews];
        [UIView animateWithDuration:0.4 animations:^{
            [self.chooseWeekView setFrame:CGRectMake(0, -75, 320, 75)];
        } completion:^(BOOL finished) {
            _isOpenedWeekMenu = !_isOpenedWeekMenu;
        }];
        //阴影不显示
        self.darkView.hidden = YES;
        self.tabBarController.tabBar.hidden = NO;
    }
}
//点击灰色区域 退出菜单
- (IBAction)didClickDarkView:(UITapGestureRecognizer *)sender {
    [self _getBackWeekMenu];
}

#pragma mark - NBRequestDataDelegate
//请求完后调用的方法
- (void)request:(RequestManager *)request didFinishLoadingWithInfo:(id)info
{
//    if([request.requestTag isEqualToString:@"myGroupAct"])
//    {
//        [myGActiveArr addObjectsFromArray:info];
//        if([myGActiveArr count]!=0)
//        {
//            //[self _comparePActtime];
//        }
//        [_eventTableView reloadData];
//        [_arrange reloadData];
//    }
//    if([request.requestTag isEqualToString:@"myPartyAct"])
//    {
//        [myPActiveArr addObjectsFromArray:info];
//        if([myPActiveArr count]!=0)
//        {
//            [self _comparePActtime];
//        }
//        [_eventTableView reloadData];
//        [_arrange reloadData];
//    }
}
- (void)request:(RequestManager *)request didFailedWithError:(NSError *)error
{
    NSLog(@"---------%@",error);
}

#pragma mark - TalbeView DataSource Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"%d",_functionsArray.retainCount);
    return _functionsArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger cellCount = 0;
    switch (section) {
        case 0:
            cellCount = 1;
            break;
        case 1:
            cellCount = [myPActiveArr count]+1;
            break;
        default:
            break;
    }
    return cellCount;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *tempStr = _functionsArray[section];
    return tempStr;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellName = @"cellName";
    MyActiveTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (cell == nil){
        cell = [[[MyActiveTableCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName]autorelease];
    }
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
    if (section==0 && row==0)
    {
        UILabel *groupView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
        groupView.backgroundColor=[UIColor whiteColor];
        [cell addSubview:groupView];
        groupView.text=@"小组活动记录";
        groupView.textAlignment=NSTextAlignmentCenter;
        [groupView release];
    }
    if (section==1 && row==0)
    {
        UILabel *groupView=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
        groupView.backgroundColor=[UIColor whiteColor];
        [cell addSubview:groupView];
        groupView.text=@"匹配活动记录";
        groupView.textAlignment=NSTextAlignmentCenter;
        [groupView release];
    }
    if (section==1 && row!=0)
    {
        if([myPActiveArr count]!=0)
        {
            NSDictionary *showDic=[myPActiveArr objectAtIndex:row-1];
            NSString *showtimeStr=[showDic objectForKey:@"mp_created_date"];
            NSString *showtimeok=[showtimeStr substringWithRange:NSMakeRange(5, 11)];
            NSString *showtimeN=[NSString stringWithFormat:@"%@",showtimeok];
            NSString *parterName=[showDic objectForKey:@"mp_host_jid"];
            NSString *anotherpartner=[showDic objectForKey:@"mp_partner_jid"];
            NSInteger topicType=[[showDic objectForKey:@"mp_topic_type"]intValue];
            //NSString *partyName=[showDic objectForKey:@"party_name"];
            NSString *jid=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
            if([jid isEqualToString:parterName]){
                cell.parterName.text=anotherpartner;
            }
            if([jid isEqualToString:anotherpartner])
            {
                cell.parterName.text=parterName;
            }
            
            //cell.parterActiveName.text=partyName;
            if (topicType==0) {
                cell.parterActiveName.text=@"手气不错";
            }
            if (topicType==1) {
                cell.parterActiveName.text=@"随意";
            }
            if (topicType==2) {
                cell.parterActiveName.text=@"雅思";
            }
            if (topicType==3) {
                cell.parterActiveName.text=@"生活";
            }
            if (topicType==4) {
                cell.parterActiveName.text=@"商务";
            }
            
            NSString *portraitUrl = @"http://124.205.147.26/student/class_10/team_six/resource/hahaha.png";
            NSURL *url = [NSURL URLWithString:portraitUrl];
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:url] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                UIImage *image = [[UIImage alloc] initWithData:data];
                cell.parterHead.image = image;
            }];
            
            cell.parterRuntime.text=showtimeN;
            cell.parterRuntime.font=[UIFont systemFontOfSize:12.0f];
        }
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger section=indexPath.section;
    NSInteger row=indexPath.row;
//    if (section==1 && row==0) {
//        ShowMyActHistoryViewController *showPVC=[[ShowMyActHistoryViewController alloc]init];
//        [showPVC.historyArray removeAllObjects];
//        [showPVC.historyArray addObjectsFromArray:historyPActArray];
//        //NSLog(@"histroy count ==== %d",[showPVC.historyArray count]);
//        //NSLog(@" arr = %d arr=  %d",[showVC.historyArray count],[historyPActArray count]);
//        [self.navigationController pushViewController:showPVC animated:YES];
//    }
//    if (section==0 && row==0) {
//        ShowMyGActViewController *showGVC=[[ShowMyGActViewController alloc]init];
//        [showGVC.historyArray removeAllObjects];
//        [showGVC.historyArray addObjectsFromArray:historyPActArray];
//        
//        [self.navigationController pushViewController:showGVC animated:YES];
//    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UICollectionView Delegate -

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"oh , baby u release me");
//    NSInteger item=indexPath.item;
//    myPActiveDic=[myPActiveArr objectAtIndex:item];
//    NSString *parterName=[myPActiveDic objectForKey:@"mp_host_jid"];
//    NSString *anotherpartner=[myPActiveDic objectForKey:@"mp_partner_jid"];
//    //NSString *partyName=[showDic objectForKey:@"party_name"];
//    NSString *jid=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
//    NSString *postname=nil;
//    if([jid isEqualToString:parterName] ){
//        postname=anotherpartner;
//    }
//    if([jid isEqualToString:anotherpartner] )
//    {
//        postname=parterName;
//    }
//    
////    if(arrangeCell.testLabel.text!=nil)
////    {
//    
//    SingleArrangeDetailViewController *singleVC=[[SingleArrangeDetailViewController alloc]initWithNibName:@"SingleArrangeDetailViewController" bundle:nil withNSString:postname];
//    
//        //singleVC.partnerName.text=arrangeCell.testLabel.text;
//    
//    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(300, 200) viewController:singleVC];
//    [formSheet setTransitionStyle:MZFormSheetTransitionStyleFade];
//    formSheet.shouldDismissOnBackgroundViewTap = YES;
//    formSheet.cornerRadius = 10;
//    
//    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
//    }];
//    }
    
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView==_arrange) {
        return 84;
    }
    if (collectionView==_weekListView){
        return 7;
    }
    return 0;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(3.0f, 3.0f, 1.0f, 3.0f);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([chooseMyWeek count]==0)
    {
        [chooseMyWeek addObjectsFromArray:firstWeek];
    }
    if(collectionView==_arrange)
    {
        arrangeCell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        NSDate *today1=[chooseMyWeek objectAtIndex:0];
        NSDate *today2=[chooseMyWeek objectAtIndex:6];
        //NSLog(@"%@   ---  %@",today1,today2);
        NSString *formon=[NSString stringWithFormat:@"%@",today1];
        NSString *thisweekmon=[formon substringWithRange:NSMakeRange(8,2)] ;
        int monday=[thisweekmon intValue];
        NSString *forsun=[NSString stringWithFormat:@"%@",today2];
        NSString *thisweeksun=[forsun substringWithRange:NSMakeRange(8,2)] ;
        int sunday=[thisweeksun intValue];
        //NSLog(@"%d  ---  %d  %d",monday,sunday,[myPActiveArr count]);
        for (int i=0; i<[myPActiveArr count]; i++)
        {
            myPActiveDic=[myPActiveArr objectAtIndex:i];
            NSString *testStr=[myPActiveDic objectForKey:@"mp_runtime"];
            NSString *dateweekX=[testStr substringWithRange:NSMakeRange(8, 2)];
            int weekIdentify=[dateweekX intValue];
            NSString *dateweekY=[testStr substringWithRange:NSMakeRange(11, 2)];
            int timeIdentify=[dateweekY intValue];
            int identify1=weekIdentify-monday;
            int identify2=sunday-weekIdentify;
            int weekIDx=0;
            int timeIDy=0;
            if (((identify1>=0)&&(identify1<7)) | ((identify2>=0)&&(identify2<7)))
            {//
                if((identify1>=0)&&(identify1<7)){
                    weekIDx=identify1;
                }
                else if ((identify2>=0)&&(identify2<7)){
                    weekIDx=identify2;
                }
                timeIDy=timeIdentify/2;
                int showmetheplace=indexPath.item;
                if (showmetheplace==((timeIDy)*7+weekIDx))
                {
                    
                    NSString *parterName=[myPActiveDic objectForKey:@"mp_host_jid"];
                    NSString *anotherpartner=[myPActiveDic objectForKey:@"mp_partner_jid"];
                    
                    //NSString *partyName=[showDic objectForKey:@"party_name"];
                    NSString *jid=[[NSUserDefaults standardUserDefaults]objectForKey:kXMPPmyJID];
                    
                    if([jid isEqualToString:parterName] && (arrangeCell.testLabel.text==NULL)){
                        arrangeCell.testLabel.text=anotherpartner;
                    }
                    if([jid isEqualToString:anotherpartner] && (arrangeCell.testLabel.text==NULL))
                    {
                        arrangeCell.testLabel.text=parterName;
                    }
                    
                    //NSString *partyname=[myPActiveDic objectForKey:@"party_name"];
//                    if(arrangeCell.testLabel.text==NULL)
//                    {
//                        arrangeCell.testLabel.text=partyname;
//                        //NSLog(@"cell.text=== %@",cell.testLabel.text);
//                    }
                }
            }
        }
        arrangeCell.testLabel.font=[UIFont systemFontOfSize:12.0f];
        return arrangeCell;
    }
    else if (collectionView==_weekListView)
    {
        MyArrangeTimingCollectCell *cell1=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        int number=indexPath.item;
        NSString *weekInfoCN=[weekInCN objectAtIndex:number];
        NSDate *today1=[chooseMyWeek objectAtIndex:number];
        
        NSString *today=[NSString stringWithFormat:@"%@",today1];
        NSString *thisweek=[today substringWithRange:NSMakeRange(8,2)] ;
        NSString *showthisweek=[NSString stringWithFormat:@"%@号周%@",thisweek,weekInfoCN];
        
        cell1.weekToWeek.text=showthisweek;
        cell1.weekToWeek.font=[UIFont systemFontOfSize:12.0f];
        cell1.backgroundColor=[UIColor whiteColor];
        return cell1;
    }
    return nil;
}




@end