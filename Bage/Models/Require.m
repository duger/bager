//
//  Require.m
//  Bage
//
//  Created by Duger on 14-1-13.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import "Require.h"
#import <objc/runtime.h>


@implementation Require


- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray *)propertyList
{
    if (_propertyList != nil) {
        return _propertyList;
    }
    _propertyList = [[NSMutableArray alloc] init];
    
    unsigned int outCount = 0;
    objc_property_t *properties = NULL;
    //添加父类的属性
    properties = class_copyPropertyList(class_getSuperclass(self.class), &outCount);
    for (int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        if ([propertyName isEqualToString:@"propertyList"]) {
            continue;
        }
        id propertyValue = [self valueForKey:propertyName];
        NSDictionary *tempDic = [NSDictionary dictionaryWithObject:propertyValue forKey:propertyName];
        [_propertyList addObject:tempDic];

    }
    //添加子类的属性
    properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i<outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f =property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:propertyName];
        NSDictionary *tempDic = [NSDictionary dictionaryWithObject:propertyValue forKey:propertyName];
        [_propertyList addObject:tempDic];

    }
    
    return _propertyList;
}

//创建Post请求
- (NSString *)createPostRequire
{
    NSMutableString *require = [[NSMutableString alloc] init];
    
    [self propertyList];
    
    for (NSInteger index = 0; index < self.propertyList.count ; index++)
    {
        NSDictionary *property = self.propertyList[index];
        if (index == 0) {
            [require appendFormat:@"%@=%@",[property allKeys][index],[property allValues][index]];
            continue;
        }
        [require appendFormat:@"&%@=%@",[property allKeys][index],[property allValues][index]];
        
    }
    
    
    return [require autorelease];
}


@end
