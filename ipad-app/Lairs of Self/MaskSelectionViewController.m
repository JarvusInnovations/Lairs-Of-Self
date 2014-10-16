//
//  MaskSelectionViewController.m
//  Lairs of Self
//
//  Created by Tyler Wiest on 10/3/14.
//  Copyright (c) 2014 Jarvus Innovations. All rights reserved.
//

#import "MaskSelectionViewController.h"
#import "CameraOverlayView.h"

@interface MaskSelectionViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@property float maskHeight;
@property float maskWidth;
@property (strong) SharingViewController *sharingVC;
@end

@implementation MaskSelectionViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    
    NSUserDefaults * standardUserDefaults = [NSUserDefaults standardUserDefaults];
    _maskHeight = [[standardUserDefaults objectForKey:@"maskHeight"] floatValue];
    _maskWidth = [[standardUserDefaults objectForKey:@"maskWidth"] floatValue];
    
    if (!_maskHeight) {
        _maskHeight = 400.0f;
    }
    if (!_maskWidth) {
        _maskWidth = 400.0f;
    }
    NSLog(@"Maske Height %f %f", _maskHeight , _maskWidth );
    
    _items = [[NSMutableArray alloc]initWithObjects:
              @"01BymyselfbemyselfLOSToken.png",
              @"02PullhardkeepittogetherLOStoken.png",
              @"03NEVERENTEREVERAGAINLOStoken.png",
              @"04SomethingsgottorubLOStoken.png",
              @"05HornetsinacrystalLOStoken.png",
              @"06SlickandswollenLOStoken.png",
              @"07BurythebreadcrumbsLOStoken.png",
              @"08GlassinajamjarLOStoken.png",
              @"09SpillandspilleasilyLOStoken.png",
              @"10BoilingwithskeletonsLOStoken.png",nil];
}

- (void)dealloc
{
    _carousel.delegate = nil;
    _carousel.dataSource = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    _sharingVC = [[SharingViewController alloc] init];

    NSLog(@"Mask View Controller Did Load");
    [_carousel bringSubviewToFront:_proceedButton];
    _carousel.type = iCarouselTypeCoverFlow2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.carousel = nil;
}

// Image Selected
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    // NSLog(@"Selected image with index: %li",(long)index);
}

- (IBAction)proceedButtonClicked:(id)sender {
    
    NSInteger index = [_carousel currentItemIndex];
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"userImage"];
    UIImage* image = [UIImage imageWithData:imageData];
    
    APIRequest *request = [[APIRequest alloc] init];
    BOOL apiResponse = [request makeAPIRequestWithMask:index andUserImage:image];
    
    NSLog(@"Selected image with index: %li",(long)index);
    NSLog(@"Selected image with index: %@",image);

    //[self presentViewController:_sharingVC animated:YES completion:nil];
    //[self presentModalViewController:myNewVC animated:YES];
    
    if (apiResponse == YES) {
        NSLog(@"going to show word to remember");
        [self performSegueWithIdentifier:@"showSharing" sender:self];

//        [self dismissViewControllerAnimated:YES completion:^() {
//        }];
        
    } else {
        NSLog(@"going to enter installment screen");
        [self performSegueWithIdentifier:@"skipWord" sender:self];
    }
}

// Carousel Config
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 400.0f, 400.0f)];
        ((UIImageView *)view).image = [UIImage imageNamed:_items[index]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        view.clipsToBounds = YES;
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [label.font fontWithSize:50];
        label.tag = 1;
        [view addSubview:label];
        
    } else {
        label = (UILabel *)[view viewWithTag:1];
    }
    return view;
}

// Options
- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //NSLog(@"Options %d", option);
    
    if (option == iCarouselOptionSpacing)
    {
        return value * 4;
    }
    if (option == iCarouselOptionVisibleItems)
    {
        return 10;
    }
//    if (option == iCarouselOptionWrap)
//    {
//        return YES;
//    }
    if (option == iCarouselOptionTilt)
    {
        return .4;
    }

    return value;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    NSLog(@"Count: %lu", (unsigned long)[_items count]);
    //return the total number of items in the carousel
    return [_items count];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

@end