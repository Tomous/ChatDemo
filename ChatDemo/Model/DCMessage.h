//
//  DCMessage.h
//  类似QQ主页的侧滑
//
//  Created by 许大成 on 17/5/25.
//  Copyright © 2017年 许大成. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    
    MessageTypeMe  = 0,
    MessageTypeOther  = 1
    
}MessageType;

@interface DCMessage : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, assign) MessageType type;

@property (nonatomic, copy) NSDictionary *dict;

@end
