//
//  ViewController.m
//  Memory
//
//  Created by Student on 4/26/15.
//  Copyright (c) 2015 Natasha Martinez. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation ViewController

@synthesize timer = _timer;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self startButton];
}

// Use 3rd party timer code
- (void)initTimer
{
    self.progressView = [[DACircularProgressView alloc] initWithFrame:CGRectMake(110.0f, 350.0f, 160.0f, 160.0f)];
    self.progressView.roundedCorners = YES;
    
    self.progressView.trackTintColor = [UIColor blackColor];
    self.progressView.progressTintColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Card_Back.png"]];
    
    [self.view addSubview:self.progressView];
    
    [self startTimerAnimation];
}

- (void)initCardStack
{
    [self.cards removeAllObjects];
    self.cards = [[NSMutableArray alloc] init];
    
    NSMutableArray * randPairOrder = [self shuffle];
    
    int buffer = 30;
    
    // Using a 7x4 grid (magic numbers)
    // TODO use a little math to determine
    int tagCounter = 1;
    for( int i = 0; i < 7; ++i )
    {
        for( int j = 0; j < 4; ++j )
        {
            // A ref to a file to hold the card info
            CardController * card = [[CardController alloc] init];
            
            // Make the card view
            UIView *customView = [[UIView alloc] initWithFrame:CGRectMake( ( 43 * i ) + buffer + ( 2 * i ), ( 60 * j ) + buffer + ( 2 * j ), 43, 60)];
            customView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Card_Back.png"]];
            customView.tag = tagCounter;
            tagCounter += 1;
            
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
            tapGesture.numberOfTapsRequired=1;
            [customView setUserInteractionEnabled:YES];
            [customView addGestureRecognizer:tapGesture];
            
            // Make the card label
            UILabel *customLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 30, 30)];
            
            // Get a number
            customLabel.text = [randPairOrder objectAtIndex:( tagCounter - 2 )];
            
            [customView addSubview:customLabel];
            customLabel.hidden = true;
            
            // Instantiate the card class
            [card CardView:customView CardLabel:customLabel];
            
            // Add to screen and array
            [self.view addSubview:customView];
            [self.cards addObject:card];
        }
    }
}

- (NSMutableArray*)shuffle
{
    NSMutableArray * randomNums = [[NSMutableArray alloc] init];
    for (int i = 1; i < NUM_PAIRS + 1; ++i )
    {
        [randomNums addObject:[NSString stringWithFormat:@"%d", i]];
        [randomNums addObject:[NSString stringWithFormat:@"%d", i]];
    }
    
    NSUInteger count = [randomNums count];
    for (NSUInteger i = 0; i < count; ++i) {
        NSInteger remainingCount = count - i;
        NSInteger exchangeIndex = i + arc4random_uniform((u_int32_t )remainingCount);
        [randomNums exchangeObjectAtIndex:i withObjectAtIndex:exchangeIndex];
    }
    
    return randomNums;
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    if( !self.twoTilesChosen )
    {
        UIView * cardTapped = recognizer.view;
        
        CardController * card = [[CardController alloc] init];
        for( int i = 0; i < self.cards.count; ++i )
        {
            card = [self.cards objectAtIndex:i];
            if( card.cardView.tag == cardTapped.tag )
            {
                // Don't allow for double choosing cards
                if( self.selectedCards.count > 0 && card == [self.selectedCards objectAtIndex:0] )
                {
                    NSLog(@"Card is already selected");
                    return;
                }
                
                [card showCardFace];
                
                [self.selectedCards addObject:card];
                
                break;
            }
        }
        
        // Check for two selected cards
        if( self.selectedCards.count > 1 )
        {
            self.twoTilesChosen = true;
            [self checkMatch];
        }
    }
}

-(void)checkMatch
{
    CardController * card1 = [self.selectedCards objectAtIndex:0];
    CardController * card2 = [self.selectedCards objectAtIndex:1];
    
    if( [ card1.cardLabel.text isEqualToString:( card2.cardLabel.text ) ] )
    {
        // Match!
        
        // Unshow cards
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            card1.cardLabel.hidden = true;
            card1.cardView.hidden = true;
            card2.cardLabel.hidden = true;
            card2.cardView.hidden = true;
            
            self.twoTilesChosen = false;
        });
        
        // remove cards from array
        [self.cards removeObject:card1];
        [self.cards removeObject:card2];
        
        [self checkForWin];
    }
    else
    {
        // Not a match
        double delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [card1 hideCardFace];
            [card2 hideCardFace];
            
            self.twoTilesChosen = false;
        });
    }
    
    // Clear selected cards
    [self.selectedCards removeAllObjects];
    self.selectedCards = [[NSMutableArray alloc] init];
}

- (void)checkForWin
{
    if( self.cards.count < 2 )
    {
        // Won the game!
        [self stopTimerAnimation];
        
        [self AlertMessage:@"You Won!" SubMessage:@"You beat the game!"];
    }
}

- (void)loseGame
{
    // Remove remaining tiles
    CardController *card;
    for( int i = 0; i < self.cards.count; ++i )
    {
        card = [self.cards objectAtIndex:i];
        [card deleteCardObjects];
    }
    
    [self AlertMessage:@"You lost" SubMessage:@"Try Again?"];
}

- (void)newGame
{
    self.twoTilesChosen = false;
    
    self.selectedCards = [[NSMutableArray alloc] init];
    
    [self initCardStack];
    
    [self initTimer];
}

- (void)startButton
{
    self.startBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.startBtn addTarget:self
                      action:@selector(startGame:)
            forControlEvents:UIControlEventTouchUpInside];
    [self.startBtn setTitle:@"Start Game" forState:UIControlStateNormal];
    self.startBtn.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    [self.view addSubview:self.startBtn];
}

- (IBAction)startGame:(id)sender
{
    self.startBtn.enabled = false;
    self.startBtn.hidden = true;
    [self newGame];
}

- (void)startTimerAnimation
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.03
                                                  target:self
                                                selector:@selector(progressChange)
                                                userInfo:nil
                                                 repeats:YES];
}

- (void)stopTimerAnimation
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)progressChange
{
    CGFloat progress = self.progressView.progress + (0.03f / TIME_LIMIT);
    [self.progressView setProgress:progress animated:YES];
    
    if (self.progressView.progress >= 1.0f && [self.timer isValid]) {
        [self stopTimerAnimation];
        [self loseGame];
    }
    
    //self.progressLabel.text = [NSString stringWithFormat:@"%.2f", self.progressView.progress];
}

// Use 3rd party alert message code
- (void)AlertMessage:(NSString*)title SubMessage:(NSString*)message
{
    URBAlertView *alertView = [[URBAlertView alloc] initWithTitle:title message:message];
    [alertView addButtonWithTitle:@"Close"];
    [alertView addButtonWithTitle:@"Play Again"];
    [alertView setHandlerBlock:^(NSInteger buttonIndex, URBAlertView *alertView) {
        if ( buttonIndex == 0 ) {
            self.startBtn.enabled = true;
            self.startBtn.hidden = false;
        }
        else if( buttonIndex == 1 )
        {
            [self newGame];
        }
        [alertView hideWithCompletionBlock:^{
            NSLog(@"Alert view closed.");
        }];
    }];
    [alertView showWithAnimation:URBAlertAnimationFlipHorizontal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end




























// EoF
