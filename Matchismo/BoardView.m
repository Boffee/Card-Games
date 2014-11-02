//
//  BoardView.m
//  Matchismo
//
//  Created by Brian Li on 8/25/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "BoardView.h"

@interface BoardView()

@property (strong, nonatomic)UIDynamicAnimator *animator;
@property (strong, nonatomic)NSMutableArray *cardViewAttactment;
@property (nonatomic)float pinchRatio;

@end

@implementation BoardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (BOOL)fingerOnPile:(CGPoint)fingerPosition {
    CGRect bounds = ((UIView*)self.subviews[0]).frame;
    return ((fingerPosition.x > bounds.origin.x) &&
            (fingerPosition.y > bounds.origin.y) &&
            (fingerPosition.x < bounds.origin.x + bounds.size.width) &&
            (fingerPosition.y < bounds.origin.y + bounds.size.height));
}


- (void)attachCardsToAnchorPoint:(CGPoint)anchorPoint {
    for (UIView *view in self.subviews) {
            UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view attachedToAnchor:anchorPoint];
            attachment.frequency = 0.0;
            [self.cardViewAttactment addObject:attachment];
            [self.animator addBehavior:attachment];
    }
}

- (IBAction)pinchCardViewsIntoPile:(UIPinchGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self];
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
        for (UIView *view in self.subviews) {
            if (self.pinchRatio < 0.5) {
                self.piled = true;
                [UIView animateWithDuration:0.8f
                                      delay:0
                     usingSpringWithDamping:0.5f
                      initialSpringVelocity:sender.velocity
                                    options:UIViewAnimationOptionBeginFromCurrentState
                                 animations:^{view.center = gesturePoint;}
                                 completion:nil];
            }
            else {
                //[self updateCardPositions];
                self.piled = false;
            }
        }
    }
}

- (IBAction)moveCardPile:(UIPanGestureRecognizer *)sender {
    if (!self.piled) return;
    
    CGPoint gesturePoint = [sender locationInView:self];
    
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


@end
