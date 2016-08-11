//
//  DBManager.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/11.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "FMDatabase.h"

@interface DBManager : NSObject

+(id)getManager ;

-(NSMutableArray *)getBookmarkedIds;

-(void)addMarkedId:(NSString *)gid;

-(void)removeMarkedId:(NSString *)gid;

-(void)start :(NSString *)databaseName;

-(void)stop :(NSString *)databaseName;

-(void)inDatabase:(void (^)(FMDatabase *db)) block databaseName: (NSString *) databaseName;

-(void)inTransaction:(void (^)(FMDatabase *db,BOOL *rollback))block;

-(NSMutableArray *)executeQuery:(NSString *)sql databaseName: (NSString *) databaseName;

-(void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block;

@end
