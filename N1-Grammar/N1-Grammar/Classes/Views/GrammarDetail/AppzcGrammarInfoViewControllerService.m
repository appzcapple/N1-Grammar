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
    [dbManager start];
    [dbManager inDatabase:^(FMDatabase *db) {
        NSString *sql = [NSString stringWithFormat:@"SELECT * FROM GRAMMARS_SENTENCES WHERE GRAMMAR_ID = '%@'",grammarId];
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            AppzcJpGrammarSentence *sentence = [[AppzcJpGrammarSentence alloc] init];
            [sentence setInfoWithFMResultSet:rs];
            [sourceList addObject:sentence];
        }
    }];
    [dbManager stop];
    return sourceList;
}

@end
