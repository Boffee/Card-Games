//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by Brian Li on 8/8/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "SetCardGameViewController.h"

@interface SetCardGameViewController ()

@property (strong,nonatomic) NSMutableArray * solutionCollection;

@end

@implementation SetCardGameViewController

- (Deck *) createDeck {
    return [[SetCardDeck alloc] init];
}

- (NSUInteger) setGameMode {
    return 1;
}

- (CardView *)createView:(CGRect)frame {
    SetCardView *view = [[SetCardView alloc] initWithFrame:frame];
    return view;
}

- (NSMutableArray *)solutionCollection {
    if (!_solutionCollection) {
        _solutionCollection = [[NSMutableArray alloc]init];
    }
    return _solutionCollection;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (NSUInteger) startCardsOnBoard { return 12;}


- (CGSize) gridSize {
    CGSize gridSize = {self.cardSize.height,self.cardSize.width};
    return gridSize;
}

- (void) cardViewsAreMatched:(NSArray *)matchedCardSet {
    [self.cardViewCollection removeObjectsInArray:matchedCardSet];
    for (SetCardView *matchedCardView in matchedCardSet) {
        [self.game removeCard: matchedCardView.card];
    }
}

- (void)flipCardAnimated:(CardView *)cardView isFaceUp:(BOOL)faceUp{
    cardView.faceUp = faceUp;
}

- (void)CheatSets {
    NSMutableArray *fillSet = [[NSMutableArray alloc] init];
    [self createSets:fillSet startIndex:0 count:3];
}


- (void)createSets:(NSMutableArray *)oldFillSet startIndex:(NSUInteger)start count:(NSUInteger)count {
    // base case
    if (count < 1 || start > [self.cardViewCollection count]) {
        [self checkIfArrayIsASet:oldFillSet];
        return;
    }
    
    // recursive tree
    for (NSUInteger i = start; i < [self.cardViewCollection count]; i++) {
        CardView *cardView = self.cardViewCollection[i];
        if (![self.removedCards containsObject:cardView]) {
            NSMutableArray *fillSet = [NSMutableArray arrayWithArray:oldFillSet];
            [fillSet addObject:cardView];
            [self createSets:fillSet startIndex:i+1 count:count-1];
        }
    }
}

- (void)checkIfArrayIsASet:(NSArray *)set {
    SetCardView *cardView0 = set[0];
    NSMutableArray *otherCards = [[NSMutableArray alloc] init];
    for (NSUInteger i = 1; i < [set count]; i++) {
        SetCardView *cardView = set[i];
        [otherCards addObject:cardView.card];
    }
    if ([cardView0.card match:otherCards]) {
        [self.solutionCollection addObject:set];
    }
}

- (IBAction)hint {
    for (CardView *cardView in self.cardViewCollection) {
        cardView.inASet = false;
    }

    self.solutionCollection = nil;
    [self CheatSets];
    if ([self.solutionCollection count]) {
        int randIndex = arc4random()%[self.solutionCollection count];
        for (CardView *cardView in self.solutionCollection[randIndex]) {
            cardView.inASet = true;

        }
    }
}

- (BOOL) checkIfMatchesLeft {
    [self CheatSets];
    if ([self.solutionCollection count])
        return true;
    else
        return false;
}

@end
