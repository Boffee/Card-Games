//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Brian Li on 8/7/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "PlayingCardGameViewController.h"

@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController



- (Deck *) createDeck {
    return [[PlayingCardDeck alloc] init];
}

- (NSUInteger) setGameMode {
    return 0;
}

- (CardView *)createView:(CGRect)frame {
    PlayingCardView *view = [[PlayingCardView alloc] initWithFrame:frame];
    return view;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSUInteger) startCardsOnBoard {
    return 20;
}


- (CGSize) gridSize {
    CGSize gridSize = {self.cardSize.width,self.cardSize.height};
    return gridSize;
}

@end
