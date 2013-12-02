//
//  homeView.m
//  DaysInLine
//
//  Created by 张力 on 13-10-20.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "homeView.h"

@implementation homeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
     //   UIImageView *homeBackground = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backgroundHome"]];
        UIImageView *homeBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        homeBackground.image = [UIImage imageNamed:@"backgroundHome"];
                                       
        
        [self addSubview:homeBackground];
        [self sendSubviewToBack:homeBackground];
        
        UIButton *my_todayButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 80, 84, 45)];
        my_todayButton.backgroundColor = [UIColor brownColor];
        [my_todayButton setTitle:@"Today" forState:UIControlStateNormal];
        self.todayButton = my_todayButton;
        
        UIButton *my_selectButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 140, 84, 45)];
        my_selectButton.backgroundColor = [UIColor brownColor];
        [my_selectButton setTitle:@"查询" forState:UIControlStateNormal];
        self.selectButton = my_selectButton;
        
        UIButton *my_treasureButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 200, 84, 45)];
        my_treasureButton.backgroundColor = [UIColor brownColor];
        [my_treasureButton setTitle:@"聚宝盆" forState:UIControlStateNormal];
        self.treasureButton = my_treasureButton;
        
        UIButton *my_achieveButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 260, 84, 45)];
        my_achieveButton.backgroundColor = [UIColor brownColor];
        [my_achieveButton setTitle:@"成就" forState:UIControlStateNormal];
        self.achieveButton = my_achieveButton;
        
        UIButton *my_analyseButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 320, 84, 45)];
        my_analyseButton.backgroundColor = [UIColor brownColor];
        [my_analyseButton setTitle:@"统计" forState:UIControlStateNormal];
        self.analyseButton = my_analyseButton;
        
        [self addSubview:my_todayButton];
        [self addSubview:my_selectButton];
        [self addSubview:my_treasureButton];
        [self addSubview:my_achieveButton];
        [self addSubview:my_analyseButton];
        
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
