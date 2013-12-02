//
//  ViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-10-19.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "redrawButtonDelegate.h"

@class homeView;
@class daylineView;

@interface ViewController : UIViewController <redrawButtonDelegate>
{
    sqlite3 *dataBase;
    NSString *databasePath;
   
}
@property (weak, nonatomic) NSObject <redrawButtonDelegate> *drawBtnDelegate;
@end
