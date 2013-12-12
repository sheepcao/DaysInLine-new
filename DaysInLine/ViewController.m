//
//  ViewController.m
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "ViewController.h"
#import "homeView.h"
#import "daylineView.h"
#import "dayLineScoller.h"
#import "buttonInScroll.h"
#import "editingViewController.h"
#import "globalVars.h"


@interface ViewController ()

@property (nonatomic,weak) UIImageView *background;
@property (nonatomic,weak) homeView *homePage;
@property (nonatomic,strong) daylineView *my_dayline ;
@property (nonatomic,strong) dayLineScoller *my_scoller;
@property (nonatomic,strong) NSString *today;
@end

@implementation ViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    homeView *my_homeView = [[homeView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:my_homeView];
    self.homePage = my_homeView;
    [my_homeView.todayButton addTarget:self action:@selector(todayTapped) forControlEvents:UIControlEventTouchUpInside];
    
    //初始化全局数据
    for (int i=0; i<18; i++) {
        workArea[i] = 0;
        lifeArea[i] = 0;
    }
    modifying = 0;

    
    
    //创建或打开数据库
    NSString *docsDir;
    NSArray *dirPaths;
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    
    databasePath = [[NSString alloc] initWithString:[docsDir stringByAppendingPathComponent:@"info.sqlite"]];
    
 //   NSFileManager *filemanager = [NSFileManager defaultManager];
    
    NSLog(@"路径：%@",databasePath);
    
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
 /*           NSString *createsql = @"CREATE TABLE IF NOT EXISTS DAYTABLE (ID INTEGER PRIMARY KEY AUTOINCREMENT,DATE TEXT UNIQUE,MOOD INTEGER,GROWTH INTEGER)";
 */
            NSString *createDayable = @"CREATE TABLE IF NOT EXISTS DAYTABLE (DATE TEXT PRIMARY KEY,MOOD INTEGER,GROWTH INTEGER)";
            NSString *createEvent = @"CREATE TABLE IF NOT EXISTS EVENT (eventID INTEGER PRIMARY KEY AUTOINCREMENT,TYPE INTEGER,TITLE TEXT,mainText TEXT,income REAL,expend REAL,date TEXT,startTime TEXT,endTime TEXT,distance TEXT,label TEXT,remind INTEGER,startArea INTEGER,photoDir TEXT)";
            NSString *createRemind = @"CREATE TABLE IF NOT EXISTS REMIND (remindID INTEGER PRIMARY KEY AUTOINCREMENT,eventID INTEGER,date TEXT,fromToday TEXT,time TEXT)";

            [self execSql:createDayable];
            [self execSql:createEvent];
            [self execSql:createRemind];
        }
        else {
            NSLog(@"数据库打开失败");
            
        }
    
    sqlite3_close(dataBase);
    

    
    
    CGRect rect=[[UIScreen mainScreen] bounds];
    NSLog(@"x:%f,y:%f\nwidth%f,height%f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    
      
       
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)todayTapped
{

    
    CGRect frame = CGRectMake(85,0, self.view.bounds.size.width-85, self.view.bounds.size.height );
    self.my_dayline = [[daylineView alloc] initWithFrame:frame];
    [self.homePage addSubview:self.my_dayline];
    
     self.my_scoller = [[dayLineScoller alloc] initWithFrame:CGRectMake(86,110, self.view.bounds.size.width-86.4, self.view.bounds.size.height-220)];
    
    self.my_scoller.modifyEvent_delegate = self;
    self.drawBtnDelegate = self.my_scoller;
    

    [self.homePage addSubview:self.my_scoller];
    
    for (int i = 0; i<10; i++) {
        [[self.my_dayline.starArray objectAtIndex:i] addTarget:self action:@selector(starTapped:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.my_dayline.addMoreLife addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.my_dayline.addMoreWork addTarget:self action:@selector(eventTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    //获取当前日期
    NSDateFormatter *formater = [[ NSDateFormatter alloc] init];
    
    NSDate *curDate = [NSDate date];//获取当前日期
    [formater setDateFormat:@"yyyy-MM-dd"];
    self.today= [formater stringFromDate:curDate];
    NSLog(@"!!!!!!!%@",self.today);
    sqlite3_stmt *statement;
    
    modifyDate = self.today;
    const char *dbpath = [databasePath UTF8String];
    //查看当天是否已经有数据
    
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryStar = [NSString stringWithFormat:@"SELECT mood,growth from DAYTABLE where DATE=\"%@\"",modifyDate];
        const char *queryStarstatement = [queryStar UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryStarstatement, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //当天数据已经存在，则取出数据还原界面
                int moodNum = sqlite3_column_int(statement, 0);
                for (int i = 0; i<=moodNum-1; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                
             
                int growthNum = sqlite3_column_int(statement, 1);
                for (int i = 0; i<=growthNum-1; i++) {
                    [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
                }
                
            }
            else {
                 // 插入当天的数据
                NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE,mood,growth) VALUES(?,?,?)"];
                
                //    NSString *insertSql = [NSString stringWithFormat:@"INSERT INTO DAYTABLE(DATE) VALUES(\"%@\",\"%d\")",today,9];
                const char *insertsatement = [insertSql UTF8String];
                sqlite3_prepare_v2(dataBase, insertsatement, -1, &statement, NULL);
                sqlite3_bind_text(statement, 1, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
                sqlite3_bind_int(statement, 2, 0);
                sqlite3_bind_int(statement, 3, 0);
                
                
                if (sqlite3_step(statement)==SQLITE_DONE) {
                    NSLog(@"innsert today ok");
                }
                else {
                    NSLog(@"Error while insert:%s",sqlite3_errmsg(dataBase));
                }
                
            }
            
        }
        else{
            NSLog(@"Error in select:%s",sqlite3_errmsg(dataBase));

        }
        sqlite3_finalize(statement);
        
        NSString *queryEventButton = [NSString stringWithFormat:@"SELECT type,title,startTime,endTime from event where DATE=\"%@\"",modifyDate];
        const char *queryEventstatement = [queryEventButton UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatement, -1, &statement, NULL)==SQLITE_OK) {
            while (sqlite3_step(statement)==SQLITE_ROW) {
                //当天已有事件存在，则取出数据还原界面
                NSString *title;
                NSNumber *evtType = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];
                char *ttl = (char *)sqlite3_column_text(statement, 1);
                NSLog(@"char is %s",ttl);
                if (ttl == nil) {
                    title = @"";
                }else {
                    title = [[NSString alloc] initWithUTF8String:ttl];
                    NSLog(@"nsstring  is %@",title);
                }
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,2)];
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,3)];
                
                [self.drawBtnDelegate redrawButton:startTm :endTm :title :evtType :NULL];
                
                if ([evtType intValue]==0) {
                    for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                        workArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else if([evtType intValue]==1){
                    for (int i = [startTm intValue]/30; i <= [endTm intValue]/30; i++) {
                        lifeArea[i] = 1;
                        NSLog(@"seized work area is :%d",i);
                    }
                }else{
                    NSLog(@"事件类型有误！");
                }
               
            }
            
        }
        
            sqlite3_finalize(statement);
      
    }
    
    
    else {
        NSLog(@"数据库打开失败");
        
    }
      sqlite3_close(dataBase);

     
}

-(void)starTapped:(UIButton*)sender
{
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        
        
        if (sender.tag <100) {
            
            for (int i = 0; i<=sender.tag; i++) {
                [[self.my_dayline.starArray objectAtIndex:i] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
            }
            for (int j = sender.tag+1; j<5; j++) {
                [[self.my_dayline.starArray objectAtIndex:j] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
            }
            
            //数据库更新
            
            sqlite3_stmt *stmt;
            //如果已经存在并且已登陆，则修改状态值
            const char *Update="update DAYTABLE set MOOD=?where date=?";
            if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, sender.tag+1);
            sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
            
        }
        else
        {
            for (int i = 0; i<=sender.tag-100; i++) {
                [[self.my_dayline.starArray objectAtIndex:i+5] setImage:[UIImage imageNamed:@"star2.png"] forState:UIControlStateNormal];
            }
            for (int j = sender.tag-99; j<5; j++) {
                [[self.my_dayline.starArray objectAtIndex:j+5] setImage:[UIImage imageNamed:@"star1.png"] forState:UIControlStateNormal];
            }
            
            //数据库更新
            sqlite3_stmt *stmt;
            //如果已经存在并且已登陆，则修改状态值
            const char *Update="update DAYTABLE set growth=?where date=?";
            if (sqlite3_prepare_v2(dataBase, Update, -1, &stmt, NULL)!=SQLITE_OK) {
                NSLog(@"Error:%s",sqlite3_errmsg(dataBase));
            }
            sqlite3_bind_int(stmt, 1, sender.tag-99);
            sqlite3_bind_text(stmt, 2, [modifyDate UTF8String], -1, SQLITE_TRANSIENT);
            sqlite3_step(stmt);
            sqlite3_finalize(stmt);
        }
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    
    sqlite3_close(dataBase);
    
}

-(void)eventTapped:(UIButton *)sender
{
   editingViewController *my_editingViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    my_editingViewController.eventType = [NSNumber numberWithInt:sender.tag];
    NSLog(@"type is:%@",my_editingViewController.eventType);
    my_editingViewController.drawBtnDelegate = self.my_scoller;

    modifying = 0;
    
    my_editingViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:my_editingViewController animated:YES completion:Nil ];
    
}

//数据库操作方法
-(void)execSql:(NSString *)sql
{
    char *err;
    if (sqlite3_exec(dataBase, [sql UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        sqlite3_close(dataBase);
        NSLog(@"数据库操作数据失败!");
    }
}

#pragma mark modify delegation

-(void)modifyEvent:(NSNumber *)startArea;
{
    NSString *title_mdfy;
    NSString *mainTxt_mdfy;
    NSNumber *evtID_mdfy;
    NSNumber *evtType_mdfy;
  
    NSString *startTime;
    NSString *endTime;
 
    modifying = 1;
    
    NSLog(@"button tag is -----%@",startArea);
    
    
    
    sqlite3_stmt *statement;
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &dataBase)==SQLITE_OK) {
        NSString *queryEvent = [NSString stringWithFormat:@"SELECT eventID,type,title,mainText,startTime,endTime,income from event where DATE=\"%@\" and startArea=\"%d\"",modifyDate,[startArea intValue]];
        const char *queryEventstatment = [queryEvent UTF8String];
        if (sqlite3_prepare_v2(dataBase, queryEventstatment, -1, &statement, NULL)==SQLITE_OK) {
            if (sqlite3_step(statement)==SQLITE_ROW) {
                //找到要修改的事件，取出数据。
                
    
                evtID_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 0)];

                evtType_mdfy = [[NSNumber alloc] initWithInt:sqlite3_column_int(statement, 1)];
                char *ttl_mdfy = (char *)sqlite3_column_text(statement, 2);
                NSLog(@"char_mdfy is %s",ttl_mdfy);
                if (ttl_mdfy == nil) {
                    title_mdfy = @"";
                }else {
                    title_mdfy = [[NSString alloc] initWithUTF8String:ttl_mdfy];
                    NSLog(@"nsstring_mdfy  is %@",title_mdfy);
                }
                
                char *mTxt_mdfy = (char *)sqlite3_column_text(statement, 3);
                NSLog(@"mainTxt_mdfy is %s",mTxt_mdfy);
                if (mTxt_mdfy == nil) {
                    mainTxt_mdfy = @"";
                }else {
                    mainTxt_mdfy = [[NSString alloc] initWithUTF8String:mTxt_mdfy];
                    NSLog(@"nsstring_mdfy  is %@",mainTxt_mdfy);
                }
                
                
                NSNumber *startTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,4)];
               int start = [startTm intValue]+360;
                NSNumber *endTm = [[NSNumber alloc] initWithDouble:sqlite3_column_double(statement,5)];
               int end = [endTm intValue]+360;
                if (start%60<10) {
                    startTime = [NSString stringWithFormat:@"%d:0%d",start/60,start%60];

                }else{
                    startTime = [NSString stringWithFormat:@"%d:%d",start/60,start%60];
                }
                if (end%60<10) {
                    endTime = [NSString stringWithFormat:@"%d:0%d",end/60,end%60];
                    
                }else{
                    endTime = [NSString stringWithFormat:@"%d:%d",end/60,end%60];
                }

                
                NSLog(@"start time is:%@",startTime);
                
                              
            }
            
        }
        sqlite3_finalize(statement);
    }
    else {
        NSLog(@"数据库打开失败");
        
    }
    sqlite3_close(dataBase);
    editingViewController *my_modifyViewController = [[editingViewController alloc] initWithNibName:@"editingView" bundle:nil];
    my_modifyViewController.drawBtnDelegate = self.my_scoller;
    
    
    
    
    //将该事件还原现使出来
    my_modifyViewController.eventType = evtType_mdfy;
    [(UITextField*)[my_modifyViewController.view viewWithTag:105] setText:title_mdfy] ;
    [(UITextView*)[my_modifyViewController.view viewWithTag:106] setText:mainTxt_mdfy];
    [(UILabel*)[my_modifyViewController.view viewWithTag:103] setText:startTime];
    [(UILabel*)[my_modifyViewController.view viewWithTag:104] setText:endTime];
    [(UIButton*)[my_modifyViewController.view viewWithTag:101] setTitle:@"" forState:UIControlStateNormal];
    [(UIButton*)[my_modifyViewController.view viewWithTag:102] setTitle:@"" forState:UIControlStateNormal];
 //   [(UITextField*)[my_modifyViewController.moneyAlert viewWithTag:501] setText:[NSString stringWithFormat:@"%.2f",[income_mdfy floatValue]]];
    modifyEventId = [evtID_mdfy intValue];
    NSLog(@"eventID is : %d",modifyEventId);
   // NSLog(@"income is &&&&&&: %@",[NSString stringWithFormat:@"%.2f",[income_mdfy floatValue]]);
    
    
    my_modifyViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    NSLog(@"%@==========%@",evtType_mdfy,my_modifyViewController.eventType);
    [self presentViewController:my_modifyViewController animated:YES completion:Nil ];
        

}

@end
