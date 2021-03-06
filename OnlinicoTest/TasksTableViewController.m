//
//  TasksTableViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/28/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "TasksTableViewController.h"
#import "TaskDetailViewController.h"
#import "FormatUtilities.h"
#import "CoreDataUtils.h"

@interface TasksTableViewController ()
@end

@implementation TasksTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    
    // run once to save it then comment
//    TodoTask *task1 = [NSEntityDescription insertNewObjectForEntityForName:@"TodoTask" inManagedObjectContext:self.managedObjectContext];
//    task1.title = @"TODO Task 1";
//    task1.created = [NSDate date];
//    task1.text = @"TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 ";
//
//    TodoTask *task2 = [NSEntityDescription insertNewObjectForEntityForName:@"TodoTask" inManagedObjectContext:self.managedObjectContext];
//    task2.title = @"TODO Task 2";
//    task2.created = [NSDate date];
//    task2.text = @"TODO2 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 TODO1 ";
//
//    [CoreDataUtils saveContext];
    
}

- (IBAction)pressedAddButton:(UIBarButtonItem *)sender {
    [self performSegueWithIdentifier:@"showTaskDetail" sender:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"taskCell" forIndexPath:indexPath];
    
    TodoTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self configureCell:cell withTask:task];
    
    UISwipeGestureRecognizer* rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [cell addGestureRecognizer:rightSwipe];
    
    return cell;
}

- (void)handleSwipe:(UISwipeGestureRecognizer *) sender {
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        CGPoint point = [sender locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
        
        TodoTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
        // should use some enum or something
        task.status = TaskStatusCompleted;
        [CoreDataUtils saveContext:[self.fetchedResultsController managedObjectContext]];
    }
}

- (void)configureCell:(UITableViewCell *)cell withTask:(TodoTask *)task {
    cell.textLabel.text = task.title;
    cell.detailTextLabel.text = [FormatUtilities stringFromDate:task.created];
    
    if (task.status == 1) {
        NSDictionary* attributes = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]};
        NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:task.title attributes:attributes];
        cell.textLabel.attributedText = attributedString;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        if (![context save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, error.userInfo);
            abort();
        }
    }
    
    // disable editing mode after deleting a list
    [self setEditing:NO animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TodoTask *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self performSegueWithIdentifier:@"showTaskDetail" sender:task];
}

#pragma mark - Fetched results controller

- (NSFetchedResultsController<TodoTask *> *)fetchedResultsController {
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    //NSFetchRequest<Event *> *fetchRequest = Event.fetchRequest;
    NSFetchRequest<TodoTask *> *fetchRequest = TodoTask.fetchRequest;
    
    // Set the batch size to a suitable number.
    [fetchRequest setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"created" ascending:NO];
    
    [fetchRequest setSortDescriptors:@[sortDescriptor]];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController<TodoTask *> *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[CoreDataUtils managedObjectContext] sectionNameKeyPath:nil cacheName:@"TodoTasks"];
    aFetchedResultsController.delegate = self;
    
    NSError *error = nil;
    if (![aFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
    
    _fetchedResultsController = aFetchedResultsController;
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        default:
            return;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withTask:anObject];
            break;
            
        case NSFetchedResultsChangeMove:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] withTask:anObject];
            [tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];

    if ([[segue identifier] isEqualToString:@"showTaskDetail"]) {
        TaskDetailViewController *controller = (TaskDetailViewController *)[segue destinationViewController];
        
        // callback is not needed here but I don't want to delete it
        [controller configureViewForTask:sender withSaveCallback:^{
            NSLog(@"Task is saved");
        }];
    }
}

@end
