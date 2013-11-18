//
//  PSImageView.m
//  TestRoundedImage
//
//  Created by Paul Semionov on 13.11.13.
//  Copyright (c) 2013 Paul Semionov. All rights reserved.
//

#import "PSImageView.h"

@implementation PSImageView

@synthesize borderWidth = _borderWidth;
@synthesize borderColor = _borderColor;

@synthesize rounded = _rounded;
@synthesize processed = _processed;

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
    
    if(_rounded) {
        
        if(image.size.width != image.size.height) {
            
            // Make square from center, based on image height
            
            image = [self image:image byCroppingToRectangle:CGRectMake(image.size.width / 2 - image.size.height / 2,
                                                                       image.size.height / 2 - image.size.height / 2,
                                                                       image.size.height,
                                                                       image.size.height)];
            
            if(!_processed) {
            
                UIImage *image_ = [self proccess:image];
                
                [super setImage:image_];
                
            }else{
                
                [super setImage:image];
                
            }
            
        }else{
            
            if(!_processed) {
            
                UIImage *image_ = [self proccess:image];
            
                [super setImage:image_];
                
            }else{
                
                [super setImage:image];
                
            }
            
        }
        
    }else{
        
        image = [self image:image byCroppingToRectangle:CGRectMake(image.size.width / 2 - image.size.height / 2,
                                                                   image.size.height / 2 - image.size.height / 2,
                                                                   image.size.height,
                                                                   image.size.height)];
        
        [super setImage:image];
        
    }
    
}

#pragma mark --
#pragma mark - Proccessing

- (UIImage *)proccess:(UIImage *)image_ {
    
    BOOL stroke = NO;
    CGFloat borderWidth_;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGImageRef imageRef = CGImageCreateCopy([image_ CGImage]);
    CGRect frame = CGRectMake(0.0f, 0.0f, self.bounds.size.width * scale, self.bounds.size.height * scale);
    
    CGRect rect = frame;
    
    CGContextRef bitmapContext = CGBitmapContextCreate(NULL,
                                                       rect.size.width,
                                                       rect.size.height,
                                                       CGImageGetBitsPerComponent(imageRef),
                                                       CGImageGetBytesPerRow(imageRef),
                                                       CGImageGetColorSpace(imageRef),
                                                       CGImageGetBitmapInfo(imageRef)
                                                       );
    
    if(_borderWidth > 0 && (_borderColor && ![_borderColor isEqual:[UIColor clearColor]])) {
        
        borderWidth_ = scale * _borderWidth;
        
        stroke = YES;
        
        rect.origin.x = frame.origin.x + borderWidth_;
        rect.origin.y = frame.origin.y + borderWidth_;
        rect.size.width = frame.size.width - borderWidth_ * 2;
        rect.size.height = frame.size.height - borderWidth_ * 2;
        
    }
    
    CGPathRef clipPath = CGPathCreateWithEllipseInRect(rect, NULL);
    CGPathRef strokePathRef = CGPathCreateWithEllipseInRect(frame, NULL);
    
    if(stroke) {
        
        CGContextBeginPath(bitmapContext);
        CGContextAddPath(bitmapContext, strokePathRef);
        
        CGContextSetFillColorWithColor(bitmapContext, _borderColor.CGColor);
        CGContextFillPath(bitmapContext);
        
    }
    
    CGPathRelease(strokePathRef);
    
    CGContextAddPath(bitmapContext, clipPath);
    CGContextClip(bitmapContext);
    CGPathRelease(clipPath);
    
    CGContextDrawImage(bitmapContext, rect, imageRef);
    CGImageRelease(imageRef);
    
    CGImageRef roundedImageRef = CGBitmapContextCreateImage(bitmapContext);
    UIImage *roundedImage = [UIImage imageWithCGImage:roundedImageRef scale:scale orientation:UIImageOrientationUp];

    CGImageRelease(roundedImageRef);
    CGContextRelease(bitmapContext);
    
    return roundedImage;
    
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
