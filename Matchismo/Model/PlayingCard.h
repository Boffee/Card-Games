//
//  PlayingCard.h
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString * suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *) validSuits;
+(NSUInteger) maxRank;

@end
