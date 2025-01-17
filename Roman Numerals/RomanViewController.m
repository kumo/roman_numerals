//
//  RomanViewController.m
//  Roman Numerals
//
//  Created by Robert Clarke on 25/01/2014.
//  Copyright (c) 2014 Robert Clarke. All rights reserved.
//

#import "RomanViewController.h"
#import "Converter.h"
#import "UIImage+Colours.h"
#import "RomanNumsActivityItemProvider.h"


@interface RomanViewController ()

@end

@implementation RomanViewController

// @synthesize romanLabel, arabicLabel;

@synthesize converter, string;
@synthesize buttons;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.converter = [[Converter alloc] init];

    // Prepare gestures
    for (UIButton *button in self.buttons) {
        UIGestureRecognizer *touchGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
        
        [button addGestureRecognizer:touchGesture];
        
        [button setBackgroundImage:[UIImage imageWithDarkHighlight] forState:UIControlStateHighlighted];
    }
    
    UIGestureRecognizer *longTouchGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    [self.buttonDelete addGestureRecognizer:longTouchGesture];

    [self.buttonDelete setBackgroundImage:[UIImage imageWithLightHighlight] forState:UIControlStateHighlighted];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    // set the keyboard order
    NSUserDefaults *defaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.it.kumo.roman"];
    int keyboardType = [[defaults valueForKey:kKeyboardPresentationKey] intValue];
    
    if (keyboardType == 0) {
        [self setButtonTitles:@[@"C", @"D", @"Ⅰ", @"L", @"M", @"V", @"X"]];
    } else if (keyboardType == 1) {
        [self setButtonTitles:@[@"M", @"D", @"C", @"L", @"X", @"V", @"Ⅰ"]];
    } else {
        [self setButtonTitles:@[@"Ⅰ", @"V", @"X", @"L", @"C", @"D", @"M"]];
    }
    
	self.converter.performConversionCheck = [defaults boolForKey:kAutoCorrectKey];
    
    UIBarButtonItem *shareButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(shareButton:)];
    
    [self.tabBarController.navigationItem setRightBarButtonItem:shareButton];
    
    [self.tabBarController.navigationItem setTitle:@"Roman Nums"];
    
    userDidSomething = NO;
}

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


- (void)viewDidLayoutSubviews
{
    if (IS_IPHONE_5) {
        _arabicLabel.center = CGPointMake(_arabicLabel.center.x, _arabicLabel.center.y + 50);
        _romanLabel.center = CGPointMake(_romanLabel.center.x, _romanLabel.center.y + 50);
    }
}

- (IBAction)handleTapGesture:(UIGestureRecognizer *) sender {
    UIButton *button = (UIButton *)sender.view;
    
    if (userDidSomething == NO) {

        userDidSomething = YES;
    }
    
    if (button.tag == -99) {
        [self updateRomanString: @"delete"];
    } else {
        [self updateRomanString: [button currentTitle]];
    }
}

- (IBAction)handleLongPressGesture:(UIGestureRecognizer *) sender {
    self.string = @"";
    self.romanLabel.text = @"";
    self.arabicLabel.text = @"";
}

#pragma mark - Conversion methods

- (void)convertYear:(NSString *)input {
	[self.converter convertToArabic:input];
    
	//debugLog(@"conversion result is %d", converter.conversionResult);
	if (self.converter.conversionResult == Ignored)
	{
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animation];
        animation.keyPath = @"position.x";
        animation.values = @[ @0, @10, @-10, @10, @0 ];
        animation.keyTimes = @[ @0, @(1 / 6.0), @(3 / 6.0), @(5 / 6.0), @1 ];
        animation.duration = 0.4;
        
        animation.additive = YES;
        
        [self.romanLabel.layer addAnimation:animation forKey:@"shake"];
	} else if (converter.conversionResult == Converted) {
		NSString *result = self.converter.arabicResult;
		self.arabicLabel.text = result;
		
		[UIView beginAnimations:@"switch" context:nil];
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.romanLabel cache:YES];
		[UIView setAnimationDuration:0.3f];
		NSString *convertedValue = self.converter.calculatedRomanValue;
		self.romanLabel.text = convertedValue;
		
		[UIView commitAnimations];
        
        [self.arabicLabel setAccessibilityValue:self.arabicLabel.text];

        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", result]);
    } else {
		NSString *result = self.converter.arabicResult;
		self.arabicLabel.text = result;
		
		self.romanLabel.text = input;
        [self.arabicLabel setAccessibilityValue:self.arabicLabel.text];
        
        UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, [NSString stringWithFormat:@"Result: %@", result]);

	}
}

- (void)updateRomanString:(NSString *) text  {
	self.string = [self.romanLabel text];
	
    NSString *romanLabelString = self.string;
    
    if (romanLabelString == Nil) {
        romanLabelString = @"";
    }
    
	if ([text isEqualToString: @"delete"]) {
		if ([romanLabelString length] > 0) {
			NSString *newInputString = [[NSString alloc] initWithString:[romanLabelString substringToIndex: [romanLabelString length] - 1]];
			[self convertYear:newInputString];
		}
	}
	else if ([romanLabelString length] < 14) {
		NSString *newInputString = [[NSString alloc] initWithFormat:@"%@%@", romanLabelString, text];
		[self convertYear:newInputString];
    }
    
}

#pragma mark - UI methods

- (void)setButtonTitles:(NSArray *)titles {
    for (int i=0; i<7; i++) {
        UIButton *button = (UIButton *)[self.view viewWithTag:5001 + i];
        NSString *title = [titles objectAtIndex:i];
        
        [button setTitle:title forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateHighlighted];
    }
}

- (IBAction)shareButton:(id)sender {
    // Show different text for each service, see http://www.albertopasca.it/whiletrue/2012/10/objective-c-custom-uiactivityviewcontroller-icons-text/
    RomanNumsActivityItemProvider *activityItemProvider = [[RomanNumsActivityItemProvider alloc] initWithRomanText:self.romanLabel.text arabicText:self.arabicLabel.text romanToArabic:YES];
    
    if ([self.romanLabel.text isEqualToString:@""]) {
        return;
    }
    
    NSArray *itemsToShare = @[activityItemProvider];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    //activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //or whichever you don't need
    
    [activityVC setCompletionHandler:^(NSString *activityType, BOOL completed) {
        //NSLog(@"completed: %@", activityType);
        
        if (completed) {
        }
        //Present another VC
    }];
    
    [self presentViewController:activityVC animated:YES completion:nil];
}

@end
