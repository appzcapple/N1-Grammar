//
//  AppzcJpGrammar.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/24.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMResultSet.h"

@interface AppzcJpGrammar : NSObject

+(id)getGrammarModel;

@property (strong,nonatomic) NSString *identity;
@property (strong,nonatomic) NSString *grammarStr;
@property (strong,nonatomic) NSString *translate;
@property (strong,nonatomic) NSString *usage;
@property (strong,nonatomic) NSString *unit;
@property (strong,nonatomic) NSString *type;


-(AppzcJpGrammar *)setInfoWithFMResultSet:(FMResultSet *)rs;

@end
