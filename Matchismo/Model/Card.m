//
//  Card.m
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *) otherCards {
    int score = 0;
    for (Card *card in otherCards) {
        if ([card.contents isEqualToAttributedString:self.contents]){
            score = 1;
        }
    }
    return score;
}

@end
