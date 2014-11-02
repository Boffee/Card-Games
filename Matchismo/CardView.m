//
//  CardView.m
//  Matchismo
//
//  Created by Brian Li on 8/11/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "CardView.h"

@implementation CardView

#pragma mark - Properties

- (void)setFaceUp:(BOOL)faceUp {
    _faceUp = faceUp;
    [self setNeedsDisplay];
}
- (void)setCard:(Card *)card {
    _card = card;
    [self setNeedsDisplay];
}
- (void)setInASet:(BOOL)inASet {
    _inASet = inASet;
    [self setNeedsDisplay];
}


# pragma mark - Draw

#define CARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)scaleFactor { return self.bounds.size.height/CARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self scaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius]/3.0; }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawContent];
    [self drawHint];
}

- (void)drawContent {}; //abstract method

- (void)drawHint {
    if (self.inASet) {
        
        UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self scaleFactor]*1.5];
        
        NSAttributedString *star = [[NSAttributedString alloc] initWithString:@"★" attributes:@{NSForegroundColorAttributeName:[UIColor redColor], NSFontAttributeName:cornerFont}];
        
        CGRect bound;
        bound.origin = CGPointMake(self.bounds.origin.x+self.bounds.size.width-[self cornerOffset]-star.size.width, self.bounds.origin.y+[self cornerOffset]);

        bound.size = star.size;
        [star drawInRect:bound];
    }
}

#pragma mark - Initialization

- (void) setup {
    self.backgroundColor = nil;
    self.opaque = nil;
    self.contentMode = UIViewContentModeRedraw;
}

- (void) awakeFromNib {
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

#pragma mark - Gesture


@end
