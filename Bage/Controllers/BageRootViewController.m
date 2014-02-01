//
//  BageRootViewController.m
//  Bage
//
//  Created by Duger on 13-12-23.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BageRootViewController.h"
#import "BageHomeViewController.h"
#import "BageEventsViewController.h"
#import "BageContactViewController.h"
#import "BagePersonalViewController.h"
#import "MLNavigationController.h"

@interface BageRootViewController ()
-(UINavigationController *)_createNavigationControllerWithRootViewController:(UIViewController *)rootVC;
@end

@implementation BageRootViewController

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
	// Do any additional setup after loading the view.
    //实例化各个视图控制器
    BageHomeViewController *homeVC = [[BageHomeViewController alloc]init];
    BageEventsViewController *eventsVC = [[BageEventsViewController alloc]init];
    BageContactViewController *contactVC = [[BageContactViewController alloc]initWithNibName:@"BageContactViewController" bundle:nil];
    BagePersonalViewController *personalVC = [[BagePersonalViewController alloc]init];
    NSArray *naviArray = [[NSArray alloc]initWithObjects:
                          [self _createNavigationControllerWithRootViewController:homeVC],
                          [self _createNavigationControllerWithRootViewController:eventsVC],
                          [self _createNavigationControllerWithRootViewController:contactVC],
                          [self _createNavigationControllerWithRootViewController:personalVC],nil];
    
    self.viewControllers = naviArray;   //指定tabarVC的viewControllers
    
    [homeVC release];
    [eventsVC release];
    [contactVC release];
    [personalVC release];
    [naviArray release];
    
}

- (void)dealloc
{
   
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Private Method 
//为视图指定navigationController
-(UINavigationController *)_createNavigationControllerWithRootViewController:(UIViewController *)rootVC
{
    UINavigationController *naviVC = [[UINavigationController alloc]initWithRootViewController:rootVC];
//    naviVC.navigationController.navigationBar.tintColor = [UIColor purpleColor];
    naviVC.interactivePopGestureRecognizer.enabled = YES;
   
    
    return [naviVC autorelease];
}

@end
