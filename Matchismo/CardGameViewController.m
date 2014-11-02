//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Brian Li on 6/21/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "CardGameViewController.h"
#import "GameHistoryViewController.h"

@interface CardGameViewController ()

//@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
//@property (nonatomic) int flipCount;
//@property (strong, nonatomic) Deck *deck;
//@property (strong, nonatomic) IBOutlet UISegmentedControl *gameMode;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *displayMove;

@property (strong, nonatomic) NSMutableArray* selectedCardIndices;
@property (strong, nonatomic) NSMutableArray* playRecord;
@property (strong, nonatomic) NSMutableArray* scoreRecord;

@property (weak, nonatomic, readwrite) IBOutlet UIView *BoardView;

@property (strong, nonatomic) Grid *grid;
@property (nonatomic) NSUInteger numberOfCards;
@property (nonatomic) CGFloat gridAspectRatio;
@property (nonatomic, readwrite) CGSize cardSize;

@property (strong, nonatomic)UIDynamicAnimator *animator;
@property (strong, nonatomic)NSMutableArray *cardViewAttactment;

@property (nonatomic)float pinchRatio;
@property (nonatomic)BOOL piled;

@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *tapInBoardGesture;

@end

@implementation CardGameViewController

#pragma mark - Initialization
// do some setup when view loads
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.BoardView.opaque = nil;
    self.numberOfCards = [self numberOfCards];
    // Do any additional setup after loading the view.
}

// set up destination view properties
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"History"]) {
        if ([segue.destinationViewController isKindOfClass:[GameHistoryViewController class]]) {
            GameHistoryViewController *ghvc = (GameHistoryViewController *)segue.destinationViewController;
            ghvc.playHistory = self.playRecord;
            ghvc.scoreHistory = self.scoreRecord;
        }
    }
}

- (void) viewDidLayoutSubviews {
    
    if (!self.grid) {
        [self setAspectRatioAndCardSize];
        if (self.grid) {
            [self setUpBoardWithCards];
        }
    }
    
    [super viewDidLayoutSubviews];
    float percentMatch = self.BoardView.bounds.size.height/(self.grid.rowCount*self.grid.cellSize.height);
    if (percentMatch < 0.98 || percentMatch > 1.02) {
        [self updateCardPositions];
    }
}

#pragma mark - Property Instantiation

// Lazy instantiation
- (CardMatchingGame *)game {
    if(!_game) {
        NSUInteger count = ([self.cardButtons count]) ? [self.cardButtons count]: self.numberOfCards;
        _game = [[CardMatchingGame alloc] initWithCardCount:count usingDeck:[self createDeck]];
        _game.mode = [self setGameMode];
    }
    return _game;
}

- (NSMutableArray *)selectedCardIndices {
    if (!_selectedCardIndices) {
        _selectedCardIndices = [[NSMutableArray alloc]init];
    }
    return _selectedCardIndices;
}

- (NSMutableArray *)playRecord {
    if (!_playRecord) {
        _playRecord = [[NSMutableArray alloc] init];
    }
    return _playRecord;
}

- (NSMutableArray *)scoreRecord {
    if (!_scoreRecord) {
        _scoreRecord = [[NSMutableArray alloc] init];
    }
    return _scoreRecord;
}

- (NSMutableArray *)cardViewCollection {
    if (!_cardViewCollection) {
        _cardViewCollection = [[NSMutableArray alloc] init];
    }
    return _cardViewCollection;
}

- (NSMutableArray *)removedCards {
    if(!_removedCards) {
        _removedCards = [[NSMutableArray alloc] init];
    }
    return _removedCards;
}

- (NSUInteger) numberOfCards {
    if(!_numberOfCards) {
        return [self startCardsOnBoard];
    }
    return _numberOfCards;
}

- (UIDynamicAnimator *)animator {
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.BoardView];
    }
    return _animator;
}

- (NSMutableArray *)cardViewAttactment {
    if(!_cardViewAttactment) {
        _cardViewAttactment = [[NSMutableArray alloc] init];
    }
    return _cardViewAttactment;
}

#define CARD_AREA_RATIO 0.7

- (CGSize) cardSize {
    if (!_cardSize.height) {
        CGFloat totalArea = self.BoardView.bounds.size.width*self.BoardView.bounds.size.height;
        
        CGFloat singleCardArea = totalArea*CARD_AREA_RATIO/self.numberOfCards;
        
        CGSize cardSize = {sqrt(singleCardArea/1.5), sqrt(singleCardArea*1.5)};
        return cardSize;
    }
    return _cardSize;
}

- (CGFloat) gridAspectRatio {
    if (!_gridAspectRatio) {
        _gridAspectRatio = .1;
    }
    return _gridAspectRatio;
}

#define MIN_BORDER_VALUE 5.0

- (Grid *)grid {
    if (!_grid) {
        _grid = [[Grid alloc] init];
        _grid.size = self.BoardView.bounds.size;
        _grid.cellAspectRatio = self.gridAspectRatio;
        _grid.minimumNumberOfCells = self.numberOfCards;
        _grid.minCellWidth = [self gridSize].width + MIN_BORDER_VALUE;
        _grid.minCellHeight = [self gridSize].height + MIN_BORDER_VALUE;
        //_grid.minCellHeight = [self gridSize].height;
        if (!_grid.inputsAreValid) _grid = nil;
    }
    return _grid;
}

- (void)setAspectRatioAndCardSize {
    if (self.BoardView.bounds.size.width > 0){
        if (!self.grid) {
            if (self.gridAspectRatio < 2)
                self.gridAspectRatio += .01;
            else {
                CGFloat newWidth = self.cardSize.width*0.95;
                CGFloat newHeight = self.cardSize.height*0.95;
                self.cardSize = CGSizeMake(newWidth, newHeight);
                self.gridAspectRatio = 0.1;
            }
            
            [self setAspectRatioAndCardSize];
        }
    }
}

#pragma mark - Abstract functions

- (Deck *)createDeck {
    return nil;
}

- (NSUInteger) setGameMode {
    return 0;
}

- (UIView *)createView:(CGRect)frame {
    return nil;
}

- (CGSize)gridSize {
    return CGSizeZero;
}

- (NSUInteger)startCardsOnBoard {
    return 0;
}

- (void) cardViewsAreMatched:(NSArray *)matchedCardSet { }

- (BOOL) checkIfMatchesLeft {
    return false;
}

#pragma mark - UIButton

- (NSAttributedString *)matchResultText:(NSAttributedString *)cardText lastClicked:(NSUInteger)index{
    // check if enough cards are selected
    if ([self.selectedCardIndices count] > self.game.mode+1) {
        
        // add this play to record of plays
        [self.playRecord addObject:cardText];
        // set slider to the newest card
        
        self.selectedCardIndices = nil;
        // if the score is more than 0 its a match, else not matched
        if (self.game.returnMatchScore > 0) {
            [self.scoreRecord addObject:[NSString stringWithFormat:@"+%ld", self.game.returnMatchScore]];
            NSString * end = [NSString stringWithFormat:@" +%ld", self.game.returnMatchScore];
            NSMutableAttributedString * resultText = [[NSMutableAttributedString alloc] initWithString:end attributes: @{NSForegroundColorAttributeName:[UIColor blackColor]}];
            [resultText insertAttributedString:cardText atIndex:0];
            return resultText;
        }
        else if (self.game.returnMatchScore < 0) {
            [self.scoreRecord addObject:[NSString stringWithFormat:@"%ld", self.game.returnMatchScore]];
            [self.selectedCardIndices addObject:@(index)];
            NSString * end = [NSString stringWithFormat:@" %ld", self.game.returnMatchScore];
            NSMutableAttributedString * resultText = [[NSMutableAttributedString alloc] initWithString:end attributes: @{NSForegroundColorAttributeName:[UIColor blackColor]}];
            [resultText insertAttributedString:cardText atIndex:0];
            return resultText;
        }
    }
    return cardText;
}

#pragma mark - Gestures

- (IBAction)restartButton:(UIBarButtonItem *)sender {
    self.game = nil;
    self.grid = nil;
    self.cardSize = CGSizeZero;
    self.numberOfCards = [self startCardsOnBoard];
    [self setAspectRatioAndCardSize];
    [self.selectedCardIndices removeAllObjects];
    [self.cardViewCollection removeAllObjects];
    [self.playRecord removeAllObjects];
    [self.scoreRecord removeAllObjects];
    [self.removedCards removeAllObjects];
    [[self.BoardView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //self.gameMode.enabled = YES;
    //self.game.mode = self.gameMode.selectedSegmentIndex;
    [self setUpBoardWithCards];
    self.displayMove.text = @"Pick a card!";
}

- (BOOL)fingerOnPile:(CGPoint)fingerPosition {
    CGRect bounds;
    for (CardView *cardView in self.cardViewCollection) {
        if (![self.removedCards containsObject:cardView]){
            bounds = cardView.frame;
            break;
        }
    }
    return ((fingerPosition.x > bounds.origin.x) &&
            (fingerPosition.y > bounds.origin.y) &&
            (fingerPosition.x < bounds.origin.x + bounds.size.width) &&
            (fingerPosition.y < bounds.origin.y + bounds.size.height));
}


- (IBAction)TapCardOnBoard:(UITapGestureRecognizer *)sender {

    CGPoint tapPoint = [sender locationInView:self.BoardView];
    
    if (self.piled) {
        if (![self fingerOnPile:tapPoint]) return;
        [self updateCardPositions];
        self.piled = false;
    }
    
    else {
        NSInteger chosenViewIndex = [self cardIndexAtPosition:tapPoint];
        if (chosenViewIndex >= 0 &&
            chosenViewIndex < self.numberOfCards &&
            ![self.removedCards containsObject:self.cardViewCollection[chosenViewIndex]]) {
            [self.game chooseCardAtIndex:chosenViewIndex];
            // mark the selected card.
            if (![self.selectedCardIndices containsObject:@(chosenViewIndex)])
                [self.selectedCardIndices addObject:@(chosenViewIndex)];
            else [self.selectedCardIndices removeObject:@(chosenViewIndex)];
            
            NSMutableAttributedString * cardLabel = [[NSMutableAttributedString alloc]init] ;
            for (NSNumber *index in self.selectedCardIndices) {
                Card *currCard =[self.game cardAtIndex:[index integerValue]];
                [cardLabel appendAttributedString:currCard.contents];
            }
            self.displayMove.attributedText = [self matchResultText:cardLabel lastClicked:chosenViewIndex];
            
            [self updateViewUI];
        }
    }
}

- (void)attachCardsToAnchorPoint:(CGPoint)anchorPoint {
    for (UIView *cardView in self.cardViewCollection) {
        if (![self.removedCards containsObject:cardView]) {
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:cardView attachedToAnchor:anchorPoint];
            attachment.frequency = 0.0;
            [self.cardViewAttactment addObject:attachment];
            [self.animator addBehavior:attachment];
        }
    }
}

- (IBAction)pinchCardViewsIntoPile:(UIPinchGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.BoardView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachCardsToAnchorPoint:gesturePoint];
        self.pinchRatio = 1.0f;
    }
    if (sender.state == UIGestureRecognizerStateChanged) {
        self.pinchRatio *= sender.scale;
        if (self.pinchRatio > 1.0f) {
            self.pinchRatio /= sender.scale;
        }
        else {
            for (UIAttachmentBehavior *attachment in self.cardViewAttactment){
                attachment.anchorPoint = gesturePoint;
                attachment.length *= sender.scale;
            }
        }
        sender.scale = 1.0;
    }
    if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeAllBehaviors];
        [self.cardViewAttactment removeAllObjects];
        for (CardView *cardView in self.cardViewCollection) {
            if (self.pinchRatio < 0.5) {
                self.piled = true;
                [UIView animateWithDuration:0.8f
                                      delay:0
                     usingSpringWithDamping:0.5f
                      initialSpringVelocity:sender.velocity
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{cardView.center = gesturePoint;}
                                 completion:nil];
            }
            else {
                [self updateCardPositions];
                self.piled = false;
            }
        }
    }
}

- (IBAction)moveCardPile:(UIPanGestureRecognizer *)sender {
    if (!self.piled) return;
    
    CGPoint gesturePoint = [sender locationInView:self.BoardView];

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachCardsToAnchorPoint:gesturePoint];
        if (![self fingerOnPile:gesturePoint]) return;
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        for (UIAttachmentBehavior *attachment in self.cardViewAttactment) {
            attachment.anchorPoint = gesturePoint;
        }
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeAllBehaviors];
        [self.cardViewAttactment removeAllObjects];
    }
}


- (IBAction)add3Cards:(id)sender {
    self.game.hasMatch = [self checkIfMatchesLeft];
    if (!self.game.outOfCards) {
        self.numberOfCards+=3;
        if((self.numberOfCards) > (self.grid.rowCount*self.grid.columnCount)) {
            [self updateCardPositions];
        }
    }
    for (int i = 0; i < 3; i++) {
        [self addACard];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    addCardDelay = 0.0;
}

- (void)addACard {
    [self.game drawAdditionalCard];
    if(!self.game.outOfCards) {
        [self drawCardAtIndex:[self.cardViewCollection count]];
    }
}

#pragma mark - updateUI

- (void) setUpBoardWithCards {
    self.tapInBoardGesture.enabled = false;
    for (int index = 0; index < self.numberOfCards; index++){
        [self drawCardAtIndex:index];
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    addCardDelay = 0.0;
}

- (void) drawCardAtIndex:(NSUInteger)index {
    NSInteger col = index%self.grid.columnCount;
    NSInteger row = index/self.grid.columnCount;
    [self drawCardWithCenter:[self.grid centerOfCellAtRow:row inColumn:col]];
    CardView * view = self.cardViewCollection[index];
    view.card = [self.game cardAtIndex:index];
}

- (void) drawCardWithCenter:(CGPoint)center {
    CGRect cardFrame;
    cardFrame.origin = CGPointMake(center.x-[self gridSize].width/2, center.y-[self gridSize].height/2);
    cardFrame.size = self.gridSize;
    CardView *cardView = [self createView:cardFrame];
    cardView.opaque = nil;
    [self.cardViewCollection addObject:cardView];
    [self addCardViewAnimated:cardView];
}

- (NSInteger) cardIndexAtPosition:(CGPoint)tapPoint {
    NSInteger index = -1;
    if(tapPoint.x > 0 && tapPoint.x < self.BoardView.bounds.size.width && tapPoint.y > 0 && tapPoint.y < self.BoardView.bounds.size.height) {
        int col = tapPoint.x/self.grid.cellSize.width;
        int row = tapPoint.y/self.grid.cellSize.height;
        index = row * self.grid.columnCount + col;
    }
    return index;
}

- (void)updateCardPositions {
    self.cardSize = CGSizeZero;
    self.grid = nil;
    [self setAspectRatioAndCardSize];
        
    for (int index = 0; index < [self.cardViewCollection count]; index++){
        [self updateCardAtIndex:index];
    }
}

- (void) updateCardAtIndex:(NSUInteger)index {
    NSInteger col = index%self.grid.columnCount;
    NSInteger row = index/self.grid.columnCount;
    CardView * cardView = self.cardViewCollection[index];
    CGRect newCardFrame;
    CGPoint center = [self.grid centerOfCellAtRow:row inColumn:col];
    newCardFrame.origin = CGPointMake(center.x-[self gridSize].width/2, center.y-[self gridSize].height/2);
    newCardFrame.size = [self gridSize];
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{cardView.frame = newCardFrame; }
                     completion:nil];
}

- (void)updateViewUI {
    // look through every item in cardbutton
    NSMutableArray *matchedCardSet = [[NSMutableArray alloc] init];
    for (CardView *cardView in self.cardViewCollection) {
        if(![self.removedCards containsObject:cardView]) {
            NSInteger cardViewIndex = [self.cardViewCollection indexOfObject:cardView];
            Card *card = [self.game cardAtIndex:cardViewIndex];
            
            BOOL faceUp = (card.isChosen) ? true:false;
            [self flipCardAnimated:cardView isFaceUp:faceUp];
            if (card.isMatched) {
                [matchedCardSet addObject:cardView];
                [self removeCardViewAnimated:cardView];
            }
        }
    }
    [self cardViewsAreMatched:matchedCardSet];
    if ([self.cardViewCollection count] != self.numberOfCards) {
        self.numberOfCards = [self.cardViewCollection count];
        [self updateCardPositions];
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
    self.displayMove.alpha = 1;
}

#pragma mark - animation

static float addCardDelay = 0.0f;

- (void) addCardViewAnimated:(CardView *)cardView {
    CGPoint finishCenter = cardView.center;
    CGFloat incomingAngle = (arc4random()%(int)(2*M_PI*100))/100.0f;
    CGFloat travelDistance = self.BoardView.bounds.size.height+self.BoardView.bounds.size.width;
    CGFloat x = self.BoardView.center.x + travelDistance*cos(incomingAngle);
    CGFloat y = self.BoardView.center.y + travelDistance*sin(incomingAngle);
    cardView.center = CGPointMake(x, y);
    
    [self.BoardView addSubview:cardView];
    [UIView animateWithDuration:0.4f
                          delay:addCardDelay
                        options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseOut)
                     animations:^ {
                         cardView.center = finishCenter;
                     }
                     completion:^(BOOL finished){
                         if (finished && addCardDelay == 0.0f) {
                             self.tapInBoardGesture.enabled = true;
                         }
                     }];
    addCardDelay += 0.075;
}

- (void) removeCardViewAnimated:(CardView *)cardView {
    CGFloat outgoingAngle = (arc4random()%(int)(2*M_PI*100))/100.0f;
    CGFloat travelDistance = self.BoardView.bounds.size.height+self.BoardView.bounds.size.width;
    CGFloat x = self.BoardView.center.x + travelDistance*cos(outgoingAngle);
    CGFloat y = self.BoardView.center.y + travelDistance*sin(outgoingAngle);
    CGPoint destination = CGPointMake(x, y);
    [UIView animateWithDuration:0.4f
                          delay:0.1f
                        options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionCurveEaseIn)
                     animations:^{ cardView.center = destination; }
                     completion:^(BOOL finished){
                             [cardView removeFromSuperview];
                             [self.removedCards addObject:cardView];
                     }];
}

- (void) flipCardAnimated:(CardView *)cardView isFaceUp:(BOOL)faceUp{
    if (cardView.faceUp != faceUp) {
        [UIView transitionWithView:cardView
                          duration:0.3f
                           options:(UIViewAnimationOptionBeginFromCurrentState|UIViewAnimationOptionTransitionFlipFromLeft)
                        animations:^{cardView.faceUp = faceUp;}
                        completion:nil];
    }
};


@end




//- (NSAttributedString *)titleForCard:(Card *)card {
//    return card.isChosen ? card.contents: nil;
//}
//
//- (UIImage *)backgroundImageForCard:(Card *)card {
//    return [UIImage imageNamed:card.isChosen ? @"cardFront" : @"cardBack"];
//}
//
//
//- (IBAction)touchCardButton:(UIButton *)sender {
//    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
//    [self.game chooseCardAtIndex:chosenButtonIndex];
//
//    // mark the selected card.
//    if (![self.selectedCardIndices containsObject:@(chosenButtonIndex)])
//        [self.selectedCardIndices addObject:@(chosenButtonIndex)];
//    else [self.selectedCardIndices removeObject:@(chosenButtonIndex)];
//
//    NSMutableAttributedString * cardLabel = [[NSMutableAttributedString alloc]init] ;
//    for (NSNumber *index in self.selectedCardIndices) {
//        Card *currCard =[self.game cardAtIndex:[index integerValue]];
//        [cardLabel appendAttributedString:currCard.contents];
//    }
//    self.displayMove.attributedText = [self matchResultText:cardLabel lastClicked:chosenButtonIndex];
//
//    [self updateUI];
//}
//
//- (void)updateUI {
//    // look through every item in cardbutton
//    for (UIButton *cardButton in self.cardButtons) {
//        NSUInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
//        Card *card = [self.game cardAtIndex:cardButtonIndex];
//
//        [cardButton setAttributedTitle:[self titleForCard:card] forState:UIControlStateNormal];
//        [cardButton setBackgroundImage:[self backgroundImageForCard:card] forState:UIControlStateNormal];
//
//        cardButton.enabled = !card.isMatched;
//    }
//
//    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", self.game.score];
//    self.displayMove.alpha = 1;
//
//}
//- (IBAction)chooseGameMode:(UISegmentedControl *)sender {
//    self.game.mode = sender.selectedSegmentIndex;
//
//}
