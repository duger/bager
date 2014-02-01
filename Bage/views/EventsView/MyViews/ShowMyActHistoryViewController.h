//
//  ShowMyActHistoryViewController.h
//  Bage
//
//  Created by Adozen12 on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowMyActHistoryViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>


@property (nonatomic,retain) NSMutableArray *historyArray;
@property (nonatomic,retain) UITableView *showHistoryTable;
@end
