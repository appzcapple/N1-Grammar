//
//  AppzcRoundRectButtion.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/18.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcRoundRectButtion.h"

@implementation AppzcRoundRectButtion

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (!self) {
        return nil;
    }
    
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    return self;
}

@end
