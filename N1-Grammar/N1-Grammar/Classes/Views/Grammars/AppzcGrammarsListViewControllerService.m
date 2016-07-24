//
//  AppzcGrammarTypesViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarsListViewControllerService.h"
#import "DBManager.h"
#import "AppzcJpGrammar.h"


@implementation AppzcGrammarsListViewControllerService

-(NSMutableArray *)updateSourceList:(NSString *)type unit:(NSString *)unit{
    NSMutableArray *sourceList = [NSMutableArray array];
    DBManager *dbManager = [DBManager getManager];
    [dbManager start];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM GRAMMARS WHERE TYPE = '%@' AND UNIT_ID = '%@'",type, unit ];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            AppzcJpGrammar *grammar = [[AppzcJpGrammar alloc] init];
            [grammar setInfoWithFMResultSet:rs];
            [sourceList addObject:grammar];
        }
    }];
    [dbManager stop];
    return sourceList;
}

@end
