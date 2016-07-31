//
//  AppzcGrammarTypesViewController.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppzcJpGrammar.h"

@protocol AppzcGrammarDetailDelegate <NSObject>

-(void)goNextGrammar:(NSInteger) currentIndex grammarVC:(UIViewController *)grammarVC;

-(void)goLastGrammar:(NSInteger) currentIndex grammarVC:(UIViewController *)grammarVC;

-(void)closeGrammar:(UIViewController *)grammarVC;

@end

@interface AppzcGrammarInfoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *grammarsTableView;

@property (weak, nonatomic) IBOutlet UILabel *grammarNamelbl;
@property (weak, nonatomic) IBOutlet UILabel *usagelbl;
@property (weak, nonatomic) IBOutlet UILabel *translatelbl;
@property (weak, nonatomic) IBOutlet UIButton *lastOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *bookmarkBtn;


@property (strong, nonatomic) AppzcJpGrammar *grammarSource;

@property (nonatomic) NSInteger grammarIndex;
@property (nonatomic) NSInteger maxIndex;

@property (nonatomic, strong) NSString *grammarType;
@property (nonatomic, strong) NSString *grammarUnit;

@property (nonatomic, weak) id<AppzcGrammarDetailDelegate> delegate;

-(void)dismissWithAnimation;

-(void)dismiss;

@end
