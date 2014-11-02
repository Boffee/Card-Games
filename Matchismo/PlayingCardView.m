//
//  PlayingCardView.m
//  Matchismo
//
//  Created by Brian Li on 8/11/14.
//  Copyright (c) 2014 Brian Li. All rights reserved.
//

#import "PlayingCardView.h"

@interface PlayingCardView()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation PlayingCardView

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90

- (CGFloat) faceCardScaleFactor {
    if(!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void) setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor {
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void) setSuit:(NSString *)suit {
    _suit = suit;
    [self setNeedsDisplay];
}

- (void) setRank:(NSUInteger)rank {
    _rank = rank;
    [self setNeedsDisplay];
}

- (UIColor *) color {
    if ([self.suit isEqual:@"♠︎"] || [self.suit isEqual:@"♣︎"]) {
        _color = [UIColor blackColor];
    }
    else {
        _color = [UIColor redColor];
    }
    return _color;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (NSString *) rankAsString {
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"][self.rank];
}

- (void) drawContent {
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    [roundedRect fill];
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    if (self.faceUp) {
        if (self.card) {
            PlayingCard *card = (PlayingCard *)self.card;
            self.rank = card.rank;
            self.suit = card.suit;
            [self drawCenter];
            [self drawCorners];
        }
    }
    else {
        [[UIImage imageNamed:@"cardBack"] drawInRect:self.bounds];
    }
}


- (void) drawCorners {

    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    
    UIFont *cornerFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    cornerFont = [cornerFont fontWithSize:cornerFont.pointSize * [self scaleFactor]*1.25];
    
    NSMutableAttributedString * cornerText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n%@", [self rankAsString], self.suit] attributes: @{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName:cornerFont, NSForegroundColorAttributeName:self.color}];
    
    CGRect textBounds;
    textBounds.origin = CGPointMake([self cornerOffset],[self cornerOffset]);
    textBounds.size = cornerText.size;
    [cornerText drawInRect:textBounds];
    
    [self crossMirror];
    [cornerText drawInRect:textBounds];
}

-(void) crossMirror {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, self.bounds.size.width, self.bounds.size.height);
    CGContextRotateCTM(context, M_PI);
}


- (void) drawCenter {
    UIImage * faceImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@",[self rankAsString], self.suit]];
    if (faceImage) {
        CGRect imageRect = CGRectInset(self.bounds,
                                       self.bounds.size.width * (1.0 - self.faceCardScaleFactor),
                                       self.bounds.size.height * (1.0 - self.faceCardScaleFactor));
        [faceImage drawInRect:imageRect];
    }
    else {
        [self drawPips];
    }
}

- (void) drawPips {
    
    UIFont *pipFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    pipFont = [pipFont fontWithSize:pipFont.pointSize * [self scaleFactor]*1.5];

    NSMutableAttributedString * pip = [[NSMutableAttributedString alloc] initWithString:self.suit attributes:@{NSForegroundColorAttributeName:self.color, NSFontAttributeName:pipFont}];
    
    CGRect pipsRect = CGRectInset(self.bounds,
                                 self.bounds.size.width * (1.0 - self.faceCardScaleFactor)*2,
                                 self.bounds.size.width * (1.0 - self.faceCardScaleFactor)*2);
    
    // only make top half, mirror bottom half
    CGFloat centerX = self.bounds.size.width/2.0;
    CGFloat centerY = self.bounds.size.height/2.0;
    CGFloat topY = pipsRect.origin.y + [self cornerOffset] + pip.size.height/2.0;
    CGFloat leftX = pipsRect.origin.x + [self cornerOffset] + pip.size.width/2;
    CGFloat rightX = pipsRect.origin.x + pipsRect.size.width - [self cornerOffset] - pip.size.width/2.0;
    CGFloat upCenterY = centerY - (centerY-topY)/3.0;
    
    if (self.rank == 1) {
        pipFont = [pipFont fontWithSize:pipFont.pointSize * [self scaleFactor]*4];
        [pip setAttributes:@{NSForegroundColorAttributeName:self.color,NSFontAttributeName:pipFont} range:NSMakeRange(0, [pip length])];
        [self drawCoordinatedPip:pip atX:centerX atY:centerY];
    }

    if (self.rank == 2 || self.rank == 3) {
        [self drawCoordinatedPip:pip atX:centerX atY:topY];
    }
    
    if (self.rank == 3 || self.rank == 5 || self.rank == 9) {
        [self drawCoordinatedPip:pip atX:centerX atY:centerY];
    }
    
    if (!(self.rank == 1 || self.rank == 2 || self.rank == 3)) {
        [self drawCoordinatedPip:pip atX:rightX atY:topY];
        [self drawCoordinatedPip:pip atX:leftX atY:topY];
    }
    
    if (self.rank == 6 || self.rank == 7 || self.rank == 8) {
        [self drawCoordinatedPip:pip atX:rightX atY:centerY];
        [self drawCoordinatedPip:pip atX:leftX atY:centerY];
    }
    
    if (self.rank == 9 || self.rank == 10) {
        [self drawCoordinatedPip:pip atX:rightX atY:upCenterY];
        [self drawCoordinatedPip:pip atX:leftX atY:upCenterY];
    }
    
    if (self.rank == 10) {
        [self drawCoordinatedPip:pip atX:centerX atY:(topY + upCenterY)/2.0];
    }
    if (self.rank == 7 || self.rank == 8) {
        [self drawCoordinatedPip:pip atX:centerX atY:(topY + centerY)/2.0];
    }
}

- (void) drawCoordinatedPip:(NSAttributedString *)pip atX:(CGFloat)x atY:(CGFloat)y {
    CGRect pipBound;
    pipBound.origin = CGPointMake(x-pip.size.width/2, y-pip.size.height/2);
    pipBound.size = pip.size;

    if (!(y == self.bounds.size.height/2.0 || (x == self.bounds.size.width/2.0 &&self.rank == 7))) {
        [pip drawInRect:pipBound];
        [self crossMirror];
        [pip drawInRect:pipBound];
    }
    else if ((self.rank == 3 || self.rank == 5) && y == self.bounds.size.height/2.0) {
        [pip drawInRect:pipBound];
    }
    else [pip drawInRect:pipBound];

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

@end
