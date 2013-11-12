//
//  ViewController.m
//  TestRoundedImage
//
//  Created by Paul Semionov on 13.11.13.
//  Copyright (c) 2013 Paul Semionov. All rights reserved.
//

#import "ViewController.h"

#import "PSImageView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    PSImageView *imageView = [[PSImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    imageView.center = self.view.center;
    
    imageView.borderWidth = 2.0f;
    imageView.borderColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.5f];
    imageView.image = [UIImage imageNamed:@"image.jpg"];
    
    [self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
