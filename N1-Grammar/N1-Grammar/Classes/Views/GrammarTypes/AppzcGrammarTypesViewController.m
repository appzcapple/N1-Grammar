//
//  AppzcGrammarTypesViewController.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarTypesViewController.h"
#import "AppzcGrammarTypesViewControllerService.h"
#import "AppzcGrammarTpyeTableViewCell.h"
#import "AppzcGrammarUnitsViewController.h"

@interface AppzcGrammarTypesViewController ()

@property (nonatomic,strong)AppzcGrammarTypesViewControllerService *service;
@property (nonatomic) NSMutableArray *dataSourceList;
@property (nonatomic) NSMutableArray *searchResultList;
@property (nonatomic) NSMutableArray *lastResult;
@property (nonatomic) BOOL isSearch;

@end

@implementation AppzcGrammarTypesViewController

@synthesize grammarTpyesTableView;
@synthesize tpyesSerachbar;

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.service = [[AppzcGrammarTypesViewControllerService alloc] initWithViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    // init table view
    self.grammarTpyesTableView.dataSource = self;
    self.grammarTpyesTableView.delegate = self;
    self.searchResultList = [NSMutableArray array];
    self.lastResult = [NSMutableArray array];
    
    [self.tpyesSerachbar setDelegate:self];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.dataSourceList = [self.service updateSourceList];
    
    [self reloadSourceDate];
}

-(void) reloadSourceDate{
    if (self.isSearch) {
        self.lastResult = self.searchResultList;
    } else {
        self.lastResult = self.dataSourceList;
    }
    
    [self.grammarTpyesTableView reloadData];

}

#pragma mark - searchbar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.tpyesSerachbar resignFirstResponder];
    self.isSearch = YES;
    NSString *searchStr = self.tpyesSerachbar.text;
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchStr];
    self.searchResultList = (NSMutableArray *)[self.dataSourceList filteredArrayUsingPredicate:sPredicate];
    
    [self reloadSourceDate];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqual:@""]) {
        self.searchResultList = self.dataSourceList;
        [self reloadSourceDate];
    } else {
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS[cd] %@",searchText];
        self.searchResultList = (NSMutableArray *)[self.dataSourceList filteredArrayUsingPredicate:sPredicate];
        
        [self reloadSourceDate];
    }
    
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.isSearch = YES;
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    self.isSearch = NO;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self.tpyesSerachbar setText:@""];
    self.isSearch = NO;
    [self reloadSourceDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"TYPE_TO_UNIT"])
    {
        // Get reference to the destination view controller
        AppzcGrammarUnitsViewController *vc = (AppzcGrammarUnitsViewController *)[segue destinationViewController];
        
        NSString *selectedType = [self.lastResult objectAtIndex:self.grammarTpyesTableView.indexPathForSelectedRow.row];
        
        // Pass any objects to the view controller here, like...
        [vc setGrammarType:selectedType];
    }
}


#pragma mark - tableview delegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.lastResult.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *type = [self.lastResult objectAtIndex:indexPath.row];
    AppzcGrammarTpyeTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"AppzcGrammarTpyeTableViewCell"];
    [tableCell configCellInfo:type];
    return tableCell;
}


@end
