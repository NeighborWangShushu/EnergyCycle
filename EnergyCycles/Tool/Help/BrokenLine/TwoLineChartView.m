//
//  LineChartView.m
//  
//
//  Created by Marcel Ruegenberg on 02.08.13.
//
//

#import "TwoLineChartView.h"
#import "LegendView.h"
#import "TwoInfoView.h"
#import "NSArray+FPAdditions.h"


@implementation TwoLineChartData

@end

@interface TwoLineChartView ()

@property TwoInfoView *infoView;
//- (BOOL)drawsAnyData;

@end


#define X_AXIS_SPACE 65
#define PADDING 10

@implementation TwoLineChartView
@synthesize data=_data;
@synthesize monthPadding;
- (id)initWithFrame:(CGRect)frame {
    if((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor whiteColor];
        self.scaleFont = [UIFont systemFontOfSize:10.0];
        self.autoresizesSubviews = YES;
        self.contentMode = UIViewContentModeRedraw;
        self.drawsDataPoints = YES;
        self.drawsDataLines  = YES;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGContextRef c = UIGraphicsGetCurrentContext();
    UIImage *backBroundImage=[UIImage imageNamed:@"lightbackground.png"];
    CGImageRef cgimage=backBroundImage.CGImage;
    CGContextDrawImage(c, self.bounds, cgimage);

    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    CGFloat xStart = PADDING + self.yTwoAxisLabelsWidth+5;
    CGFloat yStart = PADDING;
    // draw scale and horizontal lines
    CGFloat heightPerStep = self.ySteps == nil || [self.ySteps count] == 0 ? availableHeight : (availableHeight / ([self.ySteps count] - 1));
    
    NSUInteger i = 0;
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 0.8);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *ystep in self.ySteps) {
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        [ystep drawInRect:CGRectMake(yStart, y - h / 2+50, self.yTwoAxisLabelsWidth - 6, h) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.scaleFont,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        [[UIColor colorWithWhite:0.9 alpha:0.5] set];
        CGContextMoveToPoint(c, xStart, round(y) + 0.5+50);
        CGContextAddLineToPoint(c, self.bounds.size.width - PADDING, round(y) + 0.5+50);
        CGContextStrokePath(c);
        i++;
    }
    NSUInteger j = 0;
    for (NSString *xstep in self.xSteps) {
        [xstep drawInRect:CGRectMake(xStart+j*self.monthPadding-13, availableHeight+64, self.yTwoAxisLabelsWidth+12, 10) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.scaleFont,NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
        CGContextMoveToPoint(c, xStart+j*self.monthPadding, yStart + heightPerStep * (yCnt - 1)+50);
        CGContextAddLineToPoint(c, xStart+j*self.monthPadding, 50);
        CGContextStrokePath(c);
        j++;
    }
    for(TwoLineChartData *data in self.data) {
        if (self.drawsDataLines) {
                NSString *rate1=data.rateArray[0];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL,
                                  xStart,
                                  yStart + availableHeight -([rate1 floatValue]-0.1)/self.yCount* availableHeight+50);
                for(NSUInteger i = 1; i < data.rateArray.count; ++i) {
                    NSString *rate=data.rateArray[i];
                    CGPathAddLineToPoint(path, NULL,
                                         xStart+i*self.monthPadding ,
                                         yStart + availableHeight -([rate floatValue]-0.1)/self.yCount* availableHeight+50);
                }
            
                CGMutablePathRef outerPath=drawFillRectPath(data.rateArray, xStart, yStart, availableHeight,self.monthPadding,self.yCount);
            
                UIColor *color=[UIColor colorWithPatternImage:[UIImage imageNamed:@"首页半透明背景.png"]];
                UIColor *color1=[color colorWithAlphaComponent:0.9];
                CGColorRef outerColor=color1.CGColor;

                CGContextSetFillColorWithColor(c, outerColor);
                
                CGContextAddPath(c, outerPath);
                CGContextFillPath(c);
                
            
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [data.color CGColor]);
                CGContextSetLineWidth(c, 4);
                CGContextStrokePath(c);
                CGPathRelease(path);
            }
        
        if (self.drawsDataPoints) {
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                NSString *rate=data.rateArray[i];

                CGFloat xVal = xStart +i*self.monthPadding;
                CGFloat yVal = yStart + availableHeight -([rate floatValue]-0.1)/0.7* availableHeight+50;
                [[UIColor whiteColor] setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 5.5, yVal - 5.5, 11, 11));
                [data.color setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 3, yVal - 3, 6, 6));
            }
        }
    }
}
CGMutablePathRef drawFillRectPath(NSArray *_rateArray,float _xStart,float _yStart,float _availableHeight,int monthPadding,float _yCount)
{
    NSString *rate1=_rateArray[0];
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL,
                      _xStart,
                      _yStart + _availableHeight -([rate1 floatValue]-0.1)/_yCount* _availableHeight+50);
    for(NSUInteger i = 1; i < _rateArray.count; ++i) {
        NSString *rate=_rateArray[i];
        
        CGPathAddLineToPoint(path, NULL,
                             _xStart+i*monthPadding ,
                             _yStart + _availableHeight -([rate floatValue]-0.1)/_yCount* _availableHeight+50);
    }
    CGPathAddLineToPoint(path, NULL,
                         _xStart+(_rateArray.count-1)*monthPadding ,
                         _yStart + _availableHeight+50);
    CGPathAddLineToPoint(path, NULL,
                         _xStart,
                         _yStart + _availableHeight+50);
    CGPathAddLineToPoint(path, NULL,
                         _xStart,
                         _yStart + _availableHeight -([rate1 floatValue]-0.1)/_yCount* _availableHeight+50);
    CGPathCloseSubpath(path);
    return path;

    
}
- (void)showIndicatorForTouch:(UITouch *)touch {
    
    CGFloat xStart = PADDING + self.yTwoAxisLabelsWidth;
    CGFloat yStart = PADDING;
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    CGPoint closestPos = CGPointZero;
    NSString *rate=nil;
    CGPoint pos = [touch locationInView:self];
    float xPos = pos.x;
    float yPos = pos.y;
    if ((30 < xPos && xPos < 310)&&(50 < yPos && yPos < 220)) {
    if(! self.infoView) {
       self.infoView = [[TwoInfoView alloc] init];
       [self addSubview:self.infoView];
    }
    int value = round(fabsf(xPos)/self.monthPadding)-1;
    TwoLineChartData *data = self.data[0];
    rate = data.rateArray[value];
    CGFloat xVal = xStart +value*self.monthPadding;
    CGFloat yVal = yStart + availableHeight -([rate floatValue]-0.1)/self.yCount* availableHeight+50;
    closestPos = CGPointMake(xVal-3.8+5,yVal-9);
        
    self.infoView.infoLabel.text =[NSString stringWithFormat:@"%.2f",[rate floatValue]*10];
    self.infoView.tapPoint = closestPos;
    [self.infoView sizeToFit];
    [self.infoView setNeedsLayout];
    [self.infoView setNeedsDisplay];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 1.0;
    }];
    }
    
}

- (void)hideIndicator {
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 0.0;
    }];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorForTouch:[touches anyObject]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [self showIndicatorForTouch:[touches anyObject]];	
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hideIndicator];
}


#pragma mark Helper methods

//- (BOOL)drawsAnyData {
//    return self.drawsDataPoints || self.drawsDataLines;
//}

// TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yTwoAxisLabelsWidth {
    NSNumber *requiredWidth = [[self.ySteps mapWithBlock:^id(id obj) {
        NSString *label = (NSString*)obj;
        CGSize labelSize = [label sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.scaleFont,NSFontAttributeName, nil]];

        return @(labelSize.width); // Literal NSNumber Conversion
    }] valueForKeyPath:@"@max.self"]; // gets biggest object. Yeah, NSKeyValueCoding. Deal with it.
    return [requiredWidth floatValue]  + PADDING;
}

@end
