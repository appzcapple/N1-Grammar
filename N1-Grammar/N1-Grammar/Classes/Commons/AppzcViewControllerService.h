//
//  AppzcViewControllerService.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/11.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AppzcViewControllerService : NSObject

@property (nonatomic, weak) UIViewController *viewController;

-(id)initWithViewController: (UIViewController *) vc;

@end
