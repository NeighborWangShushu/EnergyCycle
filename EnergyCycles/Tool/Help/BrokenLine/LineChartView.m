//
//  LineChartView.m
//  
//
//  Created by Marcel Ruegenberg on 02.08.13.
//
//

#import "LineChartView.h"
#import "LegendView.h"
#import "InfoView.h"
#import "NSArray+FPAdditions.h"
#import "TwoLineChartView.h"
#import "TwoInfoView.h"

@interface LineChartDataItem ()

@property (readwrite) float x; // should be within the x range
@property (readwrite) float y; // should be within the y range
@property (readwrite) NSString *xLabel; // label to be shown on the x axis
@property (readwrite) NSString *dataLabel; // label to be shown directly at the data item

- (id)initWithhX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel;

@end

@implementation LineChartDataItem

- (id)initWithhX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel {
    if((self = [super init])) {
        self.x = x;
        self.y = y;
        self.xLabel = xLabel;
        self.dataLabel = dataLabel;
    }
    return self;
}

+ (LineChartDataItem *)dataItemWithX:(float)x y:(float)y xLabel:(NSString *)xLabel dataLabel:(NSString *)dataLabel {
    return [[LineChartDataItem alloc] initWithhX:x y:y xLabel:xLabel dataLabel:dataLabel];
}

@end



@implementation LineChartData

@end



@interface LineChartView ()

@property (strong, nonatomic) CAGradientLayer *gradientLayer;

@property InfoView *infoView;
- (BOOL)drawsAnyData;

@end


#define X_AXIS_SPACE 15
#define PADDING 10

@implementation LineChartView
@synthesize data=_data;


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
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;
    
    //画点
    // draw scale and horizontal lines
    CGFloat heightPerStep = self.ySteps == nil || [self.ySteps count] == 0 ? availableHeight : (availableHeight / ([self.ySteps count] - 1));
    
    NSUInteger i = 0;
    CGContextSaveGState(c);
    CGContextSetLineWidth(c, 1.0);
    NSUInteger yCnt = [self.ySteps count];
    for(NSString *ystep in self.ySteps) {
        [[UIColor grayColor] set];
        CGFloat h = [self.scaleFont lineHeight];
        CGFloat y = yStart + heightPerStep * (yCnt - 1 - i);
        [ystep drawInRect:CGRectMake(yStart, y - h / 2, self.yAxisLabelsWidth - 6, h) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.scaleFont,NSFontAttributeName, nil]];
//        [[UIColor colorWithWhite:0.9 alpha:1.0] set];
        [[UIColor clearColor] set];
        CGContextMoveToPoint(c, xStart, round(y) + 0.5);
        CGContextAddLineToPoint(c, self.bounds.size.width - PADDING, round(y) + 0.5);
        CGContextStrokePath(c);
        i++;
    }
//    NSUInteger j = 0;
//    for (NSString *xstep in self.xSteps) {
//        [[UIColor grayColor] set];
//        [xstep drawInRect:CGRectMake(xStart+j*self.monthPadding+8, availableHeight+20, self.yAxisLabelsWidth - 6, 10) withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.scaleFont,NSFontAttributeName, nil]];
//        
//        j++;
//    }
    for(LineChartData *data in self.data) {
        if (self.drawsDataLines) {
                NSString *rate1=data.rateArray[0];
                CGMutablePathRef path = CGPathCreateMutable();
                CGPathMoveToPoint(path, NULL,
                                  xStart+20,
                                  yStart + availableHeight -[rate1 floatValue]/0.8 * availableHeight);
                for(NSUInteger i = 1; i < data.rateArray.count; ++i) {
                    NSString *rate=data.rateArray[i];

                    CGPathAddLineToPoint(path, NULL,
                                         xStart+20+i*self.monthPadding ,
                                         yStart + availableHeight -[rate floatValue]/0.8 * availableHeight);
                }
                
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [self.backgroundColor CGColor]);
                CGContextSetLineWidth(c, 5);
                CGContextStrokePath(c);
                
                CGContextAddPath(c, path);
                CGContextSetStrokeColorWithColor(c, [[UIColor whiteColor] CGColor]);
                CGContextSetLineWidth(c, 1.5);
                CGContextStrokePath(c);
                
                CGPathRelease(path);
            }
        if (self.drawsDataPoints) {
            for(NSUInteger i = 0; i < data.itemCount; ++i) {
                NSString *rate=data.rateArray[i];

                CGFloat xVal = xStart+20 +i*self.monthPadding;
                CGFloat yVal = yStart + availableHeight -[rate floatValue]/0.8 * availableHeight;
                [self.backgroundColor setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 5.5, yVal - 5.5, 11, 11));
                [[UIColor whiteColor] setFill];
                CGContextFillEllipseInRect(c, CGRectMake(xVal - 2.5, yVal - 2.5, 5, 5));
            } // for
        } // draw data points
    }
    
    //画渐变色
    CGMutablePathRef pathRef = CGPathCreateMutable();
    for(LineChartData *data in self.data) {
        NSString *rate1=data.rateArray[0];
        CGPathMoveToPoint(pathRef, NULL,
                          xStart+20,
                          yStart + availableHeight -[rate1 floatValue]/0.8 * availableHeight);
        for(NSUInteger i = 1; i < data.rateArray.count; ++i) {
            NSString *rate=data.rateArray[i];
            
            CGPathAddLineToPoint(pathRef, NULL,
                                 xStart+20+i*self.monthPadding ,
                                 yStart + availableHeight -[rate floatValue]/0.8 * availableHeight);
            if (i == data.rateArray.count - 1) {
                CGPathAddLineToPoint(pathRef, NULL,  xStart+20+i*self.monthPadding, CGRectGetHeight(self.frame));
                CGPathAddLineToPoint(pathRef, NULL, xStart+20, CGRectGetHeight(self.frame));
                CGPathAddLineToPoint(pathRef, NULL, xStart+20, yStart + availableHeight -[rate1 floatValue]/0.8 * availableHeight);
            }
        }
    }
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.path = pathRef;
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor greenColor].CGColor;
    
    self.gradientLayer.colors = @[(id)([[UIColor whiteColor] colorWithAlphaComponent:0.7].CGColor),(id)([[UIColor whiteColor] colorWithAlphaComponent:0.1].CGColor),(id)([UIColor clearColor].CGColor)];
    self.gradientLayer.locations = @[@(0),@(0.7),@(1)];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.mask = layer;
    self.gradientLayer.masksToBounds = YES;
    [self.layer addSublayer:self.gradientLayer];
}

- (void)showIndicatorForTouch:(UITouch *)touch {
    CGFloat xStart = PADDING + self.yAxisLabelsWidth;
    CGFloat yStart = PADDING;
    CGFloat availableHeight = self.bounds.size.height - 2 * PADDING - X_AXIS_SPACE;
    CGPoint closestPos = CGPointZero;
    NSString *rate=nil;
    
    if(! self.infoView) {
        self.infoView = [[InfoView alloc] init];
        [self addSubview:self.infoView];
    }
    
    CGPoint pos = [touch locationInView:self];
    float xPos = pos.x;
    float yPos = pos.y;
    if ((49 < xPos && xPos < 310)&&(10<yPos&&yPos<180)) {
       int value = round(fabsf(xPos-72)/self.monthPadding);
        LineChartData *data1 = self.data[0];
        LineChartData *data2 = self.data[1];
        NSString *rate1 = data1.rateArray[value];
        NSString *rate2 = data2.rateArray[value];
        CGFloat yVal1 = yStart + availableHeight -[rate1 floatValue]/0.8 * availableHeight;
        CGFloat yVal2 = yStart + availableHeight -[rate2 floatValue]/0.8 * availableHeight;
        
        CGFloat yDistance1 = fabs(yPos-yVal1);
        CGFloat yDistance2 = fabs(yPos-yVal2);
        
        if (yDistance1>yDistance2) {
                CGFloat xVal = xStart+20 +value*self.monthPadding;
                CGFloat yVal = yStart + availableHeight -[rate2 floatValue]/0.8 * availableHeight;
                closestPos = CGPointMake(xVal-3.8,yVal-9);
                rate=rate2;
            }else if (yDistance1<=yDistance2){
                CGFloat xVal = xStart+20 +value*self.monthPadding;
                CGFloat yVal = yStart + availableHeight -[rate1 floatValue]/0.8 * availableHeight;
                closestPos = CGPointMake(xVal-3.8,yVal-9);
                rate=rate1;
            }
    }
    
    self.infoView.infoLabel.text =[NSString stringWithFormat:@"%.2f%@",[rate floatValue]*10,@"%"];
    self.infoView.tapPoint = closestPos;
    [self.infoView sizeToFit];
    [self.infoView setNeedsLayout];
    [self.infoView setNeedsDisplay];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.infoView.alpha = 1.0;
    }];
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
- (BOOL)drawsAnyData {
    return self.drawsDataPoints || self.drawsDataLines;
}

// TODO: This should really be a cached value. Invalidated iff ySteps changes.
- (CGFloat)yAxisLabelsWidth {
    NSNumber *requiredWidth = [[self.ySteps mapWithBlock:^id(id obj) {
        NSString *label = (NSString*)obj;
        CGSize labelSize = [label sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.scaleFont,NSFontAttributeName, nil]];

        return @(labelSize.width); // Literal NSNumber Conversion
    }] valueForKeyPath:@"@max.self"]; // gets biggest object. Yeah, NSKeyValueCoding. Deal with it.
    return [requiredWidth floatValue] + PADDING;
}

- (CAGradientLayer *)gradientLayer {
    if (_gradientLayer == nil) {
        _gradientLayer = [CAGradientLayer layer];
    }
    return _gradientLayer;
}


@end
