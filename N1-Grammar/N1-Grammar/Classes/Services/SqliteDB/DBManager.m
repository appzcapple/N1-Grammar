//
//  DBManager.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/11.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "DBManager.h"
#import <sqlite3.h>
#import "FMDatabase.h"

#define DATABASE_FILE_NAME @"Grammar.sqlite"
#define DATABASE_KEY @"zc2016"

@interface DBManager (){
    dispatch_queue_t queue;
}

@property (strong,nonatomic) NSString *cacheDirectory;
@property (strong,nonatomic) NSString *databaseFilename;

@property (strong, nonatomic) FMDatabase *database;

@end

@implementation DBManager

+ (id)getManager{
    
    static dispatch_once_t oneTime;
    
    __strong static id _manager = nil;
    
    dispatch_once(&oneTime, ^{
        _manager = [[self alloc] init];
    });
    
    return _manager;
}

-(id) init{
    self = [super init];
    if (self) {
        NSString *libraryDirectory = [self LibraryDirectory];
        self.cacheDirectory = [libraryDirectory stringByAppendingPathComponent:@"/Database"];
        self.databaseFilename = DATABASE_FILE_NAME;
        if ([self createDirectory:@"/Database" atFilePath:libraryDirectory]) {
            NSLog(@"/Library/Database created succeed!");
        }
        if ([self copyDatabaseFileFromTempDirectyIfExists]) {
            NSLog(@"sqlite file copy succeed!");
        }
        [self copyDatabaseIntoDocumentDirectory];
        
        NSString *databasePath = [self.cacheDirectory stringByAppendingPathComponent:self.databaseFilename];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:databasePath]) {
            self.database = [FMDatabase databaseWithPath:databasePath];
        }
    }
    
    queue = dispatch_queue_create([@"sqlite_database_queue" UTF8String], NULL);
    
    return self;
}

-(NSString *)LibraryDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);

    return [paths objectAtIndex:0];
}

-(BOOL)createDirectory:(NSString *)folder atFilePath:(NSString *)filePath{
    NSString *filePathAndDirectory = [filePath stringByAppendingString:folder];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:filePathAndDirectory]) {
        return NO;
    }
    
    NSError *error;
    if (![fileManager createDirectoryAtPath:filePathAndDirectory
        withIntermediateDirectories:NO
        attributes:nil
        error:&error]) {
        return NO;
    }
    return YES;
}

-(BOOL)copyDatabaseFileFromTempDirectyIfExists {
    NSString *sourcePath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.databaseFilename];
    NSString *destinationPath = [self.cacheDirectory stringByAppendingPathComponent:self.databaseFilename];
    NSFileManager *fileManger = [NSFileManager defaultManager];
    if ([fileManger fileExistsAtPath:sourcePath]) {
        NSError *error;
        [fileManger copyItemAtPath:sourcePath toPath:destinationPath error:&error];
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        return YES;
    }
    return NO;
}

-(void)copyDatabaseIntoDocumentDirectory{
    NSString *destinationPath = [self.cacheDirectory stringByAppendingPathComponent:self.databaseFilename];
    NSLog(@"Cache database location:%@", destinationPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:destinationPath]) {
        NSError *errorDelete;
        [fileManager removeItemAtPath:destinationPath error:&errorDelete];
        if (errorDelete != nil) {
            NSLog(@"%@",[errorDelete localizedDescription]);
        }
    }
    
    NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename];
    
    NSError *error;
    
    [fileManager copyItemAtPath:sourcePath toPath:destinationPath error:&error];
    if (error != nil) {
        NSLog(@"%@",[error localizedDescription]);
    }
}

-(void)start {
    NSLog(@"start the sqlite manager");
    if (![self.database open]) {
        NSLog(@"failed to open the sqlite");
        return;
    }
    
    [self.database setKey:DATABASE_KEY];

}

-(void)resume{
    NSLog(@"restart sqlite db");
    
    [self start];
}

-(void)pause{
    NSLog(@"pause database");
    
    [self stop];
}

-(void)stop{
    NSLog(@"stop sqlite db manager");
    if (![self.database close]) {
        NSLog(@"failed to close sqlite !");
    }
}

-(void)inDatabase:(void (^)(FMDatabase *db)) block{
    dispatch_sync(queue, ^{
        
        FMDatabase *db = self.database;
        
        block(db);
        
        if ([db hasOpenResultSets]) {
            NSLog(@"Warning: there is at least one open result set around after performing [DBManager inDatabase]");
        }
        
    });
}

-(void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block{
    dispatch_sync(queue, ^{
        BOOL shouldRollback = NO;
        
        if (useDeferred) {
            [self.database beginDeferredTransaction];
        } else {
            [self.database beginTransaction];
        }
        
        block(self.database, &shouldRollback);
        
        if (shouldRollback) {
            [self.database rollback];
        } else {
            [self.database commit];
        }
        
    });
}

-(void)inDeferredTransaction:(void (^)(FMDatabase *db,BOOL *rollback))block{
    [self beginTransaction:YES withBlock:block];
}

-(void)inTransaction:(void (^)(FMDatabase *db,BOOL *rollback))block{
    [self beginTransaction:NO withBlock:block];
}

-(NSMutableArray *)executeQuery:(NSString *)sql{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    FMResultSet *resultSet = [self.database executeQuery:sql];
    while ([resultSet next]) {
        NSMutableDictionary *record = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        for (int i = 0; i < [resultSet columnCount]; i++) {
            NSString *key = [resultSet columnNameForIndex:i];
            NSString *value = [resultSet stringForColumn:key];
            if (!value) {
                value = @"";
            }
            [record setObject:value forKey:key];
        }
        [results addObject:record];
    }
    [resultSet close];
    return results;
}

@end
