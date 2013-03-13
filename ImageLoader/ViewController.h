//
//  ViewController.h
//  ImageLoader
//
//  Created by Piyush Pathak on 3/13/13.
//  Copyright (c) 2013 Piyush-Pathak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageLoader.h"
@interface ViewController : UIViewController
{
    IBOutlet UITextField *urlTextField;
    IBOutlet ImageLoader *imageView;
}

-(IBAction)LoadImageButtonTapped:(UIButton*)sender;

@end
