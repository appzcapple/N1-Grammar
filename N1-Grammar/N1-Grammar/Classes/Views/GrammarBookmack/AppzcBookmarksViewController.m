//
//  AppzcGrammarTypesViewController.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcBookmarksViewController.h"
#import "AppzcBookmarksViewControllerService.h"
#import "AppzcGrammarsListTableViewCell.h"
#import "AppzcGrammarInfoViewController.h"
#import "AppzcJpGrammar.h"

@interface AppzcBookmarksViewController ()<AppzcGrammarDetailDelegate>{
    dispatch_queue_t queue;
}

@property (nonatomic,strong)AppzcBookmarksViewControllerService *service;
@property (nonatomic) NSMutableArray *dataSourceList;
@property (nonatomic) NSMutableArray *searchResultList;
@property (nonatomic) NSMutableArray *lastResult;
@property (nonatomic) BOOL isSearch;

@end

@implementation AppzcBookmarksViewController

@synthesize grammarsTableView;
@synthesize grammarsSearchbar;
@synthesize grammarType;
@synthesize grammarUnit;

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.service = [[AppzcBookmarksViewControllerService alloc] initWithViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    // init table view
    self.grammarsTableView.dataSource = self;
    self.grammarsTableView.delegate = self;
    self.searchResultList = [NSMutableArray array];
    self.lastResult = [NSMutableArray array];
    
    [self.grammarsSearchbar setDelegate:self];
    
    queue = dispatch_queue_create([@"goto_view" UTF8String], NULL);
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
    
    [self.grammarsTableView reloadData];

}

#pragma mark - searchbar delegate
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.grammarsSearchbar resignFirstResponder];
    self.isSearch = YES;
    NSString *searchStr = self.grammarsSearchbar.text;
    
//    grammarStr;
//    translate;
    NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"grammarStr CONTAINS[cd] %@ OR translate CONTAINS[cd] %@",searchStr,searchStr];
    self.searchResultList = (NSMutableArray *)[self.dataSourceList filteredArrayUsingPredicate:sPredicate];
    
    [self reloadSourceDate];
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if ([searchText isEqual:@""]) {
        self.searchResultList = self.dataSourceList;
        [self reloadSourceDate];
    } else {
        NSPredicate *sPredicate = [NSPredicate predicateWithFormat:@"grammarStr CONTAINS[cd] %@ OR translate CONTAINS[cd] %@",searchText,searchText];
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
    [self.grammarsSearchbar setText:@""];
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
    if ([[segue identifier] isEqualToString:@"YOUR_SEGUE_NAME_HERE"])
    {
        // Get reference to the destination view controller
//        UIViewController *vc = [segue destinationViewController];
        
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
    AppzcJpGrammar *grammar = [self.lastResult objectAtIndex:indexPath.row];
    AppzcGrammarsListTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"AppzcGrammarsListTableViewCell"];
    [tableCell configCellInfo:grammar];
    return tableCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *mStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AppzcGrammarInfoViewController *grammarVC = [mStoryBoard instantiateViewControllerWithIdentifier:@"AppzcGrammarInfo"];
    AppzcJpGrammar *source = [self.lastResult objectAtIndex:indexPath.row];
    [grammarVC setGrammarSource:source];
    [grammarVC setGrammarIndex:indexPath.row];
    [grammarVC setMaxIndex:[self.lastResult count] - 1];
    [grammarVC setDelegate:self];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [grammarVC.view setFrame:CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height)];
    [self.view addSubview:grammarVC.view];
    [self addChildViewController:grammarVC];
    [self.view bringSubviewToFront:grammarVC.view];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        [grammarVC.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
    } completion:nil];
}

#pragma mark - grammar detailview delegate

-(void)goLastGrammar:(NSInteger)currentIndex grammarVC:(UIViewController *)grammarVC{
    NSInteger gotoIndex = currentIndex - 1;
    AppzcJpGrammar *source = [self.lastResult objectAtIndex:gotoIndex];
    
    if (source) {
        UIStoryboard *mStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppzcGrammarInfoViewController *newGrammarVC = [mStoryBoard instantiateViewControllerWithIdentifier:@"AppzcGrammarInfo"];
        
        [newGrammarVC setGrammarSource:source];
        [newGrammarVC setGrammarIndex:gotoIndex];
        [newGrammarVC setMaxIndex:[self.lastResult count] - 1];
        [newGrammarVC setDelegate:self];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [newGrammarVC.view setFrame:CGRectMake(-1 * screenSize.width, 0, screenSize.width, screenSize.height)];
        [self.view addSubview:newGrammarVC.view];
        [self addChildViewController:newGrammarVC];
        [self.view bringSubviewToFront:newGrammarVC.view];
        
        [UIView animateWithDuration:0.3 animations:^{
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            [newGrammarVC.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
            [grammarVC.view setFrame:CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height)];
        } completion:^(BOOL finished) {
            [((AppzcGrammarInfoViewController *)grammarVC) dismiss];
        }];
    }
}

-(void)goNextGrammar:(NSInteger)currentIndex grammarVC:(UIViewController *)grammarVC{
    NSInteger gotoIndex = currentIndex + 1;
    AppzcJpGrammar *source = [self.lastResult objectAtIndex:gotoIndex];
    
    if (source) {
        UIStoryboard *mStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        AppzcGrammarInfoViewController *newGrammarVC = [mStoryBoard instantiateViewControllerWithIdentifier:@"AppzcGrammarInfo"];
        
        [newGrammarVC setGrammarSource:source];
        [newGrammarVC setGrammarIndex:gotoIndex];
        [newGrammarVC setMaxIndex:[self.lastResult count] - 1];
        [newGrammarVC setDelegate:self];
        
        CGSize screenSize = [UIScreen mainScreen].bounds.size;
        [newGrammarVC.view setFrame:CGRectMake(screenSize.width, 0, screenSize.width, screenSize.height)];
        [self.view addSubview:newGrammarVC.view];
        [self addChildViewController:newGrammarVC];
        [self.view bringSubviewToFront:newGrammarVC.view];
        
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        
        [UIView animateWithDuration:0.3 animations:^{
            [newGrammarVC.view setFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
            [grammarVC.view setFrame:CGRectMake(-1 * screenSize.width, 0, screenSize.width, screenSize.height)];
        } completion:^(BOOL finished) {
            [((AppzcGrammarInfoViewController *)grammarVC) dismiss];
        }];
        
    
        
    }
}

-(void)closeGrammar:(UIViewController *)grammarVC{
    [((AppzcGrammarInfoViewController *)grammarVC) dismissWithAnimation];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.dataSourceList = [self.service updateSourceList];
    [self reloadSourceDate];
}

@end
