//
//  PSImageView.h
//  TestRoundedImage
//
//  Created by Paul Semionov on 13.11.13.
//  Copyright (c) 2013 Paul Semionov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PSImageView : UIImageView

@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) UIColor *borderColor;

@property (nonatomic, assign) BOOL rounded;
@property (nonatomic, assign) BOOL processed;

@end
