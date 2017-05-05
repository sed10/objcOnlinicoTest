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

@interface TaskDetailViewController : UIViewController <UITextFieldDelegate>

- (void)configureViewForTask:(TodoTask *)task withSaveCallback:(void(^)())callback;

@end

