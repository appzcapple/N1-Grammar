//
//  AppzcGrammarTypesViewController.m
//  N1-Grammar
//
//  Created by appzcapple on 2016/07/23.
//  Copyright © 2016年 com.zc.EducationApps. All rights reserved.
//

#import "AppzcGrammarInfoViewController.h"
#import "AppzcGrammarInfoViewControllerService.h"
#import "AppzcGrammarSentencesTableViewCell.h"

#import "AppzcJpGrammar.h"
#import "AppzcJpGrammarSentence.h"
#import "DBManager.h"

@interface AppzcGrammarInfoViewController ()

@property (nonatomic,strong)AppzcGrammarInfoViewControllerService *service;
@property (nonatomic) NSMutableArray *dataSourceList;
@property (nonatomic) BOOL isSearch;

@end

@implementation AppzcGrammarInfoViewController

@synthesize grammarSource;
@synthesize grammarsTableView;
@synthesize grammarNamelbl;
@synthesize usagelbl;
@synthesize translatelbl;
@synthesize grammarType;
@synthesize grammarUnit;
@synthesize delegate;
@synthesize lastOneBtn;
@synthesize nextOneBtn;
@synthesize bookmarkBtn;

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.service = [[AppzcGrammarInfoViewControllerService alloc] initWithViewController:self];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // init table view
    self.grammarsTableView.dataSource = self;
    self.grammarsTableView.delegate = self;
    
    if (self.grammarSource) {
        [self.grammarNamelbl setText:self.grammarSource.grammarStr];
        [self.translatelbl setText:self.grammarSource.translate];
        [self.usagelbl setText:grammarSource.usage];
    }
    
    if (self.grammarIndex == 0) {
        [self.lastOneBtn setHidden:YES];
    }
    if (self.maxIndex == self.grammarIndex){
        [self.nextOneBtn setHidden:YES];
    }
    
    if ([self.service isMarked:self.grammarSource.identity]) {
        [self.bookmarkBtn setTitle:@"取消标记⭐️" forState:UIControlStateNormal];
    }
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.dataSourceList = [self.service updateSourceList:self.grammarSource.identity];

    [self reloadSourceDate];
    
}

-(void) reloadSourceDate{
    
    [self.grammarsTableView reloadData];

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
    return self.dataSourceList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppzcJpGrammarSentence *sentence = [self.dataSourceList objectAtIndex:indexPath.row];
    AppzcGrammarSentencesTableViewCell *tableCell = [tableView dequeueReusableCellWithIdentifier:@"AppzcGrammarSentencesTableViewCell"];
    [tableCell configCellInfo:sentence];
    return tableCell;
}

#pragma mark - View button Touch event
-(IBAction)touchUpInsideLastOneBtn:(id)sender{
    [self.delegate goLastGrammar:self.grammarIndex grammarVC:self];
}

-(IBAction)touchUpInsideNextOneBtn:(id)sender{
    [self.delegate goNextGrammar:self.grammarIndex grammarVC:self];
}

-(IBAction)touchUpInsideCloseBtn:(id)sender{
    [self.delegate closeGrammar:self];
}

- (IBAction)touchUpInsideBookMark:(id)sender {
    if ([self.service isMarked:self.grammarSource.identity]) {
        [self.service removeFromMark:self.grammarSource.identity];
        [self.bookmarkBtn setTitle:@"标记生词" forState:UIControlStateNormal];
    } else {
        [self.service addToMark:self.grammarSource.identity];
        [self.bookmarkBtn setTitle:@"取消标记⭐️" forState:UIControlStateNormal];
    }
}

-(void)dismissWithAnimation{
    CGSize scSize = [UIScreen mainScreen].bounds.size;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view setFrame:CGRectMake(scSize.width, 0, scSize.width, scSize.height)];
    } completion:^(BOOL finished) {
        [self dismiss];
    }];
}

-(void)dismiss{
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

@end
