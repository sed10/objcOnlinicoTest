//
//  CoreDataUtils.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/5/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "CoreDataUtils.h"
#import "AppDelegate.h"

static NSManagedObjectContext *__managedObjectContext;

@implementation CoreDataUtils

+ (NSManagedObjectContext *) managedObjectContext {
    if (__managedObjectContext == nil) {
        __managedObjectContext = ((AppDelegate *)UIApplication.sharedApplication.delegate).persistentContainer.viewContext;
    }
    return __managedObjectContext;
}

+ (void) saveContext {
    NSManagedObjectContext *context = [CoreDataUtils managedObjectContext];
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end
