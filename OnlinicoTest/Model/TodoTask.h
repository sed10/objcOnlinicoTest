//
//  TodoTask.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/3/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef enum {
    TaskStatusActive,
    TaskStatusCompleted,
    TaskStatusDeleted
} TaskStatus;

@interface TodoTask : NSManagedObject
+ (NSString *)stringForStatus:(TaskStatus)status;
- (NSString *)statusToString;
@end
