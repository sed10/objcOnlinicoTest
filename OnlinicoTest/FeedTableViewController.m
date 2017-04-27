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

@interface FeedTableViewController ()
@property (nonatomic, strong) NSArray *feedArray;
@property (nonatomic, strong) XmlParser *parser;
@end

@implementation FeedTableViewController

#pragma mark - XmlParserDelegate

- (void)xmlParserDidFinishParsingWithResults: (NSArray *)results {
    self.feedArray = results;
    [self.tableView reloadData];
}

#pragma mark - VC Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // init parser
    self.parser = [[XmlParser alloc] init];
    self.parser.delegate = self;
    [self.parser parseXMLFile];
    
    // automatic row height
    self.tableView.estimatedRowHeight = self.tableView.rowHeight;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    Article *article = self.feedArray[indexPath.row];

    NSString *cellIdentifier = article.imagesUrls ? @"feedCellWithImage" : @"feedCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if ([cell isKindOfClass:[FeedTableViewCell class]]) {
        FeedTableViewCell *feedCell = (FeedTableViewCell *)cell;
        feedCell.article = article;
        [feedCell updateUI];
    }
    
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
