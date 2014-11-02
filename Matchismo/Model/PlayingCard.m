//
//  PlayingCard.m
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

- (NSAttributedString *)contents {
    NSArray * rankStrings = [PlayingCard rankStrings];
    NSString * content = [NSString stringWithFormat:@"%@%@", rankStrings[self.rank], self.suit];
    if ([self.suit isEqualToString: @"♥︎"] || [self.suit isEqualToString: @"♦︎"])
        return [[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    else
        return [[NSAttributedString alloc] initWithString:content attributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        

}

@synthesize suit = _suit; //because we provided the setter AND the GETTER

- (int) match:(NSArray *)otherCards {
    if ([otherCards count] == 0) return 0;
    int score = 0;
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            score += 4;
        }
        else if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }
    }
    return score += [otherCards[0] match:[otherCards subarrayWithRange:NSMakeRange(1, [otherCards count]-1)]];
}

- (void) setSuit:(NSString *)suit {
    if ([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

- (NSString *) suit {
    return _suit ? _suit : @"?";
}

+(NSArray *) validSuits{
    return @[@"♣︎",@"♠︎",@"♦︎",@"♥︎"];
}

+(NSUInteger) maxRank{
    return [[self rankStrings] count] -1;
}

+(NSArray *) rankStrings {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

- (void) setRank: (NSUInteger) rank {
    if(rank <= [PlayingCard maxRank])
        _rank = rank;
}

@end
