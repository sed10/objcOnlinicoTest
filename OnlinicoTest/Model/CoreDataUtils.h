//
//  CoreDataUtils.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/5/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface CoreDataUtils : NSObject

+ (NSManagedObjectContext *) managedObjectContext;

+ (void) saveContext:(NSManagedObjectContext *)context;

@end
