//  SingleTopicInfoViewController.m
//  Bage
//  Created by Adozen12 on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.

#import "SingleTopicInfoViewController.h"
#import "ApplyATopicViewController.h"
//弹出窗第三方类
#import "MZFormSheetController.h"
#import "MZCustomTransition.h"
#import "SingleTopicApplyerCell.h"

@interface SingleTopicInfoViewController ()

@end

@implementation SingleTopicInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=@"话题详情";
        _showSingleTopic=[[NSDictionary alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString *nametopic=[_showSingleTopic objectForKey:@"t_name"];
    NSString *timetopic=[_showSingleTopic objectForKey:@"t_created_date"];
    NSString *contenttopic=[_showSingleTopic objectForKey:@"t_content"];
    NSString *typetopic=[_showSingleTopic objectForKey:@"t_type"];
    NSString *imagetopic=[[_showSingleTopic objectForKey:@"t_image_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imageURl=[NSURL URLWithString:imagetopic];
    NSData *data = [NSData dataWithContentsOfURL:imageURl];
    
    _TopicImageView.image=[UIImage imageWithData:data];
    _TopicImageView.layer.cornerRadius = 5;
    _TopicImageView.layer.masksToBounds = YES;
    _TopicName.text=nametopic;
    _TopicTime.text=timetopic;
    _TopicType.text=typetopic;
//    _TopicIntroduce.backgroundColor=[UIColor grayColor];
    _TopicIntroduce.text=contenttopic;
    
    UICollectionViewFlowLayout *alayout=[[UICollectionViewFlowLayout alloc]init];
    alayout.itemSize=CGSizeMake(50.0f, 50.0f);
    alayout.minimumInteritemSpacing=2.0f;
    
    alayout.minimumLineSpacing=2.0f;
    alayout.scrollDirection=UICollectionViewScrollDirectionVertical;
    
    UICollectionView *allApplyersView=[[UICollectionView alloc]initWithFrame:CGRectMake(24, 360, 280, 107) collectionViewLayout:alayout];
    allApplyersView.backgroundColor=[UIColor cyanColor];
    allApplyersView.layer.cornerRadius = 3;
    allApplyersView.layer.masksToBounds = YES;
    allApplyersView.delegate=self;
    allApplyersView.dataSource=self;
    [allApplyersView registerClass:[SingleTopicApplyerCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:allApplyersView];
    [allApplyersView release];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor lightGrayColor]];
    //    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [MZFormSheetController registerTransitionClass:[MZCustomTransition class] forTransitionStyle:MZFormSheetTransitionStyleCustom];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_TopicImageView release];
    [_TopicName release];
    [_TopicTime release];
    [_TopicType release];
    [_TopicIntroduce release];
    [super dealloc];
}
- (IBAction)didClickApplyButton:(id)sender {
    
    ApplyATopicViewController *applyTopicVC = [[ApplyATopicViewController alloc] init];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithSize:CGSizeMake(300, 200) viewController:applyTopicVC];
    [formSheet setTransitionStyle:MZFormSheetTransitionStyleFade];
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.cornerRadius = 10;

    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
    }];
}

#pragma mark -uicollectiondelegate -

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"this gay");
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(4.0f, 6.0f, 4.0f, 6.0f);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SingleTopicApplyerCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    //报名者头像
    
    return cell;
}

@end
