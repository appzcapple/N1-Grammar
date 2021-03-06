//
//  AppzcGrammarTypesViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcBookmarksViewControllerService.h"
#import "DBManager.h"
#import "AppzcJpGrammar.h"


@implementation AppzcBookmarksViewControllerService

-(NSMutableArray *)updateSourceList{
    NSMutableArray *sourceList = [NSMutableArray array];
    DBManager *dbManager = [DBManager getManager];
    
    NSMutableArray *bookmarkIds = [dbManager getBookmarkedIds];
    
    if (bookmarkIds.count < 1) {
        return sourceList;
    }
    
    NSString *ids = @"'";
    for (NSString *bkid in bookmarkIds) {
        ids = [ids stringByAppendingString:bkid];
        ids = [ids stringByAppendingString:@"','"];
    }
    ids = [ids stringByAppendingString:@"99999')"];
    
    [dbManager start:@"Grammar.sqlite"];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM GRAMMARS WHERE ID IN(%@",ids];
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
