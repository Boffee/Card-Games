//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Brian Li on 6/24/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "Deck.h"
#include "Card.h"


@interface CardMatchingGame : NSObject


@property (nonatomic, readonly) NSInteger score;
@property (nonatomic, readonly) NSInteger returnMatchScore;
@property (nonatomic) NSUInteger mode;
@property (nonatomic) BOOL outOfCards;
@property (nonatomic) BOOL hasMatch;

//designated initializer
- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (void)drawAdditionalCard;
- (void)removeCard:(Card *)card;

@end
