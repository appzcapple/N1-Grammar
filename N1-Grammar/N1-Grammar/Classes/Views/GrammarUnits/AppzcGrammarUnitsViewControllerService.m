//
//  AppzcGrammarTypesViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarUnitsViewControllerService.h"
#import "DBManager.h"


@implementation AppzcGrammarUnitsViewControllerService

-(NSMutableArray *)updateSourceList:(NSString *)type{
    NSMutableArray *sourceList = [NSMutableArray array];
    DBManager *dbManager = [DBManager getManager];
    [dbManager start:@"Grammar.sqlite"];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT DISTINCT UNIT_ID FROM GRAMMARS WHERE TYPE = '%@'",type ];;
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *type = [rs stringForColumn:@"UNIT_ID"];
            [sourceList addObject:type];
        }
    } databaseName:@"Grammar.sqlite"];
    [dbManager stop:@"Grammar.sqlite"];
    return sourceList;
}

@end
