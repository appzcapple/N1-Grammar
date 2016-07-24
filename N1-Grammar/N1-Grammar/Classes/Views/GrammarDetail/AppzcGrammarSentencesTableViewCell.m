//
//  AppzcCrammarTpyeTableViewCell.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarSentencesTableViewCell.h"

@implementation AppzcGrammarSentencesTableViewCell

@synthesize sentencelbl;
@synthesize translatelbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellInfo:(AppzcJpGrammarSentence *)sentence{
    [self.sentencelbl setText:sentence.sentence];
    [self.translatelbl setText:sentence.translate];
}

@end
