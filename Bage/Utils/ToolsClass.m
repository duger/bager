//
//  ToolsClass.m
//  Bage
//
//  Created by lixinda on 14-1-9.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "ToolsClass.h"

static ToolsClass * s_tool = nil;
@implementation ToolsClass

+(id) instance{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (s_tool == nil) {
            s_tool = [[ToolsClass alloc]init];
        }
    });
    return s_tool;
}

-(NSString *) cutString:(NSString *) str OfSubStr:(NSString *)subStr{
    
    NSRange range = [str rangeOfString:[NSString stringWithFormat:@"@%@",subStr]];
    if (range.length == 0) {
        return str;
    }
    range.length = range.location;
    range.location = 0;
    str = [str substringWithRange:range];
    return str;
}

@end
