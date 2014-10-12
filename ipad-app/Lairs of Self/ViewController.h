//
//  ViewController.h
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UIButton *closeButton;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel1;
@property (strong, nonatomic) IBOutlet UILabel *contentLabel2;
@property (strong, nonatomic) IBOutlet UIButton *termsOfUseButton;
@property (strong, nonatomic) IBOutlet UIButton *omitButton;
@property (strong, nonatomic) IBOutlet UIButton *proceedButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *ImSureButton;
@property (strong, nonatomic) IBOutlet UILabel *omitContent;
@property (strong, nonatomic) IBOutlet UIImageView *termsContent;

- (IBAction)proceedToCamera:(id)sender;
- (IBAction)termsOfUse:(id)sender;
- (IBAction)closeTerms:(id)sender;
- (IBAction)backToFront:(id)sender;
- (IBAction)enterInsallation:(id)sender;
- (IBAction)omitInstallation:(id)sender;

@end

