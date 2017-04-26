//
//  FeedTableViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/26/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "FeedTableViewController.h"
#import "XmlParser.h"
#import "Article.h"

@interface FeedTableViewController ()
@property (nonatomic, strong) NSMutableArray *feedArray;
@end

@implementation FeedTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.feedArray = [[NSMutableArray alloc] init];
    XmlParser *parser = [[XmlParser alloc] initWithArray:self.feedArray];
    [parser parseXMLFile];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.feedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"feedCell" forIndexPath:indexPath];
    
    Article *article = self.feedArray[indexPath.row];
    cell.textLabel.text = article.title;
    
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
