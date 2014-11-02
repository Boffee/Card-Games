//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController

@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic, readonly) IBOutlet UIView *BoardView;
@property (nonatomic, readonly) CGSize cardSize;
@property (strong, nonatomic) NSMutableArray* cardViewCollection;
@property (strong, nonatomic) NSMutableArray* removedCards;


- (Deck *)createDeck; // abstract function

- (NSUInteger) startCardsOnBoard;

- (CardView *)createView:(CGRect)frame;

- (CGSize)gridSize;

- (NSUInteger) setGameMode;

- (void) cardViewsAreMatched:(NSArray *)matchedCardSet;

- (void) flipCardAnimated:(CardView *)cardView isFaceUp:(BOOL)faceUp;

- (BOOL) checkIfMatchesLeft;

@end
