//
//  WhiteBoardView.m
//  demo2
//
//  Created by spacetime on 10/26/16.
//  Copyright © 2016 spacetime. All rights reserved.
//

#import "WhiteBoardView.h"


@implementation WhiteBoardView{
    NSMutableArray *paths;
    UIBezierPath *curPath;
    UIColor *color;

    int width;
    int pointX;
    int pointY;

}

- (void)drawRect:(CGRect)rect{
    
    for(int i = 0;i < paths.count;i++){
        UIBezierPath *bezierPath = [paths objectAtIndex:i];
        [color setStroke];
        [bezierPath stroke];
    }
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        paths = [[NSMutableArray alloc] init];
        color = [UIColor blueColor];
        width = 5;
    }
    
    return self;
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // Get a reference to any one of the user's touches.
    UITouch *touch = [touches anyObject];
    
    // Conver the user's touch to an (x,y) coordinate.
    CGPoint point = [touch locationInView:self];
    
    // Create a new path
    curPath = [[UIBezierPath alloc] init];
    [curPath setLineWidth:width];
    
    [paths addObject:curPath];
    
    // Move the current path to the point we extracted earlier.
    [curPath moveToPoint:point];
    
    NSLog(@"point to (x=%f,y=%f)",point.x,point.y);
    
    // Let iOS know that we need to call the drawRect method again.
    // This will refresh the view so that the most up-to-date paths are drawn
    [self setNeedsDisplay];

    
}


-(void) touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    // Get a reference to any one of the user's touches.
    UITouch *touch = [touches anyObject];
    
    // Conver the user's touch to an (x,y) coordinate.
    CGPoint point = [touch locationInView:self];
    
    NSLog(@"path to (x=%f,y=%f)",point.x,point.y);
    
    // Add a straight line to the point we just extracted.
    [curPath addLineToPoint:point];
    
    //Refresh the drawn paths
    [self setNeedsDisplay];
}

//-(void) touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    CGContextStrokePath(ctx);
//}

@end


