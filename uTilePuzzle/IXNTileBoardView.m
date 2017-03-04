//
//  IXNTileBoardView.m
//  IXNTilePuzzle
//
//  Created by Ikhsan Assaat on 1/20/14.
//  Copyright (c) 2014 Ikhsan Assaat. All rights reserved.
//

#import "IXNTileBoardView.h"
#import "IXNTileBoard.h"
#import "UIImage+Resize.h"

@interface IXNTileBoardView()

@property (nonatomic) CGFloat tileWidth;
@property (nonatomic) CGFloat tileHeight;
@property (nonatomic, getter = isGestureRecognized) BOOL gestureRecognized;
@property (strong, nonatomic) IXNTileBoard *board;
@property (strong, nonatomic) NSMutableArray *tiles;


@property (strong, nonatomic) UIImageViewFocusEnviroment *draggedTile;
@property (nonatomic) NSInteger draggedDirection;

@property (nonatomic) CGPoint zeroCoordinate;

@end

@implementation IXNTileBoardView

#pragma mark - Initialization Methods

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    return self;
}

- (instancetype)initWithImage:(UIImage *)image size:(NSInteger)size frame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    [self playWithImage:image size:size];
    
    // focusable
    [self setAlpha: 1.0];
    [self setHidden: NO];
    [self setUserInteractionEnabled: YES];
    
    return self;
}

- (void)playWithImage:(UIImage *)image size:(NSInteger)size
{
    // make the board model
    self.board = [[IXNTileBoard alloc] initWithSize:size];
    
    // slice the images
    UIImage *resizedImage = [image resizedImageWithSize:self.frame.size];
    self.tileWidth = resizedImage.size.width / size;
    self.tileHeight = resizedImage.size.height / size;
    self.tiles = [self sliceImageToAnArray:resizedImage];
    
    // recognize gestures
    if (!self.isGestureRecognized) [self addGestures];
}

- (NSMutableArray *)sliceImageToAnArray:(UIImage *)image
{
    NSMutableArray *slices = [NSMutableArray array];
    
    for (int i = 0; i < self.board.size; i++)
    {
        for (int j = 0; j < self.board.size; j++)
        {
            if (i == self.board.size && j == self.board.size) continue;
            
            CGRect f = CGRectMake(self.tileWidth * j, self.tileHeight * i, self.tileWidth, self.tileHeight);
            UIImageViewFocusEnviroment *tileImageView = [self tileImageViewWithImage:image frame:f];
            
            [slices addObject:tileImageView];
            
            CGPoint pieceCoord = [self coordinateFromPoint: f.origin];
            if ([[self.board tileAtCoordinate:pieceCoord] isEqualToNumber:@0]) self.zeroCoordinate = pieceCoord;
        }
    }
    
    return slices;
}

- (UIImageViewFocusEnviroment *)tileImageViewWithImage:(UIImage *)image frame:(CGRect)frame
{
    UIImage *tileImage = [image cropImageFromFrame:frame];
    
    UIImageViewFocusEnviroment *tileImageView = [[UIImageViewFocusEnviroment alloc] initWithImage:tileImage];
    [tileImageView.layer setShadowColor:[UIColor blackColor].CGColor];
    [tileImageView.layer setShadowOpacity:0.65];
    [tileImageView.layer setShadowRadius:1.5];
    [tileImageView.layer setShadowOffset:CGSizeMake(1.5, 1.5)];
    [tileImageView.layer setShadowPath:[[UIBezierPath bezierPathWithRect:tileImageView.layer.bounds] CGPath]];
    
    [tileImageView setUserInteractionEnabled: YES];
    [tileImageView setHighlighted: YES];
    
    return tileImageView;
}

- (void)addGestures
{
    
    
    UISwipeGestureRecognizer *swipeGestureUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipeGestureUp.direction = UISwipeGestureRecognizerDirectionUp;
    [self addGestureRecognizer: swipeGestureUp];
    
    UISwipeGestureRecognizer *swipeGestureDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipeGestureDown.direction = UISwipeGestureRecognizerDirectionDown;
    [self addGestureRecognizer: swipeGestureDown];
    
    UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipeGestureLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [self addGestureRecognizer: swipeGestureLeft];
    
    UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeHandler:)];
    swipeGestureRight.direction = UISwipeGestureRecognizerDirectionRight;
    [self addGestureRecognizer: swipeGestureRight];
}


#pragma mark - Public Methods for playing puzzle

- (void)shuffleTimes:(NSInteger)times
{
    [self.board shuffle:times];
    [self drawTiles];
}

- (void)drawTiles
{
    for (UIView *view in self.subviews)
        [view removeFromSuperview];
    
    [self traverseTilesWithBlock:^(UIImageViewFocusEnviroment *tileImageView, int i, int j) {
        CGRect frame = CGRectMake(self.tileWidth*(i-1), self.tileHeight*(j-1), self.tileWidth, self.tileHeight);
        tileImageView.frame = frame;
        [self addSubview:tileImageView];
    }];
}

- (void)orderingTiles
{
    [self traverseTilesWithBlock:^(UIImageViewFocusEnviroment *tileImageView, int i, int j) {
        [self bringSubviewToFront:tileImageView];
    }];
}

- (void)traverseTilesWithBlock:(void (^)(UIImageViewFocusEnviroment *tileImageView, int i, int j))block
{
    for (int j = 1; j <= self.board.size; j++) {
        for (int i = 1; i <= self.board.size; i++) {
            NSNumber *value = [self.board tileAtCoordinate:CGPointMake(i, j)];
            
            if ([value intValue] == 0){
                self.zeroCoordinate = CGPointMake(i, j);
                continue;
            }
            
            UIImageViewFocusEnviroment *tileImageView = [self.tiles objectAtIndex:[value intValue]-1];
            block(tileImageView, i, j);
        }
    }
}

#pragma mark - Movers Methods

- (UIImageViewFocusEnviroment *)tileViewAtPosition:(CGPoint)position
{
    UIImageViewFocusEnviroment *tileView;
    
    for (UIImageViewFocusEnviroment *enumTile in self.tiles)
    {
        if (CGRectContainsPoint(enumTile.frame, position))
        {
            tileView = enumTile;
            break;
        }
    }
    
    return tileView;
}

- (void)tileWasMoved
{
    [self orderingTiles];
    
    if ([self.board isAllTilesCorrect])
        if (self.delegate) [self.delegate tileBoardViewDidFinished:self];
}

- (CGPoint)coordinateFromPoint:(CGPoint)point
{
    return CGPointMake((int)(point.x / self.tileWidth) + 1, (int)(point.y / self.tileHeight) + 1);
}

#pragma mark - Direction Tap Moviment Pattern

- (CGPoint) mappingTapTileFromDirection:(UIPress *)press {
    
    CGPoint pressedTargetTile = self.zeroCoordinate;
    
    switch (press.type) {
        case 0: // UIPressTypeUpArrow:
            pressedTargetTile.y = self.zeroCoordinate.y + 1;
            break;
        case 1: //UIPressTypeDownArrow:
            pressedTargetTile.y = self.zeroCoordinate.y - 1;
            break;
        case 2: //UIPressTypeLeftArrow:
            pressedTargetTile.x = self.zeroCoordinate.x + 1;
            break;
        case 3: //UIPressTypeRightArrow:
            pressedTargetTile.x = self.zeroCoordinate.x - 1;
            break;
        default:
            break;
    }
    
    return pressedTargetTile;
}

- (void)pressesBegan:(NSSet<UIPress *> *)presses withEvent:(UIPressesEvent *)event
{
    for (UIPress *press in presses)
    {
        
        CGPoint targetTile = [self mappingTapTileFromDirection: press];

        if (targetTile.x > 3.5 || targetTile.y > 3.5 || targetTile.x < 1 || targetTile.y < 1)
            continue;
        
        if (![self.board canMoveTile: targetTile]) return;
        
        CGPoint p = [self.board shouldMove:YES tileAtCoordinate:targetTile];
        
        CGPoint tilePosition = CGPointMake(self.tileWidth * (targetTile.x - 1), self.tileHeight * (targetTile.y - 1));
        
        __block UIImageViewFocusEnviroment *tileView = [self tileViewAtPosition:tilePosition];
        
        CGRect newFrame = CGRectMake(self.tileWidth * (p.x - 1), self.tileHeight * (p.y - 1), self.tileWidth, self.tileHeight);
        [UIView animateWithDuration:.1 animations:^{
            tileView.frame = newFrame;
        } completion:^(BOOL finished) {
            if (self.delegate) [self.delegate tileBoardView:self tileDidMove:tilePosition];
            [self tileWasMoved];
        }];
        
        self.zeroCoordinate = targetTile;
    }

}

- (void) swipeHandler:(UISwipeGestureRecognizer *)swipeRecognizer {
    
    NSLog(@"oleoleole");
    
    CGPoint targetPoint = [self mappingSwipeTileFromSwipeDirection:swipeRecognizer.direction];
    
    if (targetPoint.x > 3.5 || targetPoint.x < 1 || targetPoint.y > 3.5 || targetPoint.y < 1)
        return;
    
    if (![self.board canMoveTile: targetPoint]) return;
    
    CGPoint p = [self.board shouldMove:YES tileAtCoordinate:targetPoint];
    
    CGPoint tilePosition = CGPointMake(self.tileWidth * (targetPoint.x - 1), self.tileHeight * (targetPoint.y - 1));
    
    __block UIImageViewFocusEnviroment *tileView = [self tileViewAtPosition:tilePosition];
    
    CGRect newFrame = CGRectMake(self.tileWidth * (p.x - 1), self.tileHeight * (p.y - 1), self.tileWidth, self.tileHeight);
    [UIView animateWithDuration:.1 animations:^{
        tileView.frame = newFrame;
    } completion:^(BOOL finished) {
        if (self.delegate) [self.delegate tileBoardView:self tileDidMove:tilePosition];
        [self tileWasMoved];
    }];
    self.zeroCoordinate = targetPoint;
    
}

- (CGPoint) mappingSwipeTileFromSwipeDirection:(UISwipeGestureRecognizerDirection)direction {
    
    CGPoint swipeTargetTile = self.zeroCoordinate;
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            swipeTargetTile.y = self.zeroCoordinate.y + 1;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            swipeTargetTile.y = self.zeroCoordinate.y - 1;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            swipeTargetTile.x = self.zeroCoordinate.x + 1;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            swipeTargetTile.x = self.zeroCoordinate.x - 1;
            break;
        default:
            break;
    }
    
    return swipeTargetTile;
}

@end
