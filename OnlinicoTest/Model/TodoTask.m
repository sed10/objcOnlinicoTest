//
//  TodoTask.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/3/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

//#import "TodoTask.h"
#import "OnlinicoTest+CoreDataModel.h"

@implementation TodoTask

+ (NSString *)stringForStatus:(TaskStatus)status {
    NSString *result = nil;
    
    switch(status) {
        case ACTIVE_TASK:
            result = @"Active";
            break;
        case COMPLETED_TASK:
            result = @"Completed";
            break;
        case DELETED_TASK:
            result = @"Deleted";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected task status."];
    }
    
    return result;

}

- (NSString *)statusToString {
    return [TodoTask stringForStatus:self.status];
}

@end
