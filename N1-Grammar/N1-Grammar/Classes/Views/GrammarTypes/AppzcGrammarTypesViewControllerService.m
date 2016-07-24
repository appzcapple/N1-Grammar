//
//  AppzcGrammarTypesViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarTypesViewControllerService.h"
#import "DBManager.h"


@implementation AppzcGrammarTypesViewControllerService

-(NSMutableArray *)updateSourceList{
    NSMutableArray *sourceList = [NSMutableArray array];
    DBManager *dbManager = [DBManager getManager];
    [dbManager start];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT DISTINCT TYPE FROM GRAMMARS;";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *type = [rs stringForColumn:@"TYPE"];
            [sourceList addObject:type];
        }
    }];
    [dbManager stop];
    return sourceList;
}

@end
