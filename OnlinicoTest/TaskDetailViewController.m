//
//  TaskDetailViewController.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/3/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "FormatUtilities.h"
#import "CoreDataUtils.h"

@interface TaskDetailViewController ()
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *createdDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (nonatomic, strong) void (^saveCallback)();
@property (nonatomic) BOOL editingAllowed;

@property (nonatomic, strong) TodoTask *task;
@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.titleTextField setDelegate:self];
    
    // remove the keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
    [self.view addGestureRecognizer:tap];
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.task != nil) {
        self.titleTextField.text = self.task.title;
        self.descriptionTextView.text = self.task.text;
        self.createdDateLabel.text = [FormatUtilities stringFromDate:self.task.created];
        self.statusLabel.text = [self statusToString:self.task.status];
        
        self.editingAllowed = NO;
    } else {
        self.titleTextField.text = nil;
        self.descriptionTextView.text = nil;
        self.createdDateLabel.text = [FormatUtilities stringFromDate:[NSDate date]];
        self.statusLabel.text = [self statusToString:0];
        
        self.editingAllowed = YES;
    }
    
    [self updateUI];
    [self.titleTextField becomeFirstResponder];
}

- (IBAction)pressedCancel:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)pressedEdit:(UIButton *)sender {
    if (self.editingAllowed) {
        // create new task
        if (self.task == nil) {
            self.task = [NSEntityDescription insertNewObjectForEntityForName:@"TodoTask" inManagedObjectContext:[CoreDataUtils managedObjectContext]];
            
            // move it outside the brackets if you want to change the task time while editing
            self.task.created = [NSDate date];
        }
        self.task.title = self.titleTextField.text;
        self.task.text = self.descriptionTextView.text;
        self.task.status = 0;
        [CoreDataUtils saveContext];
        

        if (self.saveCallback != nil) {
            self.saveCallback();
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        self.editingAllowed = YES;
    }
    [self updateUI];
}

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

- (void)updateUI {
    self.titleTextField.enabled = self.editingAllowed;
    self.descriptionTextView.editable = self.editingAllowed;
    [self.editButton setTitle:(self.editingAllowed ? @"Save" : @"Edit") forState:UIControlStateNormal];
}

// actually don't need that callback
- (void)configureViewForTask:(TodoTask *)task withSaveCallback:(void(^)())callback {
    self.task = task;
    self.saveCallback = callback;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
