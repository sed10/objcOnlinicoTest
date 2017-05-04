//
//  TaskDetailViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/3/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "FormatUtilities.h"

@interface TaskDetailViewController ()

@end

@implementation TaskDetailViewController

- (NSString *)statusToString:(TaskStatus)status {
    NSString *result = nil;
    
    switch(status) {
        case active:
            result = @"Active";
            break;
        case completed:
            result = @"Completed";
            break;
        case deleted:
            result = @"Deleted";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected task status."];
    }
    
    return result;
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
        self.titleTextField.text = self.detailItem.title;
        self.descriptionTextView.text = self.detailItem.text;
        self.createdDateLabel.text = [FormatUtilities stringFromDate:self.detailItem.created];
        self.statusLabel.text = [self statusToString:self.detailItem.status];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Managing the detail item

- (void)setDetailItem:(TodoTask *)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}


@end
