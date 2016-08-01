//
//  SplashViewController.m
//  KKH app
//
//  Created by Sean Lim on 24/6/16.
//  Copyright © 2016 tangentinc. All rights reserved.
//

#import "SplashViewController.h"


@interface SplashViewController ()

@end

@implementation SplashViewController

-(UIStatusBarStyle) preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //set bg color
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] == TRUE ) {
        [self.view setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"primaryColor"]]];
    }
    //
    [UIView animateWithDuration:0.4 delay:0.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _bearImg.transform = CGAffineTransformMakeScale(0.7, 0.7);
    }completion:^(BOOL s){
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                             pathForResource:@"soundE"
                                             ofType:@"mp3"]];
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        [audioPlayer play];        [UIView animateWithDuration:0.2 animations:^{
           
            _bearImg.transform = CGAffineTransformMakeScale(9, 9);
            _bearImg.alpha = 0;
            [self.view setBackgroundColor:[UIColor whiteColor]];
        }completion:^(BOOL s){
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"splashed"];
            [self performSegueWithIdentifier:@"main" sender:self];
        }];
        
    }];
}


@end