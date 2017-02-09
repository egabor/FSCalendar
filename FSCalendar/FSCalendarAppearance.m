//
//  FSCalendarAppearance.m
//  Pods
//
//  Created by DingWenchao on 6/29/15.
//  Copyright © 2016 Wenchao Ding. All rights reserved.
//
//  https://github.com/WenchaoD
//

#import "FSCalendarAppearance.h"
#import "FSCalendarDynamicHeader.h"
#import "FSCalendarExtensions.h"

@interface FSCalendarAppearance ()

@property (weak  , nonatomic) FSCalendar *calendar;

@property (strong, nonatomic) NSMutableDictionary *backgroundColors;
@property (strong, nonatomic) NSMutableDictionary *titleColors;
@property (strong, nonatomic) NSMutableDictionary *expenseColors;
@property (strong, nonatomic) NSMutableDictionary *incomeColors;
@property (strong, nonatomic) NSMutableDictionary *borderColors;

@end

@implementation FSCalendarAppearance

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _titleFont = [UIFont systemFontOfSize:FSCalendarStandardTitleTextSize];
        _expenseFont = [UIFont systemFontOfSize:FSCalendarStandardSubtitleTextSize];
        _incomeFont = [UIFont systemFontOfSize:FSCalendarStandardSubtitleTextSize];

        _weekdayFont = [UIFont systemFontOfSize:FSCalendarStandardWeekdayTextSize];
        _headerTitleFont = [UIFont systemFontOfSize:FSCalendarStandardHeaderTextSize];
        
        _headerTitleColor = FSCalendarStandardTitleTextColor;
        _headerDateFormat = @"MMMM yyyy";
        _headerMinimumDissolvedAlpha = 0.2;
        _weekdayTextColor = FSCalendarStandardTitleTextColor;
        _caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase|FSCalendarCaseOptionsWeekdayUsesDefaultCase;
        
        _backgroundColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _backgroundColors[@(FSCalendarCellStateNormal)]      = [UIColor clearColor];
        _backgroundColors[@(FSCalendarCellStateSelected)]    = FSCalendarStandardSelectionColor;
        _backgroundColors[@(FSCalendarCellStateDisabled)]    = [UIColor clearColor];
        _backgroundColors[@(FSCalendarCellStatePlaceholder)] = [UIColor clearColor];
        _backgroundColors[@(FSCalendarCellStateToday)]       = FSCalendarStandardTodayColor;
        
        _titleColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _titleColors[@(FSCalendarCellStateNormal)]      = [UIColor blackColor];
        _titleColors[@(FSCalendarCellStateSelected)]    = [UIColor whiteColor];
        _titleColors[@(FSCalendarCellStateDisabled)]    = [UIColor grayColor];
        _titleColors[@(FSCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _titleColors[@(FSCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _expenseColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _expenseColors[@(FSCalendarCellStateNormal)]      = [UIColor darkGrayColor];
        _expenseColors[@(FSCalendarCellStateSelected)]    = [UIColor whiteColor];
        _expenseColors[@(FSCalendarCellStateDisabled)]    = [UIColor lightGrayColor];
        _expenseColors[@(FSCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _expenseColors[@(FSCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _incomeColors = [NSMutableDictionary dictionaryWithCapacity:5];
        _incomeColors[@(FSCalendarCellStateNormal)]      = [UIColor darkGrayColor];
        _incomeColors[@(FSCalendarCellStateSelected)]    = [UIColor whiteColor];
        _incomeColors[@(FSCalendarCellStateDisabled)]    = [UIColor lightGrayColor];
        _incomeColors[@(FSCalendarCellStatePlaceholder)] = [UIColor lightGrayColor];
        _incomeColors[@(FSCalendarCellStateToday)]       = [UIColor whiteColor];
        
        _borderColors[@(FSCalendarCellStateSelected)] = [UIColor clearColor];
        _borderColors[@(FSCalendarCellStateNormal)] = [UIColor clearColor];
        
        _borderRadius = 1.0;
        _eventDefaultColor = FSCalendarStandardEventDotColor;
        _eventSelectionColor = FSCalendarStandardEventDotColor;
        
        _borderColors = [NSMutableDictionary dictionaryWithCapacity:2];
        
#if TARGET_INTERFACE_BUILDER
        _fakeEventDots = YES;
#endif
        
    }
    return self;
}

- (void)setTitleFont:(UIFont *)titleFont
{
    if (![_titleFont isEqual:titleFont]) {
        _titleFont = titleFont;
        self.calendar.calculator.titleHeight = -1;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setExpenseFont:(UIFont *)expenseFont
{
    if (![_expenseFont isEqual:expenseFont]) {
        _expenseFont = expenseFont;
        self.calendar.calculator.expenseHeight = -1;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setIncomeFont:(UIFont *)incomeFont
{
    if (![_incomeFont isEqual:incomeFont]) {
        _incomeFont = incomeFont;
        self.calendar.calculator.incomeHeight = -1;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setWeekdayFont:(UIFont *)weekdayFont
{
    if (![_weekdayFont isEqual:weekdayFont]) {
        _weekdayFont = weekdayFont;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderTitleFont:(UIFont *)headerTitleFont
{
    if (![_headerTitleFont isEqual:headerTitleFont]) {
        _headerTitleFont = headerTitleFont;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setTitleOffset:(CGPoint)titleOffset
{
    if (!CGPointEqualToPoint(_titleOffset, titleOffset)) {
        _titleOffset = titleOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setExpenseOffset:(CGPoint)expenseOffset
{
    if (!CGPointEqualToPoint(_expenseOffset, expenseOffset)) {
        _expenseOffset = expenseOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setIncomeOffset:(CGPoint)incomeOffset
{
    if (!CGPointEqualToPoint(_incomeOffset, incomeOffset)) {
        _incomeOffset = incomeOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setImageOffset:(CGPoint)imageOffset
{
    if (!CGPointEqualToPoint(_imageOffset, imageOffset)) {
        _imageOffset = imageOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setEventOffset:(CGPoint)eventOffset
{
    if (!CGPointEqualToPoint(_eventOffset, eventOffset)) {
        _eventOffset = eventOffset;
        [_calendar.collectionView.visibleCells makeObjectsPerformSelector:@selector(setNeedsLayout)];
    }
}

- (void)setTitleDefaultColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(FSCalendarCellStateNormal)] = color;
    } else {
        [_titleColors removeObjectForKey:@(FSCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleDefaultColor
{
    return _titleColors[@(FSCalendarCellStateNormal)];
}

- (void)setTitleSelectionColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(FSCalendarCellStateSelected)] = color;
    } else {
        [_titleColors removeObjectForKey:@(FSCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleSelectionColor
{
    return _titleColors[@(FSCalendarCellStateSelected)];
}

- (void)setTitleTodayColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(FSCalendarCellStateToday)] = color;
    } else {
        [_titleColors removeObjectForKey:@(FSCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleTodayColor
{
    return _titleColors[@(FSCalendarCellStateToday)];
}

- (void)setTitlePlaceholderColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(FSCalendarCellStatePlaceholder)] = color;
    } else {
        [_titleColors removeObjectForKey:@(FSCalendarCellStatePlaceholder)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titlePlaceholderColor
{
    return _titleColors[@(FSCalendarCellStatePlaceholder)];
}

- (void)setTitleWeekendColor:(UIColor *)color
{
    if (color) {
        _titleColors[@(FSCalendarCellStateWeekend)] = color;
    } else {
        [_titleColors removeObjectForKey:@(FSCalendarCellStateWeekend)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)titleWeekendColor
{
    return _titleColors[@(FSCalendarCellStateWeekend)];
}

- (void)setExpenseDefaultColor:(UIColor *)color
{
    if (color) {
        _expenseColors[@(FSCalendarCellStateNormal)] = color;
    } else {
        [_expenseColors removeObjectForKey:@(FSCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

-(UIColor *)expenseDefaultColor
{
    return _expenseColors[@(FSCalendarCellStateNormal)];
}

- (void)setExpenseSelectionColor:(UIColor *)color
{
    if (color) {
        _expenseColors[@(FSCalendarCellStateSelected)] = color;
    } else {
        [_expenseColors removeObjectForKey:@(FSCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)expenseSelectionColor
{
    return _expenseColors[@(FSCalendarCellStateSelected)];
}

- (void)setExpenseTodayColor:(UIColor *)color
{
    if (color) {
        _expenseColors[@(FSCalendarCellStateToday)] = color;
    } else {
        [_expenseColors removeObjectForKey:@(FSCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)expenseTodayColor
{
    return _expenseColors[@(FSCalendarCellStateToday)];
}

- (void)setexpensePlaceholderColor:(UIColor *)color
{
    if (color) {
        _expenseColors[@(FSCalendarCellStatePlaceholder)] = color;
    } else {
        [_expenseColors removeObjectForKey:@(FSCalendarCellStatePlaceholder)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)expensePlaceholderColor
{
    return _expenseColors[@(FSCalendarCellStatePlaceholder)];
}

- (void)setExpenseWeekendColor:(UIColor *)color
{
    if (color) {
        _expenseColors[@(FSCalendarCellStateWeekend)] = color;
    } else {
        [_expenseColors removeObjectForKey:@(FSCalendarCellStateWeekend)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)expenseWeekendColor
{
    return _expenseColors[@(FSCalendarCellStateWeekend)];
}


///////////

- (void)setIncomeDefaultColor:(UIColor *)color
{
    if (color) {
        _incomeColors[@(FSCalendarCellStateNormal)] = color;
    } else {
        [_incomeColors removeObjectForKey:@(FSCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

-(UIColor *)incomeDefaultColor
{
    return _incomeColors[@(FSCalendarCellStateNormal)];
}

- (void)setIncomeSelectionColor:(UIColor *)color
{
    if (color) {
        _incomeColors[@(FSCalendarCellStateSelected)] = color;
    } else {
        [_incomeColors removeObjectForKey:@(FSCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)incomeSelectionColor
{
    return _incomeColors[@(FSCalendarCellStateSelected)];
}

- (void)setIncomeTodayColor:(UIColor *)color
{
    if (color) {
        _incomeColors[@(FSCalendarCellStateToday)] = color;
    } else {
        [_incomeColors removeObjectForKey:@(FSCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)incomeTodayColor
{
    return _incomeColors[@(FSCalendarCellStateToday)];
}

- (void)setIncomePlaceholderColor:(UIColor *)color
{
    if (color) {
        _incomeColors[@(FSCalendarCellStatePlaceholder)] = color;
    } else {
        [_incomeColors removeObjectForKey:@(FSCalendarCellStatePlaceholder)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)incomePlaceholderColor
{
    return _incomeColors[@(FSCalendarCellStatePlaceholder)];
}

- (void)setIncomeWeekendColor:(UIColor *)color
{
    if (color) {
        _incomeColors[@(FSCalendarCellStateWeekend)] = color;
    } else {
        [_incomeColors removeObjectForKey:@(FSCalendarCellStateWeekend)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)incomeWeekendColor
{
    return _incomeColors[@(FSCalendarCellStateWeekend)];
}

- (void)setSelectionColor:(UIColor *)color
{
    if (color) {
        _backgroundColors[@(FSCalendarCellStateSelected)] = color;
    } else {
        [_backgroundColors removeObjectForKey:@(FSCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)selectionColor
{
    return _backgroundColors[@(FSCalendarCellStateSelected)];
}

- (void)setTodayColor:(UIColor *)todayColor
{
    if (todayColor) {
        _backgroundColors[@(FSCalendarCellStateToday)] = todayColor;
    } else {
        [_backgroundColors removeObjectForKey:@(FSCalendarCellStateToday)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)todayColor
{
    return _backgroundColors[@(FSCalendarCellStateToday)];
}

- (void)setTodaySelectionColor:(UIColor *)todaySelectionColor
{
    if (todaySelectionColor) {
        _backgroundColors[@(FSCalendarCellStateToday|FSCalendarCellStateSelected)] = todaySelectionColor;
    } else {
        [_backgroundColors removeObjectForKey:@(FSCalendarCellStateToday|FSCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)todaySelectionColor
{
    return _backgroundColors[@(FSCalendarCellStateToday|FSCalendarCellStateSelected)];
}

- (void)setEventDefaultColor:(UIColor *)eventDefaultColor
{
    if (![_eventDefaultColor isEqual:eventDefaultColor]) {
        _eventDefaultColor = eventDefaultColor;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setBorderDefaultColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(FSCalendarCellStateNormal)] = color;
    } else {
        [_borderColors removeObjectForKey:@(FSCalendarCellStateNormal)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)borderDefaultColor
{
    return _borderColors[@(FSCalendarCellStateNormal)];
}

- (void)setBorderSelectionColor:(UIColor *)color
{
    if (color) {
        _borderColors[@(FSCalendarCellStateSelected)] = color;
    } else {
        [_borderColors removeObjectForKey:@(FSCalendarCellStateSelected)];
    }
    [self.calendar setNeedsConfigureAppearance];
}

- (UIColor *)borderSelectionColor
{
    return _borderColors[@(FSCalendarCellStateSelected)];
}

- (void)setBorderRadius:(CGFloat)borderRadius
{
    borderRadius = MAX(0.0, borderRadius);
    borderRadius = MIN(1.0, borderRadius);
    if (_borderRadius != borderRadius) {
        _borderRadius = borderRadius;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setWeekdayTextColor:(UIColor *)weekdayTextColor
{
    if (![_weekdayTextColor isEqual:weekdayTextColor]) {
        _weekdayTextColor = weekdayTextColor;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderTitleColor:(UIColor *)color
{
    if (![_headerTitleColor isEqual:color]) {
        _headerTitleColor = color;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderMinimumDissolvedAlpha:(CGFloat)headerMinimumDissolvedAlpha
{
    if (_headerMinimumDissolvedAlpha != headerMinimumDissolvedAlpha) {
        _headerMinimumDissolvedAlpha = headerMinimumDissolvedAlpha;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setHeaderDateFormat:(NSString *)headerDateFormat
{
    if (![_headerDateFormat isEqual:headerDateFormat]) {
        _headerDateFormat = headerDateFormat;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setCaseOptions:(FSCalendarCaseOptions)caseOptions
{
    if (_caseOptions != caseOptions) {
        _caseOptions = caseOptions;
        [self.calendar setNeedsConfigureAppearance];
    }
}

- (void)setSeparators:(FSCalendarSeparators)separators
{
    if (_separators != separators) {
        _separators = separators;
        [_calendar.collectionView.collectionViewLayout invalidateLayout];
    }
}

@end


@implementation FSCalendarAppearance (Deprecated)

- (void)setUseVeryShortWeekdaySymbols:(BOOL)useVeryShortWeekdaySymbols
{
    _caseOptions &= 15;
    self.caseOptions |= (useVeryShortWeekdaySymbols*FSCalendarCaseOptionsWeekdayUsesSingleUpperCase);
}

- (BOOL)useVeryShortWeekdaySymbols
{
    return (_caseOptions & (15<<4) ) == FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;
}

- (void)setTitleVerticalOffset:(CGFloat)titleVerticalOffset
{
    self.titleOffset = CGPointMake(0, titleVerticalOffset);
}

- (CGFloat)titleVerticalOffset
{
    return self.titleOffset.y;
}

- (void)setExpenseVerticalOffset:(CGFloat)expenseVerticalOffset
{
    self.expenseOffset = CGPointMake(0, expenseVerticalOffset);
}

- (CGFloat)subtitleVerticalOffset
{
    return self.expenseOffset.y;
}

- (void)setIncomeVerticalOffset:(CGFloat)incomeVerticalOffset
{
    self.incomeOffset = CGPointMake(0, incomeVerticalOffset);
}

- (CGFloat)incomeVerticalOffset
{
    return self.incomeOffset.y;
}

- (void)setEventColor:(UIColor *)eventColor
{
    self.eventDefaultColor = eventColor;
}

- (UIColor *)eventColor
{
    return self.eventDefaultColor;
}

- (void)setCellShape:(FSCalendarCellShape)cellShape
{
    self.borderRadius = 1-cellShape;
}

- (FSCalendarCellShape)cellShape
{
    return self.borderRadius==1.0?FSCalendarCellShapeCircle:FSCalendarCellShapeRectangle;
}

- (void)setTitleTextSize:(CGFloat)titleTextSize
{
    self.titleFont = [UIFont fontWithName:self.titleFont.fontName size:titleTextSize];
}

- (void)setExpenseTextSize:(CGFloat)expenseTextSize
{
    self.expenseFont = [UIFont fontWithName:self.expenseFont.fontName size:expenseTextSize];
}

- (void)setIncomeTextSize:(CGFloat)incomeTextSize
{
    self.incomeFont = [UIFont fontWithName:self.incomeFont.fontName size:incomeTextSize];
}

- (void)setWeekdayTextSize:(CGFloat)weekdayTextSize
{
    self.weekdayFont = [UIFont fontWithName:self.weekdayFont.fontName size:weekdayTextSize];
}

- (void)setHeaderTitleTextSize:(CGFloat)headerTitleTextSize
{
    self.headerTitleFont = [UIFont fontWithName:self.headerTitleFont.fontName size:headerTitleTextSize];
}

- (void)invalidateAppearance
{
    [self.calendar setNeedsConfigureAppearance];
}

- (void)setAdjustsFontSizeToFitContentSize:(BOOL)adjustsFontSizeToFitContentSize {}
- (BOOL)adjustsFontSizeToFitContentSize { return YES; }

@end


