//
//  BageSetupInfomationManager.h
//  Bage
//
//  Created by Duger on 13-12-25.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BageSetupInfomationManager : NSObject
+(BageSetupInfomationManager *)defaultManager;

-(NSArray *)getInfromationForKey:(NSString *)key;

@end
