//
//  DCMessageFrame.m
//  类似QQ主页的侧滑
//
//  Created by 许大成 on 17/5/25.
//  Copyright © 2017年 许大成. All rights reserved.
//

#import "DCMessageFrame.h"
#import "DCMessage.h"

@implementation DCMessageFrame

-(void)setMessage:(DCMessage *)message
{
    _message = message;
    
    // 0、获取屏幕宽度
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    //1、计算时间的位置
    //    if (_showTime) {
    CGFloat timeY = kMargin;
    NSDictionary *timeDic = @{NSFontAttributeName:kTimeFont};
    CGSize timeMaxSize = CGSizeMake(150, 30);
    CGSize timeSize = [_message.time boundingRectWithSize:timeMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:timeDic context:nil].size;
    CGFloat timeX = (screenW - timeSize.width)/2;
    _timeF = CGRectMake(timeX, timeY, timeSize.width + kTimeMarginW, timeSize.height + kTimeMarginH);
    //    }
    // 2、计算头像位置
    CGFloat iconX = kMargin;
    if (_message.type == MessageTypeMe) {
        iconX = screenW - kMargin - kIconWH;
    }
    CGFloat iconY = CGRectGetMaxY(_timeF) + kMargin;
    _iconF = CGRectMake(iconX, iconY, kIconWH, kIconWH);
    
    // 3、计算内容位置
    CGFloat contentX = CGRectGetMaxX(_iconF) + kMargin;
    CGFloat contentY = iconY;
    CGSize contentMaxSize = CGSizeMake(kContentW, CGFLOAT_MAX);
    NSDictionary *contentDic = @{NSFontAttributeName:kContentFont};
    CGSize contentSize = [_message.content boundingRectWithSize:contentMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:contentDic context:nil].size;
    if (_message.type == MessageTypeMe) {
        contentX = iconX - kMargin - contentSize.width - kContentLeft - kContentRight;
    }
    _contentF = CGRectMake(contentX, contentY, contentSize.width + kContentLeft + kContentRight, contentSize.height + kContentTop + kContentBottom);
    
    // 4、计算高度
    _cellHeight = MAX(CGRectGetMaxY(_contentF), CGRectGetMaxY(_iconF))  + kMargin;
}

@end
