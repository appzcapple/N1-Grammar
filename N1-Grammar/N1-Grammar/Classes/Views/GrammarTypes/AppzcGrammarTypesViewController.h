//
//  AppzcGrammarTypesViewController.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppzcGrammarTypesViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *grammarTpyesTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *tpyesSerachbar;

@end
