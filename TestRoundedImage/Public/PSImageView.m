//
//  PSImageView.m
//  TestRoundedImage
//
//  Created by Paul Semionov on 13.11.13.
//  Copyright (c) 2013 Paul Semionov. All rights reserved.
//

#import "PSImageView.h"

@implementation PSImageView

@synthesize image = _image;
@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

@synthesize rounded = _rounded;

#pragma mark --
#pragma mark - Initializers

- (id)init {
    
    self = [super init];
    
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
    
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
    
}

#pragma mark --
#pragma mark - Setters

- (void)setImage:(UIImage *)image {
    
    if(image.size.width != image.size.height) {
        
        // Make square from center, based on image height
        
        image = [self image:image byCroppingToRectangle:CGRectMake(image.size.width / 2 - image.size.height / 2,
                                                                   image.size.height / 2 - image.size.height / 2,
                                                                   image.size.height,
                                                                   image.size.height)];
        
    }
    
    _image = image;
    
    [self setNeedsDisplay];
    
}

#pragma mark --
#pragma mark - Drawing

- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    if(_rounded) {
    
        // Begin a new image that will be the new image with the rounded corners
        UIGraphicsBeginImageContextWithOptions(_image.size, NO, _image.scale);
        
        // Add a clip before drawing anything, in the shape of an rounded rect
        CGRect frame = CGRectMake(0, 0, _image.size.width, _image.size.height);
        [[UIBezierPath bezierPathWithRoundedRect:frame cornerRadius:_image.size.height] addClip];

        // Draw your image
        [_image drawInRect:frame];
        
        // Get the image, here setting the UIImageView image
        UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
        
        // Lets forget about that we were drawing
        UIGraphicsEndImageContext();
        
        if(_borderWidth > 0 && (_borderColor && ![_borderColor isEqual:[UIColor clearColor]])) {
            
            rect.origin.x = rect.origin.x + _borderWidth;
            rect.origin.y = rect.origin.y + _borderWidth;
            rect.size.width = rect.size.width - _borderWidth * 2;
            rect.size.height = rect.size.height - _borderWidth * 2;
            
            UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:_image.size.height];
            
            [_borderColor setStroke];
            path.lineWidth = _borderWidth;
            [path stroke];
            
        }

        [roundedImage drawInRect:rect];
        
    }else{
        
        [_image drawInRect:rect];
        
    }

}

#pragma mark --
#pragma mark - UIImage helpers

- (UIImage *)image:(UIImage *)imageToCrop byCroppingToRectangle:(CGRect)aperture {
    return [self image:imageToCrop byCroppingToRectangle:aperture withOrientation:UIImageOrientationDownMirrored];
}

// Draw a full image into a crop-sized area and offset to produce a cropped, rotated image
- (UIImage *)image:(UIImage *)imageToCrop byCroppingToRectangle:(CGRect)aperture withOrientation:(UIImageOrientation)orientation {
    
    // convert y coordinate to origin bottom-left
    CGFloat orgY = aperture.origin.y + aperture.size.height - imageToCrop.size.height,
    orgX = -aperture.origin.x,
    scaleX = 1.0,
    scaleY = 1.0,
    rot = 0.0;
    CGSize size;
    
    switch (orientation) {
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            size = CGSizeMake(aperture.size.height, aperture.size.width);
            break;
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            size = aperture.size;
            break;
        default:
            assert(NO);
            return nil;
    }
    
    
    switch (orientation) {
        case UIImageOrientationRight:
            rot = 1.0 * M_PI / 2.0;
            orgY -= aperture.size.height;
            break;
        case UIImageOrientationRightMirrored:
            rot = 1.0 * M_PI / 2.0;
            scaleY = -1.0;
            break;
        case UIImageOrientationDown:
            scaleX = scaleY = -1.0;
            orgX -= aperture.size.width;
            orgY -= aperture.size.height;
            break;
        case UIImageOrientationDownMirrored:
            orgY -= aperture.size.height;
            scaleY = -1.0;
            break;
        case UIImageOrientationLeft:
            rot = 3.0 * M_PI / 2.0;
            orgX -= aperture.size.height;
            break;
        case UIImageOrientationLeftMirrored:
            rot = 3.0 * M_PI / 2.0;
            orgY -= aperture.size.height;
            orgX -= aperture.size.width;
            scaleY = -1.0;
            break;
        case UIImageOrientationUp:
            break;
        case UIImageOrientationUpMirrored:
            orgX -= aperture.size.width;
            scaleX = -1.0;
            break;
    }
    
    // set the draw rect to pan the image to the right spot
    CGRect drawRect = CGRectMake(orgX, orgY, imageToCrop.size.width, imageToCrop.size.height);
    
    // create a context for the new image
    UIGraphicsBeginImageContextWithOptions(size, NO, imageToCrop.scale);
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    // apply rotation and scaling
    CGContextRotateCTM(gc, rot);
    CGContextScaleCTM(gc, scaleX, scaleY);
    
    // draw the image to our clipped context using the offset rect
    CGContextDrawImage(gc, drawRect, imageToCrop.CGImage);
    
    // pull the image from our cropped context
    UIImage *cropped = UIGraphicsGetImageFromCurrentImageContext();
    
    // pop the context to get back to the default
    UIGraphicsEndImageContext();
    
    // Note: this is autoreleased
    return cropped;
}

@end
