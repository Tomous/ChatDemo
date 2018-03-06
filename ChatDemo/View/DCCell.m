//
//  DCCell.m
//  类似QQ主页的侧滑
//
//  Created by 许大成 on 17/5/25.
//  Copyright © 2017年 许大成. All rights reserved.
//

#import "DCCell.h"
#import "DCMessage.h"
#import "DCMessageFrame.h"
@interface DCCell()
{
    UIButton *timeBtn;
    UIImageView *iconView;
    UIButton *contentBtn;
}
@end

@implementation DCCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor = [UIColor clearColor];
        // 1、创建时间按钮
        timeBtn = [[UIButton alloc]init];
        [timeBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        timeBtn.titleLabel.font = kTimeFont;
        timeBtn.enabled = NO;
        [self.contentView addSubview:timeBtn];
        
        // 2、创建头像
        iconView = [[UIImageView alloc]init];
        [self.contentView addSubview:iconView];
        
        // 3、创建内容
        contentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [contentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        contentBtn.titleLabel.font = kContentFont;
        contentBtn.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:contentBtn];
        
    }
    return self;
}

-(void)setMessageFrame:(DCMessageFrame *)messageFrame
{
    _messageFrame = messageFrame;
    DCMessage *message = _messageFrame.message;
    
    // 1、设置时间
    [timeBtn setTitle:message.time forState:UIControlStateNormal];
    timeBtn.frame = _messageFrame.timeF;
    
    // 2、设置头像
    [iconView setImage:[UIImage imageNamed:message.icon]];
    iconView.frame = _messageFrame.iconF;
    
    // 3、设置内容
    [contentBtn setTitle:message.content forState:UIControlStateNormal];
    contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentLeft, kContentBottom, kContentRight);
    contentBtn.frame = _messageFrame.contentF;
    if (message.type == MessageTypeMe) {
        contentBtn.contentEdgeInsets = UIEdgeInsetsMake(kContentTop, kContentRight, kContentBottom, kContentLeft);
    }
    
    UIImage *normal , *focused;
    if (message.type == MessageTypeMe) {
        
        normal = [UIImage imageNamed:@"WeChat_12@2x.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatto_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }else{
        
        normal = [UIImage imageNamed:@"chat_receiver_bg@2x.png"];
        normal = [normal stretchableImageWithLeftCapWidth:normal.size.width * 0.5 topCapHeight:normal.size.height * 0.7];
        focused = [UIImage imageNamed:@"chatfrom_bg_focused.png"];
        focused = [focused stretchableImageWithLeftCapWidth:focused.size.width * 0.5 topCapHeight:focused.size.height * 0.7];
    }
    [contentBtn setBackgroundImage:normal forState:UIControlStateNormal];
    [contentBtn setBackgroundImage:focused forState:UIControlStateHighlighted];
    
}

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *str = @"cell";
    DCCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[DCCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    return cell;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
