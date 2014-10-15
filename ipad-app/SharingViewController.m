//
//  SharingViewController.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/7/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "SharingViewController.h"

@interface SharingViewController ()

@end

@implementation SharingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Share Screen view did laod");
    
    NSString *responseWord = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    NSLog(@"Response Word %@", responseWord);
    if (responseWord) {
        _wordLabel.text = responseWord;
    }
    
    [NSTimer scheduledTimerWithTimeInterval:10
                                     target:self
                                   selector:@selector(toEnterInstallation)
                                   userInfo:nil
                                    repeats:NO];
}

- (void)toEnterInstallation {
    [self performSegueWithIdentifier:@"toEnterInstallation" sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
