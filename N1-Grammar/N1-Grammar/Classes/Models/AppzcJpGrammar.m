//
//  AppzcJpGrammar.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/24.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcJpGrammar.h"


@implementation AppzcJpGrammar

@synthesize identity;
@synthesize grammarStr;
@synthesize translate;
@synthesize usage;
@synthesize unit;
@synthesize type;

+(id)getGrammarModel{
    
    return [[self alloc] init];

}

-(AppzcJpGrammar *)setInfoWithFMResultSet:(FMResultSet *)rs{
    //CREATE TABLE "GRAMMARS" ("ID" TEXT PRIMARY KEY  DEFAULT (null) ,"GRAMMAR" TEXT NOT NULL ,"TRANSLATE" TEXT,"USAGE" TEXT,"UNIT_ID" TEXT,"TYPE" TEXT DEFAULT (null) )
    self.identity = [rs stringForColumn:@"ID"];
    self.grammarStr = [rs stringForColumn:@"GRAMMAR"];
    self.translate = [rs stringForColumn:@"TRANSLATE"];
    self.usage = [rs stringForColumn:@"USAGE"];
    self.unit = [rs stringForColumn:@"UNIT_ID"];
    self.type = [rs stringForColumn:@"TYPE"];
    
    return self;
}

@end
