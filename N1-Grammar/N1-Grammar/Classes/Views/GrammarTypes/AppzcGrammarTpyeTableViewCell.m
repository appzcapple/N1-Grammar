//
//  AppzcCrammarTpyeTableViewCell.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarTpyeTableViewCell.h"

@implementation AppzcGrammarTpyeTableViewCell

@synthesize typeNamelbl;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configCellInfo:(NSString *)type{
    [self.typeNamelbl setText:type];
}

@end
