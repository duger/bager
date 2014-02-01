//
//  BuddyItem.m
//  Bage
//
//  Created by lixinda on 13-12-28.
//  Copyright (c) 2013年 Duger. All rights reserved.
//

#import "BuddyItem.h"

@interface BuddyItem ()

-(NSData *)_returnImageDataFromString:(NSString *) imageStr;
-(NSString *) _returnImageString:(NSString *)str;

@end

@implementation BuddyItem

-(id) initWithPresence:(XMPPPresence *)presence{
    self = [self init];
    if (self) {
        self.buddyName = presence.from.user;
        self.buddyStatus = presence.status;
        self.buddyResource = presence.show;
        
        
    }
    return self;
}
-(id) initWithBuddyDict:(NSDictionary * ) dict{
    self = [self init];
    if (self) {
        self.buddyName = [dict objectForKey:@"username"];
        self.headerImage = [UIImage imageWithData:[self _returnImageDataFromString:[self _returnImageString:[dict objectForKey:@"vcard"]]]];
    }
    return self;
}


-(NSData *)_returnImageDataFromString:(NSString *) imageStr{
    NSData * imageData = nil;
//    imageData = [NSData dataWithContentsOfFile:imageStr];
    imageData = [[NSData alloc]initWithBase64Encoding:imageStr];
    return [imageData autorelease];
}
-(NSString *) _returnImageString:(NSString *)str{
    NSLog(@"%@",str);
    NSRange range = [str rangeOfString:@"<BINVAL>"];
    range.location = range.location+range.length;
    range.length = str.length - range.location;
    str = [str substringWithRange:range];
//    NSLog(@"%@",str);
    range = [str rangeOfString:@"</BINVAL>"];
    range.length = range.location;
    range.location = 0;
    str = [str substringWithRange:range];
//    NSLog(@"%@",str);
    return str;
}
-(void)dealloc{
    [self.headerImage release];
    [self.buddyName release];
//    self.buddyName = nil;
//    self.headerImage = nil;
    [super dealloc];
}
@end
