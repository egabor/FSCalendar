//
//  FSCalendarCell.m
//  Pods
//
//  Created by Wenchao Ding on 12/3/15.
//
//

#import "FSCalendarCell.h"
#import "FSCalendar.h"
#import "FSCalendarExtensions.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarConstants.h"

@interface FSCalendarCell ()

@property (readonly, nonatomic) UIColor *colorForCellFill;
@property (readonly, nonatomic) UIColor *colorForTitleLabel;
@property (readonly, nonatomic) UIColor *colorForExpenseLabel;
@property (readonly, nonatomic) UIColor *colorForIncomeLabel;
@property (readonly, nonatomic) UIColor *colorForCellBorder;
@property (readonly, nonatomic) NSArray<UIColor *> *colorsForEvents;
@property (readonly, nonatomic) CGFloat borderRadius;

@end

@implementation FSCalendarCell

#pragma mark - Life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)ibInit {
    CAShapeLayer *shapeLayer;
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
    self.shapeLayer = shapeLayer;
    [self layoutSubviews];
}

- (void)commonInit
{   
    UILabel *label;
    CAShapeLayer *shapeLayer;
    UIImageView *imageView;
    UIImageView *view;
    FSCalendarEventIndicator *eventIndicator;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor redColor];
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    self.expenseLabel = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor greenColor];
    label.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:label];
    self.incomeLabel = label;
    
    view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:view];
    self.paddingView = view;
    
    
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
    shapeLayer.borderWidth = 1.0;
    shapeLayer.borderColor = [UIColor clearColor].CGColor;
    shapeLayer.opacity = 0;
    [self.contentView.layer insertSublayer:shapeLayer below:_titleLabel.layer];
    self.shapeLayer = shapeLayer;
    
    eventIndicator = [[FSCalendarEventIndicator alloc] initWithFrame:CGRectZero];
    eventIndicator.backgroundColor = [UIColor clearColor];
    eventIndicator.hidden = YES;
    [self.contentView addSubview:eventIndicator];
    self.eventIndicator = eventIndicator;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.contentMode = UIViewContentModeBottom|UIViewContentModeCenter;
    [self.contentView addSubview:imageView];
    self.imageView = imageView;
    
    self.clipsToBounds = NO;
    self.contentView.clipsToBounds = NO;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _titleLabel.text = self.title;
    if (_expense) {
        _expenseLabel.text = _expense;
        if (_expenseLabel.hidden) {
            _expenseLabel.hidden = NO;
        }
    } else {
        if (!_expenseLabel.hidden) {
            _expenseLabel.hidden = YES;
        }
    }
    
    if (_income) {
        _incomeLabel.text = _income;
        if (_incomeLabel.hidden) {
            _incomeLabel.hidden = NO;
        }
    } else {
        if (!_incomeLabel.hidden) {
            _incomeLabel.hidden = YES;
        }
    }
    
    if (_expense || _income) {
        CGFloat titleHeight = self.calendar.calculator.titleHeight;
        CGFloat expenseHeight = self.calendar.calculator.expenseHeight;
        CGFloat incomeHeight = self.calendar.calculator.incomeHeight;

        CGFloat height = titleHeight + expenseHeight;
        _titleLabel.frame = CGRectMake(
                                       self.preferredTitleOffset.x,
                                       self.preferredTitleOffset.y,
                                       self.contentView.fs_width*0.8f,
                                       titleHeight
                                       );
        _expenseLabel.frame = CGRectMake(
                                          self.preferredExpenseOffset.x,
                                          10.0f+(_titleLabel.fs_bottom-self.preferredTitleOffset.y) - (_titleLabel.fs_height-_titleLabel.font.pointSize)+self.preferredExpenseOffset.y,
                                          self.contentView.fs_width*0.8f,
                                          expenseHeight
                                          );
    
        _incomeLabel.frame = CGRectMake(
                                     self.preferredIncomeOffset.x,
                                     _expenseLabel.fs_bottom,
                                     self.contentView.fs_width*0.8f,
                                     incomeHeight
                                     );
        
        _paddingView.frame = CGRectMake(self.preferredIncomeOffset.x, _incomeLabel.fs_bottom, self.contentView.fs_width*0.8f, 
                                        0.0f);
    } else {
        _titleLabel.frame = CGRectMake(
                                       self.preferredTitleOffset.x,
                                       self.preferredTitleOffset.y,
                                       self.contentView.fs_width*0.8f,
                                       floor(self.contentView.fs_height*5.0/6.0)
                                       );
    }
    
    _imageView.frame = CGRectMake(self.preferredImageOffset.x, self.preferredImageOffset.y, self.contentView.fs_width, self.contentView.fs_height);
    
    
    
    /*CGFloat titleHeight = self.bounds.size.height*5.0/6.0;
    CGFloat diameter = MIN(self.bounds.size.height*5.0/6.0,self.bounds.size.width);
    diameter = diameter > FSCalendarStandardCellDiameter ? (diameter - (diameter-FSCalendarStandardCellDiameter)*0.5) : diameter;
    */
    _shapeLayer.frame = self.bounds;/*CGRectMake((self.bounds.size.width-diameter)/2,
                                   (titleHeight-diameter)/2,
                                   diameter,
                                   diameter);*/
    
    CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                cornerRadius:0.0f/*CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius*/].CGPath;
    
     if (!CGPathEqualToPath(_shapeLayer.path,path)) {
        _shapeLayer.path = path;
    }
    
    /*CGFloat eventSize = _shapeLayer.frame.size.height/6.0;
    _eventIndicator.frame = CGRectMake(
                                       self.preferredEventOffset.x,
                                       CGRectGetMaxY(_shapeLayer.frame)+eventSize*0.17+self.preferredEventOffset.y,
                                       self.fs_width,
                                       eventSize*0.83
                                      );*/
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [CATransaction setDisableActions:YES];
    _shapeLayer.opacity = 0;
    [self.contentView.layer removeAnimationForKey:@"opacity"];
}

#pragma mark - Public

- (void)performSelecting
{
    _shapeLayer.opacity = 1;
    
#define kAnimationDuration FSCalendarDefaultBounceAnimationDuration
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    CABasicAnimation *zoomOut = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomOut.fromValue = @0.3;
    zoomOut.toValue = @1.2;
    zoomOut.duration = kAnimationDuration/4*3;
    CABasicAnimation *zoomIn = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    zoomIn.fromValue = @1.2;
    zoomIn.toValue = @1.0;
    zoomIn.beginTime = kAnimationDuration/4*3;
    zoomIn.duration = kAnimationDuration/4;
    group.duration = kAnimationDuration;
    group.animations = @[zoomOut, zoomIn];
    [_shapeLayer addAnimation:group forKey:@"bounce"];
    [self configureAppearance];
    
#undef kAnimationDuration
    
}

#pragma mark - Private

- (void)configureAppearance
{
    UIColor *textColor = self.colorForTitleLabel;
    if (![textColor isEqual:_titleLabel.textColor]) {
        _titleLabel.textColor = textColor;
    }
    UIFont *titleFont = self.calendar.appearance.titleFont;
    if (![titleFont isEqual:_titleLabel.font]) {
        _titleLabel.font = titleFont;
    }
    if (_expense) {
        textColor = self.colorForExpenseLabel;
        if (![textColor isEqual:_expenseLabel.textColor]) {
            _expenseLabel.textColor = textColor;
        }
        titleFont = self.calendar.appearance.expenseFont;
        if (![titleFont isEqual:_expenseLabel.font]) {
            _expenseLabel.font = titleFont;
        }
    }
    
    if (_income) {
        textColor = self.colorForIncomeLabel;
        if (![textColor isEqual:_incomeLabel.textColor]) {
            _incomeLabel.textColor = textColor;
        }
        titleFont = self.calendar.appearance.incomeFont;
        if (![titleFont isEqual:_incomeLabel.font]) {
            _incomeLabel.font = titleFont;
        }
    }
    
    UIColor *borderColor = self.colorForCellBorder;
    UIColor *fillColor = self.colorForCellFill;
    
    BOOL shouldHideShapeLayer = !self.selected && !self.dateIsToday && !borderColor && !fillColor;
    
    if (_shapeLayer.opacity == shouldHideShapeLayer) {
        _shapeLayer.opacity = !shouldHideShapeLayer;
    }
    if (!shouldHideShapeLayer) {
        
        CGColorRef cellFillColor = self.colorForCellFill.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.fillColor, cellFillColor)) {
            _shapeLayer.fillColor = cellFillColor;
        }
        
        CGColorRef cellBorderColor = self.colorForCellBorder.CGColor;
        if (!CGColorEqualToColor(_shapeLayer.strokeColor, cellBorderColor)) {
            _shapeLayer.strokeColor = cellBorderColor;
        }
        
        CGPathRef path = [UIBezierPath bezierPathWithRoundedRect:_shapeLayer.bounds
                                                    cornerRadius:0.0f/*CGRectGetWidth(_shapeLayer.bounds)*0.5*self.borderRadius*/].CGPath;
        if (!CGPathEqualToPath(_shapeLayer.path, path)) {
            _shapeLayer.path = path;
        }
        
    }
    
    if (![_image isEqual:_imageView.image]) {
        _imageView.image = _image;
        _imageView.hidden = !_image;
    }
    
    if (_eventIndicator.hidden == (_numberOfEvents > 0)) {
        _eventIndicator.hidden = !_numberOfEvents;
    }
    
    _eventIndicator.numberOfEvents = self.numberOfEvents;
    _eventIndicator.color = self.colorsForEvents;
    

}

- (UIColor *)colorForCurrentStateInDictionary:(NSDictionary *)dictionary
{
    if (self.isSelected) {
        if (self.dateIsToday) {
            return dictionary[@(FSCalendarCellStateSelected|FSCalendarCellStateToday)] ?: dictionary[@(FSCalendarCellStateSelected)];
        }
        return dictionary[@(FSCalendarCellStateSelected)];
    }
    if (self.dateIsToday && [[dictionary allKeys] containsObject:@(FSCalendarCellStateToday)]) {
        return dictionary[@(FSCalendarCellStateToday)];
    }
    if (self.placeholder && [[dictionary allKeys] containsObject:@(FSCalendarCellStatePlaceholder)]) {
        return dictionary[@(FSCalendarCellStatePlaceholder)];
    }
    if (self.weekend && [[dictionary allKeys] containsObject:@(FSCalendarCellStateWeekend)]) {
        return dictionary[@(FSCalendarCellStateWeekend)];
    }
    return dictionary[@(FSCalendarCellStateNormal)];
}

#pragma mark - Properties

- (UIColor *)colorForCellFill
{
    if (self.selected) {
        return self.preferredFillSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
    }
    return self.preferredFillDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.backgroundColors];
}

- (UIColor *)colorForTitleLabel
{
    if (self.selected) {
        return self.preferredTitleSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
    }
    return self.preferredTitleDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.titleColors];
}

- (UIColor *)colorForExpenseLabel
{
    if (self.selected) {
        return self.preferredExpenseSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.expenseColors];
    }
    return self.preferredExpenseDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.expenseColors];
}

- (UIColor *)colorForIncomeLabel
{
    if (self.selected) {
        return self.preferredIncomeSelectionColor ?: [self colorForCurrentStateInDictionary:_appearance.incomeColors];
    }
    return self.preferredIncomeDefaultColor ?: [self colorForCurrentStateInDictionary:_appearance.incomeColors];
}

- (UIColor *)colorForCellBorder
{
    if (self.selected) {
        return _preferredBorderSelectionColor ?: _appearance.borderSelectionColor;
    }
    return _preferredBorderDefaultColor ?: _appearance.borderDefaultColor;
}

- (NSArray<UIColor *> *)colorsForEvents
{
    if (self.selected) {
        return _preferredEventSelectionColors ?: @[_appearance.eventSelectionColor];
    }
    return _preferredEventDefaultColors ?: @[_appearance.eventDefaultColor];
}

- (CGFloat)borderRadius
{
    return _preferredBorderRadius >= 0 ? _preferredBorderRadius : _appearance.borderRadius;
}

#define OFFSET_PROPERTY(NAME,CAPITAL,ALTERNATIVE) \
\
@synthesize NAME = _##NAME; \
\
- (void)set##CAPITAL:(CGPoint)NAME \
{ \
    BOOL diff = !CGPointEqualToPoint(NAME, self.NAME); \
    _##NAME = NAME; \
    if (diff) { \
        [self setNeedsLayout]; \
    } \
} \
\
- (CGPoint)NAME \
{ \
    return CGPointEqualToPoint(_##NAME, CGPointInfinity) ? ALTERNATIVE : _##NAME; \
}

OFFSET_PROPERTY(preferredTitleOffset, PreferredTitleOffset, _appearance.titleOffset);
OFFSET_PROPERTY(preferredExpenseOffset, PreferredExpenseOffset, _appearance.expenseOffset);
OFFSET_PROPERTY(preferredIncomeOffset, PreferredIncomeOffset, _appearance.incomeOffset);
OFFSET_PROPERTY(preferredImageOffset, PreferredImageOffset, _appearance.imageOffset);
OFFSET_PROPERTY(preferredEventOffset, PreferredEventOffset, _appearance.eventOffset);

#undef OFFSET_PROPERTY

- (void)setCalendar:(FSCalendar *)calendar
{
    if (![_calendar isEqual:calendar]) {
        _calendar = calendar;
        _appearance = calendar.appearance;
        [self configureAppearance];
    }
}

- (void)setExpense:(NSString *)expense
{
    if (![_expense isEqualToString:expense]) {
        BOOL diff = (expense.length && !_expense.length) || (_expense.length && !expense.length);
        _expense = expense;
        if (diff) {
            [self setNeedsLayout];
        }
    }
}

- (void)setIncome:(NSString *)income
{
    if (![_income isEqualToString:income]) {
        BOOL diff = (income.length && !_income.length) || (_income.length && !income.length);
        _income = income;
        if (diff) {
            [self setNeedsLayout];
        }
    }
}

@end


@interface FSCalendarEventIndicator ()

@property (weak, nonatomic) UIView *contentView;

@property (strong, nonatomic) NSPointerArray *eventLayers;
@property (assign, nonatomic) BOOL needsInvalidatingColor;

@end

@implementation FSCalendarEventIndicator

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        [self addSubview:view];
        self.contentView = view;
        
        self.eventLayers = [NSPointerArray weakObjectsPointerArray];
        for (int i = 0; i < 3; i++) {
            CALayer *layer = [CALayer layer];
            layer.backgroundColor = [UIColor clearColor].CGColor;
            [self.contentView.layer addSublayer:layer];
            [self.eventLayers addPointer:(__bridge void * _Nullable)(layer)];
        }
        
        _needsInvalidatingColor = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat diameter = MIN(MIN(self.fs_width, self.fs_height),FSCalendarMaximumEventDotDiameter);
    self.contentView.fs_height = self.fs_height;
    self.contentView.fs_width = (self.numberOfEvents*2-1)*diameter;
    self.contentView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
}

- (void)layoutSublayersOfLayer:(CALayer *)layer
{
    [super layoutSublayersOfLayer:layer];
    if (layer == self.layer) {
        
        CGFloat diameter = MIN(MIN(self.fs_width, self.fs_height),FSCalendarMaximumEventDotDiameter);
        for (int i = 0; i < self.eventLayers.count; i++) {
            CALayer *eventLayer = [self.eventLayers pointerAtIndex:i];
            eventLayer.hidden = i >= self.numberOfEvents;
            if (!eventLayer.hidden) {
                eventLayer.frame = CGRectMake(2*i*diameter, (self.fs_height-diameter)*0.5, diameter, diameter);
                if (eventLayer.cornerRadius != diameter/2) {
                    eventLayer.cornerRadius = diameter/2;
                }
            }
        }
        
        if (_needsInvalidatingColor) {
            _needsInvalidatingColor = NO;
            if ([_color isKindOfClass:[UIColor class]]) {
                [self.eventLayers.allObjects makeObjectsPerformSelector:@selector(setBackgroundColor:) withObject:(id)[_color CGColor]];
            } else if ([_color isKindOfClass:[NSArray class]]) {
                NSArray *colors = (NSArray *)_color;
                if (colors.count) {
                    UIColor *lastColor = colors.firstObject;
                    for (int i = 0; i < self.eventLayers.count; i++) {
                        if (i < colors.count) {
                            lastColor = colors[i];
                        }
                        CALayer *eventLayer = [self.eventLayers pointerAtIndex:i];
                        eventLayer.backgroundColor = lastColor.CGColor;
                    }
                }
            }
        }
    }
}

- (void)setColor:(id)color
{
    if (![_color isEqual:color]) {
        _color = color;
        _needsInvalidatingColor = YES;
        [self setNeedsLayout];
    }
}

- (void)setNumberOfEvents:(NSInteger)numberOfEvents
{
    if (_numberOfEvents != numberOfEvents) {
        _numberOfEvents = MIN(MAX(numberOfEvents,0),3);
        [self setNeedsLayout];
    }
}

@end


@implementation FSCalendarBlankCell

- (void)configureAppearance {}

@end



