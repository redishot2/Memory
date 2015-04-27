//
//  CardController.h
//  Memory
//
//  Created by Student on 4/26/15.
//  Copyright (c) 2015 Natasha Martinez. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CardController : NSObject

@property UIView  * cardView;
@property UILabel * cardLabel;

@property BOOL isFaceUp;

-(CardController * )CardView:(UIView *)cardView CardLabel:(UILabel *) cardLabel;

- (void)showCardFace;
- (void)hideCardFace;
- (void)deleteCardObjects;

@end
