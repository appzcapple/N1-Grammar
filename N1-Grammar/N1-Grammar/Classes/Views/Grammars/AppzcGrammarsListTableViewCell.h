//
//  AppzcCrammarTpyeTableViewCell.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppzcJpGrammar.h"

@interface AppzcGrammarsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *grammarNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *usagelbl;
@property (weak, nonatomic) IBOutlet UILabel *translatelbl;

-(void)configCellInfo:(AppzcJpGrammar *)grammar;

@end
