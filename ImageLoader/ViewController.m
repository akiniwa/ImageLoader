//
//  ViewController.m
//  ImageLoader
//
//  Created by Piyush Pathak on 3/13/13.
//  Copyright (c) 2013 Piyush-Pathak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}
-(void)LoadImageButtonTapped:(UIButton *)sender{
    
    [imageView loadWithUrl:urlTextField.text];
    [imageView setCaption:@"your caption will be shown here" withFont:[UIFont fontWithName:@"Helvetica" size:15.0f]];
}

- (void)didReceiveMemoryWarning
{

    // Dispose of any resources that can be recreated.
}

@end
