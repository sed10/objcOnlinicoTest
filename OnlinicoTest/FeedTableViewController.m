//
//  FeedTableViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/26/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "FeedTableViewController.h"
#import "FeedTableViewCell.h"
#import "Article.h"
#import "ArticleViewController.h"
#import "XmlParser.h"

@interface FeedTableViewController ()
@property (nonatomic, strong) NSMutableArray *feedArray;
@property (nonatomic, strong) XmlParser *parser;
@end

@implementation FeedTableViewController

#pragma mark - Lazy instantiation

- (XmlParser *)parser {
    if (!_parser) _parser = [[XmlParser alloc] init];
    //_parser.delegate = self;
    return _parser;
}

- (NSMutableArray *)feedArray {
    if (!_feedArray) _feedArray = [[NSMutableArray alloc] init];
    return _feedArray;
}

#pragma mark - Update articles list

- (IBAction)refresh:(UIRefreshControl *)sender {
    [self searchForArticles];
}

// CHECK THIS CODE!!!
- (void)searchForArticles {
    self.parser = [self.parser newer];
    
    XmlParser *parser = self.parser;
    FeedTableViewController * __weak weakSelf = self;
    [parser fetchArticlesWithHandler:^(NSArray *articles) {
        if (articles != nil && articles.count && parser == weakSelf.parser) {
            [weakSelf.feedArray insertObject:articles atIndex:0];
            [weakSelf.tableView insertSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        }
        [weakSelf.refreshControl endRefreshing];
    }];
}

//#pragma mark - XmlParserDelegate
//
//- (void)xmlParserDidFinishParsingWithResults: (NSArray *)results {
//    self.feedArray = results;
//    [self.tableView reloadData];
//}

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // load articles
    [self searchForArticles];
    
    // automatic row height
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.feedArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Article *article = self.feedArray[indexPath.section][indexPath.row];

    NSString *cellIdentifier = article.imagesUrls ? @"feedCellWithImage" : @"feedCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[FeedTableViewCell class]]) {
        FeedTableViewCell *feedCell = (FeedTableViewCell *)cell;
        [feedCell setNewArticle:article];
    }
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    // CHECK THIS CODE!!!
    if ([segue.identifier hasPrefix:@"showArticle"]) {
        if ([segue.destinationViewController isKindOfClass:[ArticleViewController class]]) {
            if ([sender isKindOfClass:[FeedTableViewCell class]]) {
                NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
                ArticleViewController *articleVC = (ArticleViewController *)segue.destinationViewController;
                Article *selectedArticle = self.feedArray[indexPath.section][indexPath.row];
                [articleVC setNewArticle:selectedArticle];
            }
        }
    }
}

@end
