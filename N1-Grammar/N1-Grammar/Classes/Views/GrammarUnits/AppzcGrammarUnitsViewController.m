//
//  AppzcGrammarTypesViewController.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarUnitsViewController.h"
#import "AppzcGrammarUnitsViewControllerService.h"
#import "AppzcGrammarUnitTableViewCell.h"
#import "AppzcGrammarsListViewController.h"

@interface AppzcGrammarUnitsViewController ()

@property (nonatomic,strong)AppzcGrammarUnitsViewControllerService *service;
@property (nonatomic) NSMutableArray *dataSourceList;
@property (nonatomic) NSMutableArray *searchResultList;
@property (nonatomic) NSMutableArray *lastResult;
@property (nonatomic) BOOL isSearch;

@end

@implementation AppzcGrammarUnitsViewController

@synthesize grammarTpyesTableView;
@synthesize unitsSerachbar;
@synthesize grammarType;

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.service = [[AppzcGrammarUnitsViewControllerService alloc] initWithViewController:self];
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
    
    [self.unitsSerachbar setDelegate:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (self.grammarType) {
        self.dataSourceList = [self.service updateSourceList:self.grammarType];
    } else{
        self.dataSourceList = [self.service updateSourceList:@"N1"];
        self.grammarType = @"N1";
    }
    
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
    [self.unitsSerachbar resignFirstResponder];
    self.isSearch = YES;
    NSString *searchStr = self.unitsSerachbar.text;
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
    [self.unitsSerachbar setText:@""];
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
    if ([[segue identifier] isEqualToString:@"UNIT_TO_GRAMMAR"])
    {
        // Get reference to the destination view controller
        AppzcGrammarsListViewController *vc = [segue destinationViewController];
        [vc setGrammarType:self.grammarType];
        [vc setGrammarUnit:[self.lastResult objectAtIndex:self.grammarTpyesTableView.indexPathForSelectedRow.row ]];
        
        // Pass any objects to the view controller here, like...
        //[vc setMyObjectHere:object];
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
    AppzcGrammarUnitTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"AppzcGrammarUnitTableViewCell"];
    [tableCell configCellInfo:type];
    return tableCell;
}


@end
