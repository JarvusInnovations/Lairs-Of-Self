//
//  EnterInstallationViewController.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/5/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "EnterInstallationViewController.h"

@interface EnterInstallationViewController ()

@end

@implementation EnterInstallationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                      target:self
                                    selector:@selector(toStartController)
                                    userInfo:nil
                                     repeats:NO];
}

- (void)toStartController
{
    NSLog(@"to start controller");
    [self performSegueWithIdentifier:@"restart" sender:self];
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
