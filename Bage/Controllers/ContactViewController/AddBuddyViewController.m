//
//  AddBuddyViewController.m
//  Bage
//
//  Created by lixinda on 13-12-29.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "AddBuddyViewController.h"
#import "XMPPManager.h"
#import "HttpDownload.h"
#import "FriendsPersonalCell.h"
#import "BuddyDetailAddViewController.h"

@interface AddBuddyViewController ()

@end

@implementation AddBuddyViewController
{
    NSMutableArray * buddyArray;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        buddyArray = [[NSMutableArray alloc]init];
        self.seachResultTableView.hidden = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.seachResultTableView.delegate = self;
    self.seachResultTableView.dataSource = self;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_seachTextField release];
    [_seachResultTableView release];
    [super dealloc];
}
- (IBAction)seachButtonAction:(id)sender {
    [self.seachTextField resignFirstResponder];
    if (self.seachTextField.text) {
        HttpDownload * hd = [[HttpDownload alloc]init];
        hd.delegate = self;
        [hd downloadFromUrl:@"asd"];
        hd.type =10104;
        hd.method=@selector(downloadComplete:);
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请输入查找的用户名" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark - download Data -
-(void)downloadComplete:(HttpDownload *)hd{
//    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:hd.downloadData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",dict);
    
    NSArray *array=[NSJSONSerialization JSONObjectWithData:hd.downloadData options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"%@",array);
    if (array.count>0) {
        for (NSDictionary * dicItem in array) {
            BuddyItem * buddyItem= [[BuddyItem alloc]initWithBuddyDict:[array lastObject]];
            [buddyArray addObject:buddyItem];
            [buddyItem release];
        }
    }
    self.seachResultTableView.hidden = NO;
    [self.seachResultTableView reloadData];
}
#pragma mark - tableView DataSource -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return buddyArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellName=@"FriendsPersonalCell";
    FriendsPersonalCell * cell=[tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell==nil){
        cell=[[[NSBundle mainBundle]loadNibNamed:@"FriendsPersonalCell" owner:self options:nil]lastObject];
    }
    cell.backgroundColor = [UIColor redColor];
    [cell setPersonAtrributeWithBuddyItem:[buddyArray objectAtIndex:indexPath.row]];
    return  cell;
}
#pragma mark - tableView delegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BuddyDetailAddViewController * buddyDetailVC = [[BuddyDetailAddViewController alloc]initWithNibName:@"BuddyDetailAddViewController" bundle:nil];
    buddyDetailVC.buddyItem = [buddyArray objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:buddyDetailVC animated:YES];
    [buddyDetailVC release];
}

#pragma mark - textFieldDelegate -
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
