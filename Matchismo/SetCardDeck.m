//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Brian Li on 8/8/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (instancetype) init {
    self = [super init];
    if (self) {
        for (NSUInteger shape = 0; shape < 3; shape++) {
            for (NSUInteger pattern = 0; pattern < 3; pattern++) {
                for (NSUInteger color = 0; color < 3; color++) {
                    for (int copies = 1; copies <= [setCard maxAmount]; copies++) {
                        setCard *card = [[setCard alloc]init];
                        card.shape = shape;
                        card.pattern = pattern;
                        card.color = color;
                        card.copies = copies;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
