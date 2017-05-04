//
//  TaskDetailViewController.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/3/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OnlinicoTest+CoreDataModel.h"

typedef enum {
    active,
    completed,
    deleted
} TaskStatus;

@interface TaskDetailViewController : UIViewController

@property (strong, nonatomic) TodoTask *detailItem;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

