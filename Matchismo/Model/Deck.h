//
//  Deck.h
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "Card.h"
#import <Foundation/Foundation.h>

@interface Deck : NSObject

- (void) addCard:(Card *)card atTop:(BOOL)atTop;
- (void) addCard:(Card *)card;

- (Card *) drawRandomCard;

@end
