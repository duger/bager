//
//  ToolsClass.h
//  Bage
//
//  Created by lixinda on 14-1-9.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolsClass : NSObject

+(id) instance;
-(NSString *) cutString:(NSString *) str OfSubStr:(NSString *)subStr;

@end
