//
//  ViewController.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "ViewController.h"
#import "APIRequest.h"
#import "NoPushAnimationSegue.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _closeButton.hidden = true;
    _termsContent.hidden = true;
    _omitContent.hidden = true;
    _backButton.hidden = true;
    _ImSureButton.hidden = true;
    
//    APIRequest *request = [[APIRequest alloc] init];
//    [request makeAPIRequest];
    
//    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
//    NSString * display_type = [standardUserDefaults objectForKey:@"display_type"];
//    NSString * server_address = [standardUserDefaults objectForKey:@"server_address"];
//    NSLog(@"Host Address: %@", server_address);
//    NSLog(@"Display Type: %@", display_type);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)termsOfUse:(id)sender {
    
    [self updateAssetAlphas:.2];
    [self updateButtonEnablement:NO];
    
    _closeButton.hidden = false;
    _termsContent.hidden = false;
}

- (IBAction)closeTerms:(id)sender {
    
    [self updateAssetAlphas:1];
    [self updateButtonEnablement:YES];
    
    _closeButton.hidden = true;
    _termsContent.hidden = true;
    
}

- (IBAction)backToFront:(id)sender {
    _backButton.hidden = true;
    _ImSureButton.hidden = true;
    _omitContent.hidden = true;
    
    _omitButton.hidden = false;
    _proceedButton.hidden = false;
    _contentLabel1.hidden = false;
}

- (IBAction)enterInsallation:(id)sender {
    [self performSegueWithIdentifier:@"enterInstallation" sender:self];
}

- (IBAction)omitInstallation:(id)sender {
    _omitButton.hidden = true;
    _proceedButton.hidden = true;
    _contentLabel1.hidden = true;
    
    _backButton.hidden = false;
    _ImSureButton.hidden = false;
    _omitContent.hidden = false;
    
}

- (void)updateAssetAlphas:(float)value {
    _logo.alpha = value;
    _contentLabel1.alpha = value;
    _omitButton.alpha = value;
    _proceedButton.alpha = value;
    _termsOfUseButton.alpha = value;
    _backButton.alpha = value;
    _ImSureButton.alpha = value;
    _omitContent.alpha = value;
}

- (void)updateButtonEnablement:(BOOL)value {
    _omitButton.userInteractionEnabled = value;
    _proceedButton.userInteractionEnabled = value;
    _termsOfUseButton.userInteractionEnabled = value;
    _backButton.userInteractionEnabled = value;
    _ImSureButton.userInteractionEnabled = value;
}

@end
