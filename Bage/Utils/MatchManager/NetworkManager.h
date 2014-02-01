//
//  NetworkManager.h
//  Bage
//
//  Created by Duger on 14-1-8.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kQuickMatchingSuccess @"QuickMatchingSuccess"
#define kDidReceiveTempMetchedData @"didReceiveTempMetchedData" 
#define kDidReceiveMetchedData @"didReceiveMetchedData"
@interface NetworkManager : NSObject



-(void)submit:(NSString *)string;

-(void)searchMatchedList:(NSString *)submin;

-(void)searchTempMatchedList:(NSString *)submin;

@end
