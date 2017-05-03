//
//  TasksTableViewController.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/28/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "OnlinicoTest+CoreDataModel.h"

@interface TasksTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController<TodoTask *> *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@end
