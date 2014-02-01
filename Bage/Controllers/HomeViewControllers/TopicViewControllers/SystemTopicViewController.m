//  SystemTopicViewController.m
//  Bage
//  Created by Adozen12 on 14-1-11.
//  Copyright (c) 2014年 Duger. All rights reserved.


#import "SystemTopicViewController.h"
#import "SingleTopicInfoViewController.h"
#import "ShowMyTopicListCell.h"

#define DOWNLOAD_ALLTOPIC_URL @"http://124.205.147.26/student/class_10/team_six/liyong2014-01-12/getalltopic.php"

@interface SystemTopicViewController ()

{
    UITableView *topicView;
    NSMutableArray *allTopicArray;
}

@end

@implementation SystemTopicViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.title=@"每日话题";
        allTopicArray=[[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    RequestManager *request1=[[RequestManager alloc]init];
    request1.delegate=self;
    request1.requestTag=@"getalltopic";
    [request1 requestWithParameter:nil andRequestString:DOWNLOAD_ALLTOPIC_URL];
    
    
    topicView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    topicView.delegate=self;
    topicView.dataSource=self;
    [self.view addSubview:topicView];
    
}

#pragma mark - nbrequestdelegate - 

-(void)request:(RequestManager *)request didFinishLoadingWithInfo:(id)info
{
    [allTopicArray addObjectsFromArray:info];
    //NSLog(@"%@",allTopicArray);
    [topicView reloadData];
}

-(void)request:(RequestManager *)request didFailedWithError:(NSError *)error
{
    NSLog(@"getalltopic  failded !!");
}


#pragma mark - uitableviewdelegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"suck me, baby one more time");
    SingleTopicInfoViewController *singleVC=[[SingleTopicInfoViewController alloc]init];
    singleVC.showSingleTopic=[allTopicArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:singleVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [allTopicArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 1.0f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    ShowMyTopicListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell=[[ShowMyTopicListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    NSInteger row=indexPath.row;
    
    NSDictionary *alltopicDic=[allTopicArray objectAtIndex:row];
    NSString *nametopic=[alltopicDic objectForKey:@"t_name"];
    NSString *timetopic=[alltopicDic objectForKey:@"t_created_date"];
    NSString *contenttopic=[alltopicDic objectForKey:@"t_content"];
    NSString *imagetopic=[[alltopicDic objectForKey:@"t_image_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imageURl=[NSURL URLWithString:imagetopic];
    NSData *data = [NSData dataWithContentsOfURL:imageURl];

    cell.topicName.text=nametopic;
    cell.topicUpdateTime.text=timetopic;
    cell.topicIntroduce.text=contenttopic;
    cell.topicImageView.image=[UIImage imageWithData:data];
    return cell;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
