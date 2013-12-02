//
//  buttonInScroll.m
//  DaysInLine
//
//  Created by 张力 on 13-10-21.
//  Copyright (c) 2013年 张力. All rights reserved.
//

#import "buttonInScroll.h"

@implementation buttonInScroll

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self InitButtons];
        
        
    }
    return self;
}

-(void)InitButtons
{
    
  /*  self.addMoreWork = [[UIButton alloc] initWithFrame:CGRectMake(5+36,0, self.frame.size.width/2-10-18, self.frame.size.height)];
    [self.addMoreWork setTitle:@"添加事件..." forState:UIControlStateNormal];
    self.addMoreWork.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.addMoreWork setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.addMoreWork.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.addMoreWork.titleLabel.textAlignment = NSTextAlignmentCenter ;
    self.addMoreWork.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    self.addMoreLife =[[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2+5+18,0, self.frame.size.width/2-10-18,  self.frame.size.height)];
    [self.addMoreLife setTitle:@"添加事件..." forState:UIControlStateNormal];
    self.addMoreLife.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
    [self.addMoreLife setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.addMoreLife.titleLabel.font = [UIFont systemFontOfSize:14.0];
    self.addMoreLife.titleLabel.textAlignment = NSTextAlignmentCenter ;
    self.addMoreLife.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
    
    [self addSubview:self.addMoreWork];
    [self addSubview:self.addMoreLife];
   */
    
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
