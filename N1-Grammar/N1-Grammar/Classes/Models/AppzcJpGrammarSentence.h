//
//  AppzcJpGrammarSentence.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/25.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface AppzcJpGrammarSentence : NSObject

@property (strong,nonatomic) NSString *identity;
@property (strong,nonatomic) NSString *grammarId;
@property (strong,nonatomic) NSString *sentence;
@property (strong,nonatomic) NSString *translate;


-(AppzcJpGrammarSentence *)setInfoWithFMResultSet:(FMResultSet *)rs;

@end
