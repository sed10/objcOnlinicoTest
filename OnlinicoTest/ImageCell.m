//
//  ImageCell.m
//  OnlinicoTest
//
//  Created by Andrij Trubchanin on 5/7/17.
//  Copyright © 2017 Andrij Trubchanin. All rights reserved.
//

#import "ImageCell.h"

@interface ImageCell ()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@end

@implementation ImageCell

- (void)configureForImage:(UIImage *)image {
    if (image != nil && image != (UIImage *)[NSNull null]) {
        [self.image setImage:image];
    }
}

@end
