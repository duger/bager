//
//  ShowAllGroupActiveViewController.m
//  Bage
//
//  Created by Adozen12 on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "ShowAllGroupActiveViewController.h"
#import "SingleGroupActiveViewController.h"
#import "ShowMyGroupActiveCell.h"

@interface ShowAllGroupActiveViewController ()
{
    UITableView *groupActive;
}
@end

@implementation ShowAllGroupActiveViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    groupActive=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStyleGrouped];
    groupActive.delegate=self;
    groupActive.dataSource=self;
    [self.view addSubview:groupActive];
    
	// Do any additional setup after loading the view.
}


#pragma mark - uitableviewdelegate -

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
      NSLog(@"suck me, baby one more time");
    
    
    SingleGroupActiveViewController *singleGAVC=[[SingleGroupActiveViewController alloc]init];
    //singleVC.showSingleTopic=[allTopicArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:singleGAVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [allTopicArray count];
    return 12;
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
    ShowMyGroupActiveCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell==nil)
    {
        cell=[[ShowMyGroupActiveCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //NSInteger row=indexPath.row;
    
    
    
//    NSDictionary *alltopicDic=[allTopicArray objectAtIndex:row];
//    NSString *nametopic=[alltopicDic objectForKey:@"t_name"];
//    NSString *timetopic=[alltopicDic objectForKey:@"t_created_date"];
//    NSString *contenttopic=[alltopicDic objectForKey:@"t_content"];
//    NSString *imagetopic=[[alltopicDic objectForKey:@"t_image_url"]stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *imageURl=[NSURL URLWithString:imagetopic];
//    NSData *data = [NSData dataWithContentsOfURL:imageURl];
//    cell.topicName.text=nametopic;
//    cell.topicUpdateTime.text=timetopic;
//    cell.topicIntroduce.text=contenttopic;
//    cell.topicImageView.image=[UIImage imageWithData:data];
    return cell;
}





- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
