//
//  DCCell.h
//  类似QQ主页的侧滑
//
//  Created by 许大成 on 17/5/25.
//  Copyright © 2017年 许大成. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DCMessageFrame;
@interface DCCell : UITableViewCell

@property(nonatomic,strong) DCMessageFrame * messageFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
