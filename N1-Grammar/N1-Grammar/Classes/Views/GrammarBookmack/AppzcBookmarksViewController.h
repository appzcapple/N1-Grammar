//
//  AppzcGrammarTypesViewController.h
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppzcBookmarksViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *grammarsTableView;

@property (weak, nonatomic) IBOutlet UISearchBar *grammarsSearchbar;

@property (nonatomic, strong) NSString *grammarType;
@property (nonatomic, strong) NSString *grammarUnit;

@end
