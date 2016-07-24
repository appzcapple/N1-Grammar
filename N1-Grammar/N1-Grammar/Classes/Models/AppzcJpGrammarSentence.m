//
//  AppzcJpGrammarSentence.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/25.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcJpGrammarSentence.h"

@implementation AppzcJpGrammarSentence

@synthesize identity;
@synthesize grammarId;
@synthesize sentence;
@synthesize translate;

-(AppzcJpGrammarSentence *)setInfoWithFMResultSet:(FMResultSet *)rs{
    
    self.identity = [rs stringForColumn:@"SENTENCES_ID"];
    self.sentence = [rs stringForColumn:@"SENTENCE"];
    self.translate = [rs stringForColumn:@"TRANSLATE"];
    self.grammarId = [rs stringForColumn:@"GRAMMAR_ID"];
    
    return self;
}

@end
