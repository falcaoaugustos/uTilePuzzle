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

typedef enum {
    DirectionUp = 1,
    DirectionRight,
    DirectionDown,
    DirectionLeft
} Direction;

@interface IXNTileBoardView()

@property (nonatomic) CGFloat tileWidth;
@property (nonatomic) CGFloat tileHeight;
@property (nonatomic, getter = isGestureRecognized) BOOL gestureRecognized;
@property (strong, nonatomic) IXNTileBoard *board;
@property (strong, nonatomic) NSMutableArray *tiles;

@property (strong, nonatomic) UIImageViewFocusEnviroment *draggedTile;
@property (nonatomic) NSInteger draggedDirection;

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
    
    // Focusable
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMove:)];
    [tapGesture setNumberOfTapsRequired:1];
    
    for (int i = 0; i < self.board.size; i++)
    {
        for (int j = 0; j < self.board.size; j++)
        {
            if (i == self.board.size && j == self.board.size) continue;
            
            CGRect f = CGRectMake(self.tileWidth * j, self.tileHeight * i, self.tileWidth, self.tileHeight);
            UIImageViewFocusEnviroment *tileImageView = [self tileImageViewWithImage:image frame:f];
            //[tileImageView addGestureRecognizer:tapGesture];
            
            [slices addObject:tileImageView];
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
    [tileImageView setAdjustsImageWhenAncestorFocused: YES];
    
    return tileImageView;
}

- (void)addGestures
{
    // add panning recognizer
    UIPanGestureRecognizer *dragGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragging:)];
    //[dragGesture setMaximumNumberOfTouches:1];
    //[dragGesture setMinimumNumberOfTouches:1];
    [self addGestureRecognizer:dragGesture];
    
    // add tapping recognizer
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMove:)];
    [tapGesture setNumberOfTapsRequired:1];
    [self addGestureRecognizer:tapGesture];
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
            
            if ([value intValue] == 0) continue;
            
            UIImageViewFocusEnviroment *tileImageView = [self.tiles objectAtIndex:[value intValue]-1];
            block(tileImageView, i, j);
        }
    }
}

#pragma mark - Movers Methods

- (void)moveTileAtPosition:(CGPoint)position
{
    NSLog(@"move?");
    __block UIImageViewFocusEnviroment *tileView = [self tileViewAtPosition:position];
    NSLog(@"%@", tileView);
    NSLog([self.board canMoveTile: position] ? @"YES" : @"NO");
    if (![self.board canMoveTile:position] || !tileView) return;
    
    NSLog(@"moveMesmo?");
    
    CGPoint p = [self.board shouldMove:YES tileAtCoordinate:position];
    CGRect newFrame = CGRectMake(self.tileWidth * (p.x - 1), self.tileHeight * (p.y - 1), self.tileWidth, self.tileHeight);
    [UIView animateWithDuration:.1 animations:^{
        tileView.frame = newFrame;
    } completion:^(BOOL finished) {
        if (self.delegate) [self.delegate tileBoardView:self tileDidMove:position];
        [self tileWasMoved];
    }];
    
}

- (UIImageViewFocusEnviroment *)tileViewAtPosition:(CGPoint)position
{
    UIImageViewFocusEnviroment *tileView;
    //CGRect checkRect = CGRectMake((position.x - 1) * self.tileWidth + 1, (position.y - 1) * self.tileHeight + 1, 1.0, 1.0);
    NSLog(@"%.0f %.0f", position.x, position.y);
    CGRect checkRect = CGRectMake(position.x, position.y, 1.0, 1.0);
    for (UIImageViewFocusEnviroment *enumTile in self.tiles)
    {
        if  (CGRectIntersectsRect(enumTile.frame, checkRect))
        {
            NSLog(@"achou");
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

#pragma mark - Gesture Methods

- (void)dragging:(UIPanGestureRecognizer *)gestureRecognizer
{

    switch (gestureRecognizer.state)
    {
        case UIGestureRecognizerStateBegan: {
            CGPoint p = [gestureRecognizer locationInView:self];
            [self assignDraggedTileAtPoint:p];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            if (!self.draggedTile) break;
            
            CGPoint translation = [gestureRecognizer translationInView:self];
            [self movingDraggedTile:translation];
            
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (!self.draggedTile) break;
            
            [self snapDraggedTile];
            
            break;
        }
        default:
            break;
    }
}

- (void)assignDraggedTileAtPoint:(CGPoint)position
{
    CGPoint coor = [self coordinateFromPoint:position];
    
    if (![self.board canMoveTile:coor]) {
        self.draggedDirection = 0;
        self.draggedTile = nil;
        return;
    }
    
    if ([[self.board tileAtCoordinate:CGPointMake(coor.x, coor.y-1)] isEqualToNumber:@0]) {
        self.draggedDirection = DirectionUp;
    } else if ([[self.board tileAtCoordinate:CGPointMake(coor.x+1, coor.y)] isEqualToNumber:@0]) {
        self.draggedDirection = DirectionRight;
    } else if ([[self.board tileAtCoordinate:CGPointMake(coor.x, coor.y+1)] isEqualToNumber:@0]) {
        self.draggedDirection = DirectionDown;
    } else if ([[self.board tileAtCoordinate:CGPointMake(coor.x-1, coor.y)] isEqualToNumber:@0]) {
        self.draggedDirection = DirectionLeft;
    }
    
    for (UIImageViewFocusEnviroment *tile in self.tiles)
    {
        if (CGRectContainsPoint(tile.frame, position))
        {
            self.draggedTile = tile;
            break;
        }
    }
}

- (void)movingDraggedTile:(CGPoint)translationPoint
{
    CGFloat x = 0.0, y = 0.0;
    CGPoint translation = translationPoint;
    
    switch (self.draggedDirection) {
        case DirectionUp :
            if (translation.y > 0) y = 0.0;
            else if (translation.y < - self.tileHeight) y = -self.tileHeight;
            else y = translation.y;
            break;
        case DirectionRight:
            if (translation.x < 0) x = 0.0;
            else if (translation.x > self.tileWidth) x = self.tileWidth;
            else x = translation.x;
            break;
        case DirectionDown :
            if (translation.y < 0) y = 0.0;
            else if (translation.y > self.tileHeight) y = self.tileHeight;
            else y = translation.y;
            break;
        case DirectionLeft:
            if (translation.x > 0) x = 0.0;
            else if (translation.x < -self.tileWidth) x = -self.tileWidth;
            else x = translation.x;
            break;
        default:
            return;
    }
    [self.draggedTile setTransform:CGAffineTransformMakeTranslation(x, y)];
}

- (void)moveTile:(UIImageViewFocusEnviroment *)tile withDirection:(int)direction fromTilePoint:(CGPoint)tilePoint {
    int deltaX = 0;
    int deltaY = 0;
    
    switch (direction) {
        case DirectionUp :
            deltaY = -1; break;
        case DirectionRight :
            deltaX = 1; break;
        case DirectionDown :
            deltaY = 1; break;
        case DirectionLeft :
            deltaX = -1; break;
        default: break;
    }
    CGRect newFrame = CGRectMake((tilePoint.x + deltaX - 1) * self.tileWidth, (tilePoint.y + deltaY - 1) * self.tileHeight, tile.frame.size.width, tile.frame.size.height);
    
    [UIView animateWithDuration:.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         tile.frame = newFrame;
                     }
                     completion:^(BOOL finished){
                         [tile setTransform:CGAffineTransformIdentity];
                         tile.frame = newFrame;
                         
                         if (direction != 0) {
                             [self.board shouldMove:YES tileAtCoordinate:tilePoint];
                             if (self.delegate) [self.delegate tileBoardView:self tileDidMove:tilePoint];
                             [self tileWasMoved];
                         }
                     }];
}


- (void)snapDraggedTile
{
    
    CGPoint movingTilePoint = CGPointMake(floorf(self.draggedTile.center.x / self.tileWidth) + 1, floorf(self.draggedTile.center.y / self.tileHeight) + 1);
    
    if (self.draggedTile.transform.ty < 0) {
        if (self.draggedTile.transform.ty < - (self.tileHeight/2)) {
            [self moveTile:self.draggedTile withDirection:DirectionUp fromTilePoint:movingTilePoint];
        } else {
            [self moveTile:self.draggedTile withDirection:0 fromTilePoint:movingTilePoint];
        }
    } else if (self.draggedTile.transform.tx > 0) {
        if (self.draggedTile.transform.tx > (self.tileWidth/2)) {
            [self moveTile:self.draggedTile withDirection:DirectionRight fromTilePoint:movingTilePoint];
        } else {
            [self moveTile:self.draggedTile withDirection:0 fromTilePoint:movingTilePoint];
        }
    } else if (self.draggedTile.transform.ty > 0) {
        if (self.draggedTile.transform.ty > (self.tileHeight/2)) {
            [self moveTile:self.draggedTile withDirection:DirectionDown fromTilePoint:movingTilePoint];
        } else {
            [self moveTile:self.draggedTile withDirection:0 fromTilePoint:movingTilePoint];
        }
    } else if (self.draggedTile.transform.tx < 0) {
        if (self.draggedTile.transform.tx < - (self.tileWidth/2)) {
            [self moveTile:self.draggedTile withDirection:DirectionLeft fromTilePoint:movingTilePoint];
        } else {
            [self moveTile:self.draggedTile withDirection:0 fromTilePoint:movingTilePoint];
        }
    }
}

- (void)tapMove:(UITapGestureRecognizer *)tapRecognizer
{
    NSLog(@"boraver");
    CGPoint tapPoint = [tapRecognizer locationInView:self];
    NSLog(@"%.0f %.0f", tapPoint.x, tapPoint.y);
    [self moveTileAtPosition:[self coordinateFromPoint:tapPoint]];
}

@end
