//
//  BageEventsViewController.h
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RequestManager+ShopStore.h"
#import "MatchManger.h"
#import "NetworkManager.h"

@interface BageEventsViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,NSURLConnectionDataDelegate,NBRequestDataDelegate,MatchMangerDelegate>

@property (strong, nonatomic) IBOutlet UIView *scheduleView;
@property (strong, nonatomic) IBOutlet UIView *eventsView;
@property (strong, nonatomic) IBOutlet UITableView *eventTableView;
@property (retain, nonatomic) IBOutlet UIView *chooseWeekView;
@property (retain, nonatomic) IBOutlet UIView *darkView;


@property (nonatomic,retain) UIScrollView *scrollMyView;
@property (nonatomic,retain) UICollectionView *arrange;//日程表
@property (nonatomic,retain) UICollectionView *weekListView;//周几
@property (nonatomic,retain) UIScrollView *weekList;
@property (nonatomic,retain) UIScrollView *timeList;

- (IBAction)didClickDarkView:(UITapGestureRecognizer *)sender;

@end
