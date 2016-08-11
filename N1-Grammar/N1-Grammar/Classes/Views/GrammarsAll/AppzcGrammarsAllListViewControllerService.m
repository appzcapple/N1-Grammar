//
//  AppzcGrammarTypesViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarsAllListViewControllerService.h"
#import "DBManager.h"
#import "AppzcJpGrammar.h"


@implementation AppzcGrammarsAllListViewControllerService

-(NSMutableArray *)updateSourceList{
    NSMutableArray *sourceList = [NSMutableArray array];
    DBManager *dbManager = [DBManager getManager];
    [dbManager start:@"Grammar.sqlite"];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = @"SELECT * FROM GRAMMARS";
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            AppzcJpGrammar *grammar = [[AppzcJpGrammar alloc] init];
            [grammar setInfoWithFMResultSet:rs];
            [sourceList addObject:grammar];
        }
    } databaseName:@"Grammar.sqlite"];
    [dbManager stop:@"Grammar.sqlite"];
    return sourceList;
}

@end
