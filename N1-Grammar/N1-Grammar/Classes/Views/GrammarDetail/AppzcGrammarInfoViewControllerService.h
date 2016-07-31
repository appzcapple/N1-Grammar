//
//  AppzcGrammarTypesViewControllerService.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcViewControllerService.h"

@interface AppzcGrammarInfoViewControllerService : AppzcViewControllerService

-(NSMutableArray *)updateSourceList:(NSString *)grammarId;

-(BOOL)isMarked:(NSString *)gid;

-(void)removeFromMark:(NSString *)gid;

-(void)addToMark:(NSString *)gid;

@end
