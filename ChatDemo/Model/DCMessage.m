//
//  DCMessage.m
//  类似QQ主页的侧滑
//
//  Created by 许大成 on 17/5/25.
//  Copyright © 2017年 许大成. All rights reserved.
//

#import "DCMessage.h"

@implementation DCMessage

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    self.icon = dict[@"icon"];
    self.time = dict[@"time"];
    self.content = dict[@"content"];
    self.type = [dict[@"type"] intValue];
}

@end
