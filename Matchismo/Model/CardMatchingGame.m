//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Brian Li on 6/24/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()

@property (nonatomic,readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic, strong) Deck *deck;
@property (nonatomic) NSInteger matchScore;
@property (nonatomic,readwrite)NSInteger returnMatchScore;
@property (nonatomic, strong) NSMutableArray *selectedCards;

@end

@implementation CardMatchingGame

- (NSMutableArray *)cards {
    if(!_cards) _cards  = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)selectedCards {
    if(!_selectedCards) _selectedCards = [[NSMutableArray alloc] init];
    return _selectedCards;
}

- (Deck *)deck {
    if(!_deck) {
        _deck = [[Deck alloc]init];
    }
    return _deck;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck {
    self = [super init];
    if(self) {
        self.deck = deck;
        for (int i = 0; i < count; i++) {
            Card *card = [self.deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

static const int MATCH_PENALTY = -2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index {

    Card *card = [self cardAtIndex:index];
    if (card.isChosen) {
        card.chosen = NO;
        [self.selectedCards removeObject:card];
    }
    else {
        if (!card.isMatched) {
            for (Card *otherCard in self.cards) {
                // find preivously chosen card
                if (otherCard.isChosen && !otherCard.isMatched) {
                    // if selected card reach max for game mode
                    if ([self.selectedCards count] == [self cardsInMode]-1) {
                        
                        self.matchScore = [card match:self.selectedCards];
                        // and there is at least one match, scale score with bonus/penalty
                        if (self.matchScore>0) {
                            self.matchScore *= MATCH_BONUS/(self.mode+1);
                            
                            for (Card * matchedCard in self.selectedCards) {
                                matchedCard.matched = YES;
                            }
                            card.matched = YES;
                            
                            [self.selectedCards removeAllObjects];
                        }
                        else {
                            self.matchScore = MATCH_PENALTY;
                            for (Card *unmatchedCard in self.selectedCards) {
                                unmatchedCard.chosen = NO;
                            }
                            [self.selectedCards removeAllObjects];

                        }
                        self.score += self.matchScore;
                        self.returnMatchScore = self.matchScore;
                        self.matchScore = 0;
                        break;
                    }
                }
            }
            if (!card.isMatched) [self.selectedCards addObject:card];
            
            self.score -= COST_TO_CHOOSE;
            card.chosen = YES;
        }
    }
}


- (NSUInteger) cardsInMode {
    return self.mode+2;
}

- (Card *)cardAtIndex:(NSUInteger)index {
    return (index<[self.cards count]) ? self.cards[index] : nil;
}

- (void)drawAdditionalCard {
    Card *card = [self.deck drawRandomCard];
    if (card){
        [self.cards addObject:card];
        if (self.hasMatch) self.score -= 10;
    }
    else {
        self.outOfCards = true;
    }
    if (![self.cards count]) self.outOfCards = true;
}

- (void)removeCard:(Card *)card {
    [self.cards removeObject:card];
}

@end
