//
//  BageContactViewController.h
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMPPManager.h"

@interface BageContactViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,XMPPManagerDelegate>

@property (retain, nonatomic) IBOutlet UITableView *friendlistTableView;

@end
