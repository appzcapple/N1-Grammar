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

#define R_DATABASE_NAME @"Grammar.sqlite"
#define R_W_DATABASE_NAME @"Cache.sqlite"
#define DATABASE_KEY @"zc2016"

@interface DBManager (){
    dispatch_queue_t queue;
}

@property (strong,nonatomic) NSString *cacheDirectory;
@property (strong,nonatomic) NSString *rDatabaseFilename;
@property (strong,nonatomic) NSString *rwDatabaseFilename;

@property (strong, nonatomic) FMDatabase *rdatabase;
@property (strong, nonatomic) FMDatabase *rwDatabase;

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
        self.rDatabaseFilename = R_DATABASE_NAME;
        self.rwDatabaseFilename = R_W_DATABASE_NAME;
        if ([self createDirectory:@"/Database" atFilePath:libraryDirectory]) {
            NSLog(@"/Library/Database created succeed!");
        }
        if ([self copyDatabaseFileFromTempDirectyIfExists]) {
            NSLog(@"sqlite file copy succeed!");
        }
        [self copyDatabaseIntoDocumentDirectory];
        
        NSString *rDatabasePath = [self.cacheDirectory stringByAppendingPathComponent:self.rDatabaseFilename];
        NSString *rwDatabasePath = [self.cacheDirectory stringByAppendingPathComponent:self.rwDatabaseFilename];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:rDatabasePath]) {
            self.rdatabase = [FMDatabase databaseWithPath:rDatabasePath];
        }
        if ([fileManager fileExistsAtPath:rwDatabasePath]) {
            self.rwDatabase = [FMDatabase databaseWithPath:rwDatabasePath];
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
    NSString *sourcePath = [NSTemporaryDirectory() stringByAppendingPathComponent:self.rDatabaseFilename];
    NSString *destinationPath = [self.cacheDirectory stringByAppendingPathComponent:self.rDatabaseFilename];
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
    NSString *destinationPathRDB = [self.cacheDirectory stringByAppendingPathComponent:self.rDatabaseFilename];
    NSLog(@"Cache database location:%@", destinationPathRDB);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:destinationPathRDB]) {
        NSError *errorDelete;
        [fileManager removeItemAtPath:destinationPathRDB error:&errorDelete];
        if (errorDelete != nil) {
            NSLog(@"%@",[errorDelete localizedDescription]);
        }
    }
    
    NSString *rSourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.rDatabaseFilename];
    
    NSError *error;
    
    [fileManager copyItemAtPath:rSourcePath toPath:destinationPathRDB error:&error];
    if (error != nil) {
        NSLog(@"%@",[error localizedDescription]);
    }
    
    NSString *destinationPathRWDB = [self.cacheDirectory stringByAppendingPathComponent:self.rwDatabaseFilename];
    if (![fileManager fileExistsAtPath:destinationPathRWDB]) {
        NSString *rwSourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.rwDatabaseFilename];
        
        NSError *error2;
        
        [fileManager copyItemAtPath:rwSourcePath toPath:destinationPathRWDB error:&error2];
        if (error2 != nil) {
            NSLog(@"%@",[error2 localizedDescription]);
        }
    }
    
}

-(void)start :(NSString *)databaseName {
    NSLog(@"start the sqlite manager");
    if ([databaseName isEqualToString:self.rwDatabaseFilename]) {
        if (![self.rwDatabase open]) {
            NSLog(@"failed to open the sqlite");
            return;
        }
    } else {
        if (![self.rdatabase open]) {
            NSLog(@"failed to open the sqlite");
            return;
        }
    }
    [self.rdatabase setKey:DATABASE_KEY];

}

//-(void)resume{
//    NSLog(@"restart sqlite db");
//    
//    [self start];
//}
//
//-(void)pause{
//    NSLog(@"pause database");
//    
//    [self stop];
//}

-(void)stop :(NSString *)databaseName;{
    NSLog(@"stop sqlite db manager");
    if ([databaseName isEqualToString:self.rwDatabaseFilename]) {
        if (![self.rwDatabase close]) {
            NSLog(@"failed to close sqlite !");
        }
    } else {
        if (![self.rdatabase close]) {
            NSLog(@"failed to close sqlite !");
        }
    }
}

-(void)inDatabase:(void (^)(FMDatabase *db)) block databaseName:(NSString *)databaseName{
    dispatch_sync(queue, ^{
        
        FMDatabase *db = nil;
        if ([databaseName isEqualToString:self.rwDatabaseFilename]) {
            db = self.rwDatabase;
        }else {
            db = self.rdatabase;
        }
        
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
            [self.rwDatabase beginDeferredTransaction];
        } else {
            [self.rwDatabase beginTransaction];
        }
        
        block(self.rwDatabase, &shouldRollback);
        
        if (shouldRollback) {
            [self.rwDatabase rollback];
        } else {
            [self.rwDatabase commit];
        }
        
    });
}

-(void)inDeferredTransaction:(void (^)(FMDatabase *db,BOOL *rollback))block{
    [self beginTransaction:YES withBlock:block];
}

-(void)inTransaction:(void (^)(FMDatabase *db,BOOL *rollback))block{
    [self beginTransaction:NO withBlock:block];
}

-(NSMutableArray *)executeQuery:(NSString *)sql databaseName:(NSString *)databaseName{
    NSMutableArray *results = [[NSMutableArray alloc] init];
    
    FMResultSet *resultSet = nil;
    FMDatabase *db = nil;
    if ([databaseName isEqualToString:self.rwDatabaseFilename]) {
        db = self.rwDatabase;
    }else {
        db = self.rdatabase;
    }

    resultSet = [db executeQuery:sql];
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
