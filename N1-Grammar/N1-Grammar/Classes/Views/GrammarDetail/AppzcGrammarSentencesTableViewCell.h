//
//  AppzcCrammarTpyeTableViewCell.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppzcJpGrammarSentence.h"

@interface AppzcGrammarSentencesTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *sentencelbl;
@property (weak, nonatomic) IBOutlet UILabel *translatelbl;

-(void)configCellInfo:(AppzcJpGrammarSentence *)sentence;

@end
