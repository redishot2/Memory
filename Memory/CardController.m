//
//  CardController.m
//  Memory
//
//  Created by Student on 4/26/15.
//  Copyright (c) 2015 Natasha Martinez. All rights reserved.
//

#import "CardController.h"

@implementation CardController

-(CardController * )CardView:(UIView *)initCardView CardLabel:(UILabel *) initCardLabel {
    self.cardLabel = initCardLabel;
    self.cardView  = initCardView;
    self.isFaceUp = false;
    
    return self;
}

// Clicked on card
- (void)showCardFace
{
    self.cardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Card_Front.png"]];
    self.cardLabel.hidden = false;
    self.isFaceUp = true;
}

// Unclicked on card
- (void)hideCardFace
{
    self.cardView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Card_Back.png"]];
    self.cardLabel.hidden = true;
    self.isFaceUp = false;
}

- (void)deleteCardObjects
{
    [self.cardView removeFromSuperview];
    [self.cardLabel removeFromSuperview];
}

@end
