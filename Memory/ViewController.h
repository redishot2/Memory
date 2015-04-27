//
//  ViewController.h
//  Memory
//
//  Created by Student on 4/26/15.
//  Copyright (c) 2015 Natasha Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CardController.h"
#import "URBAlertView.h"
#import "DACircularProgressView.h"

#define NUM_PAIRS 14
#define TIME_LIMIT 60

@interface ViewController : UIViewController

@property DACircularProgressView * progressView;
@property NSMutableArray * cards;
@property NSMutableArray * selectedCards;
@property UIButton *startBtn;
@property BOOL twoTilesChosen;

- (void)initCardStack;

@end

