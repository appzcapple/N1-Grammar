//
//  AppzcGrammarTypesViewControllerService.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarInfoViewControllerService.h"
#import "DBManager.h"
#import "AppzcJpGrammarSentence.h"


@implementation AppzcGrammarInfoViewControllerService

-(NSMutableArray *)updateSourceList:(NSString *)grammarId{
    NSMutableArray *sourceList = [NSMutableArray array];
    DBManager *dbManager = [DBManager getManager];
    [dbManager start:@"Grammar.sqlite"];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM GRAMMARS_SENTENCES WHERE GRAMMAR_ID = '%@'",grammarId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            AppzcJpGrammarSentence *sentence = [[AppzcJpGrammarSentence alloc] init];
            [sentence setInfoWithFMResultSet:rs];
            [sourceList addObject:sentence];
        }
    } databaseName:@"Grammar.sqlite"];
    [dbManager stop:@"Grammar.sqlite"];
    return sourceList;
}

-(BOOL)isMarked:(NSString *)gid{
    DBManager *dbManager = [DBManager getManager];
    NSMutableArray *bookMarkIds = [dbManager getBookmarkedIds];
    BOOL inbookmark = [bookMarkIds containsObject:gid];
    return inbookmark;
}

-(void)addToMark:(NSString *)gid{
    DBManager *dbManager = [DBManager getManager];
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO BOOKMARK(GRAMMAR_ID) VALUES ('%@')",gid];
    [dbManager start:@"Cache.sqlite"];
    [dbManager inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
    [dbManager stop:@"Cache.sqlite"];
    [dbManager addMarkedId:gid];
}

-(void)removeFromMark:(NSString *)gid{
    DBManager *dbManager = [DBManager getManager];
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM BOOKMARK WHERE GRAMMAR_ID = '%@'",gid];
    [dbManager start:@"Cache.sqlite"];
    [dbManager inTransaction:^(FMDatabase *db, BOOL *rollback) {
        [db executeUpdate:sql];
    }];
    [dbManager stop:@"Cache.sqlite"];
    [dbManager removeMarkedId:gid];
}

@end
