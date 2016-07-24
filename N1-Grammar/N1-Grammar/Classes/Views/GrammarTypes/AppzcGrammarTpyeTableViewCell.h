//
//  AppzcCrammarTpyeTableViewCell.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppzcGrammarTpyeTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *typeNamelbl;

-(void)configCellInfo:(NSString *)type;

@end
