//
//  editingViewController.h
//  DaysInLine
//
//  Created by 张力 on 13-10-22.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "redrawButtonDelegate.h"


@interface editingViewController : UIViewController <UIAlertViewDelegate> {
    sqlite3 *dataBase;
    NSString *databasePath;
    NSNumber *startTimeNum;
    NSNumber *endTimeNum;

    
}
@property (weak, nonatomic) IBOutlet UIButton *addTagButton;
@property (weak, nonatomic) IBOutlet UIButton *remindButton;
@property (weak, nonatomic) IBOutlet UIButton *photoButton;
@property (weak, nonatomic) IBOutlet UIButton *moneyButton;

@property (weak, nonatomic) IBOutlet UIButton *addAchieveButton;
@property (weak, nonatomic) IBOutlet UIButton *addCollectionButton;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UIButton *startTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *endTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *returnButton;
@property (weak, nonatomic) UILabel *startLabel;
@property (weak, nonatomic) UILabel *endLabel;
@property (strong, nonatomic) UIAlertView *moneyAlert;

@property (weak, nonatomic) IBOutlet UITextView *mainText;
@property (weak, nonatomic) IBOutlet UITextField *theme;
@property (weak, nonatomic) IBOutlet NSNumber *eventType;

@property (weak, nonatomic) NSObject <redrawButtonDelegate> *drawBtnDelegate;
- (IBAction)endEditing:(id)sender;

@end
