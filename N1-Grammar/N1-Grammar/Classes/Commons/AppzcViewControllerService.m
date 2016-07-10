//
//  AppzcViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/11.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcViewControllerService.h"

@implementation AppzcViewControllerService

@synthesize viewController;

-(id)initWithViewController:(UIViewController *)vc{
    self = [super init];
    if (!self) {
        return nil;
    }
    self.viewController = vc;
    return self;
}

@end
