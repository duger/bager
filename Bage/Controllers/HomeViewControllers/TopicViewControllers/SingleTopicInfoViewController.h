//
//  SingleTopicInfoViewController.h
//  Bage
//
//  Created by Adozen12 on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingleTopicInfoViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (retain, nonatomic) IBOutlet UIImageView *TopicImageView;
@property (retain, nonatomic) IBOutlet UILabel *TopicName;
@property (retain, nonatomic) IBOutlet UILabel *TopicTime;
@property (retain, nonatomic) IBOutlet UILabel *TopicType;

- (IBAction)didClickApplyButton:(id)sender;

@property (retain, nonatomic) IBOutlet UILabel *TopicIntroduce;

@property (nonatomic,retain) NSDictionary *showSingleTopic;

@end
