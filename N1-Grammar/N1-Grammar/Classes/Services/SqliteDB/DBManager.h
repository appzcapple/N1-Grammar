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

-(void)start;

-(void)stop;

-(void)inDatabase:(void (^)(FMDatabase *db)) block;

-(void)inTransaction:(void (^)(FMDatabase *db,BOOL *rollback))block;

-(NSMutableArray *)executeQuery:(NSString *)sql;

-(void)beginTransaction:(BOOL)useDeferred withBlock:(void (^)(FMDatabase *db, BOOL *rollback))block;

@end
