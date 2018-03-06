//
//  ViewController.m
//  ChatDemo
//
//  Created by wenhua on 2018/3/6.
//  Copyright © 2018年 wenhua. All rights reserved.
//

#import "ViewController.h"
#import "DCCell.h"
#import "DCMessageFrame.h"
#import "DCMessage.h"
#import "FMDatabase.h"

#define Margin 5
#define screenW  [UIScreen mainScreen].bounds.size.width
#define screenH  [UIScreen mainScreen].bounds.size.height

@interface ViewController()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    FMDatabase *db;
}
@property(strong,nonatomic)UITableView *tableView;
@property(nonatomic,strong) UITextField * sendTextField;
@property(nonatomic,strong) UITextField * receiveTextField;

@property(nonatomic,strong) NSMutableArray * dataSource;

@end


@implementation ViewController

-(void)loadDataSource//-------------从数据库里面加载数据--------------
{
    if (_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    _dataSource = [self getList];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self tableViewScrollToBottom];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"ChatDemo";
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.image = [UIImage imageNamed:@"12345.jpg"];
    imageView.userInteractionEnabled = YES;
    [self.view addSubview:imageView];
    
    
    //--------无聊的时候自己也能和自己聊天
    [self setUpChatView];
    
}
-(void)setUpChatView
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundDidClick)];
    [self.view addGestureRecognizer:gesture];
    
    [self setUpUI];
    
    [self createListTable];
    [self loadDataSource];
    
}

-(void)setUpUI
{
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, screenW, screenH - 80 - 4)];
    tableView.allowsSelection = NO;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    UITextField *sendTextField = [[UITextField alloc]initWithFrame:CGRectMake(Margin, CGRectGetMaxY(self.tableView.frame), (screenW - Margin *3) /2, 40)];
    sendTextField.delegate = self;
    sendTextField.placeholder = @"send message...";
    sendTextField.backgroundColor = [UIColor whiteColor];
    sendTextField.layer.cornerRadius = 4;
    sendTextField.layer.borderWidth = 1.0;
    sendTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //设置textField输入起始位置
    sendTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    sendTextField.leftViewMode = UITextFieldViewModeAlways;
    self.sendTextField = sendTextField;
    [self.view addSubview:sendTextField];
    
    UITextField *receiveTextField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.sendTextField.frame) + Margin, CGRectGetMaxY(self.tableView.frame), self.sendTextField.frame.size.width, 40)];
    receiveTextField.delegate = self;
    receiveTextField.placeholder = @"receive message...";
    receiveTextField.backgroundColor = [UIColor whiteColor];
    receiveTextField.layer.cornerRadius = 4;
    receiveTextField.layer.borderWidth = 1.0;
    receiveTextField.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //设置textField输入起始位置
    receiveTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    receiveTextField.leftViewMode = UITextFieldViewModeAlways;
    self.receiveTextField = receiveTextField;
    [self.view addSubview:receiveTextField];
    
}

//滚到底部
-(void)tableViewScrollToBottom
{
    if (_dataSource.count == 0) {
        return;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_dataSource.count -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
#pragma mark - 键盘处理
#pragma mark 键盘即将显示
- (void)keyBoardWillShow:(NSNotification *)note{
    
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];
    
}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}

/**
 *  数据库 建表，插入数据，拿取数据
 */
-(void)createListTable
{
    NSString *file = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSLog(@"-------file-----%@",file);
    NSString *path = [file stringByAppendingPathComponent:@"chat.sqlite"];
    db = [FMDatabase databaseWithPath:path];

    if ([db open]) {
        BOOL result;
        result = [db executeUpdate:@"CREATE TABLE IF NOT EXISTS t_chat (id integer PRIMARY KEY AUTOINCREMENT,content text,time text,icon text,type integer NOT NULL)"];
        if (result) {
            NSLog(@"创建表成功！！！！！");
        }else
        {
            NSLog(@"创建表失败-------");
        }
    }
    else {
        NSLog(@"faile to create a FMDB");
    }
}
-(void)insertMessage:(DCMessageFrame *)msgF
{
    if ([db open]) {
        NSString *typeStr = [NSString stringWithFormat:@"%ld",(long)msgF.message.type];
        [db executeUpdate:@"INSERT INTO t_chat (content,time,icon,type) VALUES (?,?,?,?);",msgF.message.content,msgF.message.time,msgF.message.icon,typeStr];
    }
    [db close];
}
-(NSMutableArray *)getList
{
    NSMutableArray *arr = [NSMutableArray array];
    if ([db open]) {
        FMResultSet *res = [db executeQuery:@"SELECT * FROM t_chat"];
        while (res.next) {
            DCMessageFrame *msgF = [[DCMessageFrame alloc]init];
            DCMessage *p = [[DCMessage alloc]init];
            p.content = [res stringForColumn:@"content"];
            p.time = [res stringForColumn:@"time"];
            p.icon = [res stringForColumn:@"icon"];
            p.type = [res intForColumn:@"type"];
            NSLog(@"p.type-----------%d",p.type);
            msgF.message = p;
            [arr addObject:msgF];
        }
    }
    [db close];
    return arr;
}

#pragma mark 点击textField键盘的回车按钮
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    // 1、增加数据源
    NSString *content = textField.text;
    //获取时间
    NSDate *date = [NSDate date];
    NSDateFormatter *dateForMatter = [[NSDateFormatter alloc]init];
    //hh：mm是09：54这样的格式，可以自由发挥
    dateForMatter.dateFormat = @"hh:mm";
    NSString *time = [dateForMatter stringFromDate:date];
    
    if (textField == self.sendTextField) {
        
        [self addMyMessageContent:content time:time];
    }
    else
    {
        [self addOtherMessageContent:content time:time];
    }
    // 2、刷新表格
    [self.tableView reloadData];
    // 3、滚动至当前行
    [self tableViewScrollToBottom];
    // 4、清空文本框内容
    textField.text = nil;
    return YES;
}
#pragma mark 给数据源增加内容
-(void)addMyMessageContent:(NSString *)content time:(NSString *)time
{
    DCMessageFrame *msgF = [[DCMessageFrame alloc]init];
    DCMessage *msg = [[DCMessage alloc]init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"boy.jpg";
    msg.type = MessageTypeMe;
    msgF.message = msg;
    [self insertMessage:msgF];
    [_dataSource addObject:msgF];
}
-(void)addOtherMessageContent:(NSString *)content time:(NSString *)time
{
    DCMessageFrame *msgF = [[DCMessageFrame alloc]init];
    DCMessage *msg = [[DCMessage alloc]init];
    msg.content = content;
    msg.time = time;
    msg.icon = @"girl.jpg";
    msg.type = MessageTypeOther;
    msgF.message = msg;
    [self insertMessage:msgF];
    [_dataSource addObject:msgF];
}

#pragma mark - tableView delegate & datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DCCell *cell = [DCCell cellWithTableView:tableView];
    [cell setMessageFrame:_dataSource[indexPath.row]];
    NSLog(@"type+++++++%d",cell.messageFrame.message.type);
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_dataSource[indexPath.row] cellHeight];
}
-(void)backgroundDidClick
{
    [self.view endEditing:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
