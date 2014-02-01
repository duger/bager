//
//  BageSetupInfomationManager.m
//  Bage
//
//  Created by Duger on 13-12-25.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BageSetupInfomationManager.h"

@implementation BageSetupInfomationManager

static BageSetupInfomationManager *instence = nil;
+(BageSetupInfomationManager *)defaultManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instence = [[self alloc]init];
    });
    return instence;
}

-(NSArray *)getInfromationForKey:(NSString *)key
{
    NSDictionary *infoDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"Informations" ofType:@"plist"]];
    NSArray *array = [infoDic objectForKey:key];
    return array;
}


@end
