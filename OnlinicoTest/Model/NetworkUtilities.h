//
//  NetworkUtilities.h
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 4/27/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkUtilities : NSObject
+ (void)downloadDataFromURL:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;
@end
