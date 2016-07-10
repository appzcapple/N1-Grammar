//
//  DBManager.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/11.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "DBManager.h"
#import <Foundation/Foundation.h>
#import <sqlite3.h>

@implementation DBManager

+(void)handleDatabaseWithSql:(NSString *)sql{
        NSString *databaseName = @"test.sqlite";
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];
        NSString *databasePath = [path stringByAppendingPathComponent:databaseName];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        NSError *error = nil;
        
        // comfirm the file is exist
        if (![manager fileExistsAtPath:databasePath]) {
            
            // フォルダに存在しない場合は、データベースをコピーする
            NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
            BOOL success = [manager copyItemAtPath:defaultDBPath toPath:databasePath error:&error];
            
            if (success) {
                NSLog(@"Database file copied.");
            } else {
                NSLog(@"%@", error);
                return ;
            }
        } else {
            
            NSLog(@"Database file exist.");
        }
        
        sqlite3 *database;
        sqlite3_stmt *statement;
        
        // フォルダに用意されたデータベースファイルを開く
        if (sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            
            int result = sqlite3_prepare_v2(database, [sql UTF8String], -1, &statement, NULL);
            
            // SQLite のコンパイルに失敗した場合
            if (result != SQLITE_OK) {
                NSLog(@"Failed to SQLite compile.");
                return ;
            }
            
            // SQL 文を実行し、結果が得られなくなるまで繰り返す
            while (sqlite3_step(statement) == SQLITE_ROW) {
                
                NSLog(@"%d, %@", sqlite3_column_int(statement, 0),[NSString stringWithUTF8String:(char*)sqlite3_column_text(statement, 1)]);
            }
            
            // データベースを閉じる
            sqlite3_close(database);
        } else {
            
            NSLog(@"Can't open database.");
        }
        
        return ;

}

@end
