//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Brian Li on 8/11/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "CardView.h"
#import "PlayingCard.h"

@interface PlayingCardView : CardView

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;
@property (strong, nonatomic) UIColor *color;

@end
