//
//  TFY_IndexView.m
//  TFY_LayoutCategoryUtil
//
//  Created by 田风有 on 2022/6/8.
//  Copyright © 2022 田风有. All rights reserved.
//

#import "TFY_IndexView.h"

#define kIndexViewSpace (self.configuration.indexItemHeight + self.configuration.indexItemsSpace)
#define kIndexViewMargin ((self.bounds.size.height - kIndexViewSpace * self.dataSource.count) / 2)

static NSTimeInterval kAnimationDuration = 0.25;
static void * kIndexViewContext = &kIndexViewContext;
static NSString *kFrameStringFromSelector = @"frame";
static NSString *kCenterStringFromSelector = @"center";
static NSString *kContentOffsetStringFromSelector = @"contentOffset";

// 根据section值获取CATextLayer的中心点y值
static inline CGFloat GetTextLayerCenterY(NSUInteger position, CGFloat margin, CGFloat space)
{
    return margin + (position + 1.0 / 2) * space;
}

// 根据y值获取CATextLayer的section值
static inline NSInteger PositionOfTextLayerInY(CGFloat y, CGFloat margin, CGFloat space)
{
    CGFloat position = (y - margin) / space - 1.0 / 2;
    if (position <= 0) return 0;
    NSUInteger bigger = (NSUInteger)ceil(position);
    NSUInteger smaller = bigger - 1;
    CGFloat biggerCenterY = GetTextLayerCenterY(bigger, margin, space);
    CGFloat smallerCenterY = GetTextLayerCenterY(smaller, margin, space);
    return biggerCenterY + smallerCenterY > 2 * y ? smaller : bigger;
}

@interface TFY_IndexView ()

@property (nonatomic, strong) CAShapeLayer *searchLayer;
@property (nonatomic, strong) NSMutableArray<CATextLayer *> *subTextLayers;
@property (nonatomic, strong) UILabel *indicator;
@property (nonatomic, strong) UITableView *tableView;

// tableView是否实现cellHeight的代理方法
@property (nonatomic, assign) BOOL tableViewHasCellHeightMethod;
// 触摸索引视图
@property (nonatomic, assign, getter=isTouchingIndexView) BOOL touchingIndexView;

/** 触感反馈 */
@property (nonatomic, strong) UIImpactFeedbackGenerator *generator NS_AVAILABLE_IOS(10_0);
@end

@implementation TFY_IndexView

#pragma mark - Life Cycle

- (instancetype)initWithTableView:(UITableView *)tableView configuration:(TFY_IndexViewConfiguration *)configuration
{
    if (self = [super initWithFrame:tableView.frame]) {
        _tableView = tableView;
        _currentSection = NSUIntegerMax;
        _configuration = configuration;
        _translucentForTableViewInNavigationBar = YES;
        _tableViewHasCellHeightMethod = self.tableView.delegate && [self.tableView.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
        
        [self addSubview:self.indicator];
        
        [tableView addObserver:self forKeyPath:kFrameStringFromSelector options:NSKeyValueObservingOptionNew context:kIndexViewContext];
        [tableView addObserver:self forKeyPath:kCenterStringFromSelector options:NSKeyValueObservingOptionNew context:kIndexViewContext];
        [tableView addObserver:self forKeyPath:kContentOffsetStringFromSelector options:NSKeyValueObservingOptionNew context:kIndexViewContext];
    }
    return self;
}

- (void)dealloc
{
    [self.tableView removeObserver:self forKeyPath:kFrameStringFromSelector];
    [self.tableView removeObserver:self forKeyPath:kCenterStringFromSelector];
    [self.tableView removeObserver:self forKeyPath:kContentOffsetStringFromSelector];
}

- (void)configSubLayersAndSubviews
{
    BOOL hasSearchLayer = [self.dataSource.firstObject isEqualToString:UITableViewIndexSearch];
    NSUInteger deta = 0;
    if (hasSearchLayer) {
        self.searchLayer = [self createSearchLayer];
        [self.layer addSublayer:self.searchLayer];
        deta = 1;
    } else if (self.searchLayer) {
        [self.searchLayer removeFromSuperlayer];
        self.searchLayer = nil;
    }
    
    NSInteger countDifference = self.dataSource.count - deta - self.subTextLayers.count;
    if (countDifference > 0) {
        for (int i = 0; i < countDifference; i++) {
            CATextLayer *textLayer = [CATextLayer layer];
            [self.layer addSublayer:textLayer];
            [self.subTextLayers addObject:textLayer];
        }
    } else {
        for (int i = 0; i < -countDifference; i++) {
            CATextLayer *textLayer = self.subTextLayers.lastObject;
            [textLayer removeFromSuperlayer];
            [self.subTextLayers removeObject:textLayer];
        }
    }
    
    CGFloat space = kIndexViewSpace;
    CGFloat margin = kIndexViewMargin;
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    if (hasSearchLayer) {
        self.searchLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, GetTextLayerCenterY(0, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
        self.searchLayer.cornerRadius = self.configuration.indexItemHeight / 2;
        self.searchLayer.contentsScale = UIScreen.mainScreen.scale;
        self.searchLayer.backgroundColor = self.configuration.indexItemBackgroundColor.CGColor;
    }
    
    for (int i = 0; i < self.subTextLayers.count; i++) {
        CATextLayer *textLayer = self.subTextLayers[i];
        NSUInteger section = i + deta;
        textLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, GetTextLayerCenterY(section, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
        textLayer.string = self.dataSource[section];
        textLayer.fontSize = self.configuration.indexItemHeight * 0.8;
        textLayer.cornerRadius = self.configuration.indexItemHeight / 2;
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = UIScreen.mainScreen.scale;
        textLayer.backgroundColor = self.configuration.indexItemBackgroundColor.CGColor;
        textLayer.foregroundColor = self.configuration.indexItemTextColor.CGColor;
    }
    [CATransaction commit];
    
    if (self.subTextLayers.count == 0) {
        self.currentSection = NSUIntegerMax;
    } else if (self.currentSection == NSUIntegerMax) {
        self.currentSection = self.searchLayer ? TFY_IndexViewSearchSection : 0;
    } else {
        self.currentSection = self.subTextLayers.count - 1;
    }
}

- (void)configCurrentSection
{
    NSInteger currentSection = TFY_IndexViewInvalidSection;
    if (self.delegate && [self.delegate respondsToSelector:@selector(sectionOfIndexView:tableViewDidScroll:)]) {
        currentSection = [self.delegate sectionOfIndexView:self tableViewDidScroll:self.tableView];
        if ((currentSection >= 0 && currentSection != TFY_IndexViewInvalidSection)
            || currentSection == TFY_IndexViewSearchSection) {
            self.currentSection = currentSection;
            return;
        }
    }
    
    NSInteger firstVisibleSection = self.tableView.indexPathsForVisibleRows.firstObject.section;
    CGFloat insetHeight = 0;
    if (!self.translucentForTableViewInNavigationBar) {
        currentSection = firstVisibleSection;
    } else {
        insetHeight = UIApplication.sharedApplication.statusBarFrame.size.height + 44;
        for (NSInteger section = firstVisibleSection; section < self.tableView.numberOfSections; section++) {
            CGRect sectionFrame = [self.tableView rectForSection:section];
            if (sectionFrame.origin.y + sectionFrame.size.height - self.tableView.contentOffset.y >= insetHeight) {
                currentSection = section;
                break;
            }
        }
    }
    
    BOOL selectSearchLayer = NO;
    if (currentSection == 0 && self.searchLayer) {
        CGRect sectionFrame = [self.tableView rectForSection:currentSection];
        selectSearchLayer = (sectionFrame.origin.y - self.tableView.contentOffset.y - insetHeight) > 0;
    }
    
    if (selectSearchLayer) {
        currentSection = TFY_IndexViewSearchSection;
    }
    else {
        currentSection = currentSection - self.startSection;
    }
    
    self.currentSection = currentSection;
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context != kIndexViewContext) return;
    
    if ([keyPath isEqualToString:kCenterStringFromSelector] || [keyPath isEqualToString:kFrameStringFromSelector]) {
        self.frame = self.tableView.frame;
        
        CGFloat space = kIndexViewSpace;
        CGFloat margin = kIndexViewMargin;
        
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        if (self.searchLayer) {
            self.searchLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, GetTextLayerCenterY(0, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
            self.searchLayer.cornerRadius = self.configuration.indexItemHeight / 2;
            self.searchLayer.contentsScale = UIScreen.mainScreen.scale;
            self.searchLayer.backgroundColor = self.configuration.indexItemBackgroundColor.CGColor;
        }
        
        NSInteger deta = self.searchLayer ? 1 : 0;
        for (int i = 0; i < self.subTextLayers.count; i++) {
            CATextLayer *textLayer = self.subTextLayers[i];
            NSUInteger section = i + deta;
            textLayer.frame = CGRectMake(self.bounds.size.width - self.configuration.indexItemRightMargin - self.configuration.indexItemHeight, GetTextLayerCenterY(section, margin, space) - self.configuration.indexItemHeight / 2, self.configuration.indexItemHeight, self.configuration.indexItemHeight);
        }
        [CATransaction commit];
    } else if ([keyPath isEqualToString:kContentOffsetStringFromSelector]) {
        [self onActionWithScroll];
    }
}

#pragma mark - Event Response

- (void)onActionWithDidSelect
{
    if ((self.currentSection < 0 && self.currentSection != TFY_IndexViewSearchSection)
        || self.currentSection >= (NSInteger)self.subTextLayers.count) {
        return;
    }
    
    if (self.currentSection == TFY_IndexViewSearchSection) {
        CGFloat insetHeight = self.translucentForTableViewInNavigationBar ? UIApplication.sharedApplication.statusBarFrame.size.height + 44 : 0;
        [self.tableView setContentOffset:CGPointMake(0, -insetHeight) animated:NO];
    } else {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:self.currentSection + self.startSection];
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
    
    if (self.isTouchingIndexView) {
        if (@available(iOS 10.0, *)) {
            [self.generator prepare];
            [self.generator impactOccurred];
        }
    }
}

- (void)onActionWithScroll
{
    if (self.isTouchingIndexView) {
        // 当滑动tableView视图时，另一手指滑动索引视图，让tableView滑动失效
        self.tableView.panGestureRecognizer.enabled = NO;
        self.tableView.panGestureRecognizer.enabled = YES;
        
        return; // 当滑动索引视图时，tableView滚动不能影响索引位置
    }
    
    // 可能tableView的contentOffset变化，却没有scroll，此时不应该影响索引位置
    BOOL isScrolling = self.tableView.isDragging || self.tableView.isDecelerating;
    if (!isScrolling) return;
    
    [self configCurrentSection];
}

#pragma mark - Display

- (UIBezierPath *)drawIndicatorPath
{
    CGFloat indicatorRadius = self.configuration.indicatorHeight / 2;
    CGFloat sinPI_4_Radius = sin(M_PI_4) * indicatorRadius;
    CGFloat margin = (sinPI_4_Radius * 2 - indicatorRadius);
    
    CGPoint startPoint = CGPointMake(margin + indicatorRadius + sinPI_4_Radius, indicatorRadius - sinPI_4_Radius);
    CGPoint trianglePoint = CGPointMake(4 * sinPI_4_Radius, indicatorRadius);
    CGPoint centerPoint = CGPointMake(margin + indicatorRadius, indicatorRadius);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addArcWithCenter:centerPoint radius:indicatorRadius startAngle:-M_PI_4 endAngle:M_PI_4 clockwise:NO];
    [bezierPath addLineToPoint:trianglePoint];
    [bezierPath addLineToPoint:startPoint];
    [bezierPath closePath];
    return bezierPath;
}

- (CAShapeLayer *)createSearchLayer
{
    CGFloat radius = self.configuration.indexItemHeight / 4;
    CGFloat margin = self.configuration.indexItemHeight / 4;
    CGFloat start = radius * 2.5 + margin;
    CGFloat end = radius + sin(M_PI_4) * radius + margin;
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(start, start)];
    [path addLineToPoint:CGPointMake(end, end)];
    [path addArcWithCenter:CGPointMake(radius + margin, radius + margin) radius:radius startAngle:M_PI_4 endAngle:2 * M_PI + M_PI_4 clockwise:YES];
    [path closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = self.configuration.indexItemBackgroundColor.CGColor;
    layer.strokeColor = self.configuration.indexItemTextColor.CGColor;
    layer.contentsScale = [UIScreen mainScreen].scale;
    layer.lineWidth = self.configuration.indexItemHeight / 12;
    layer.path = path.CGPath;
    return layer;
}

- (void)showIndicator:(BOOL)animated
{
    if (!self.indicator.hidden || self.currentSection < 0 || self.currentSection >= (NSInteger)self.subTextLayers.count) return;
    
    CATextLayer *textLayer = self.subTextLayers[self.currentSection];
    if (self.configuration.indexViewStyle == TFY_IndexViewStyleDefault) {
        self.indicator.center = CGPointMake(self.bounds.size.width - self.indicator.bounds.size.width / 2 - self.configuration.indicatorRightMargin, textLayer.position.y);
    } else {
        self.indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    }
    self.indicator.text = textLayer.string;
    
    if (animated) {
        self.indicator.alpha = 0;
        self.indicator.hidden = NO;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.indicator.alpha = 1;
        }];
    } else {
        self.indicator.alpha = 1;
        self.indicator.hidden = NO;
    }
}

- (void)hideIndicator:(BOOL)animated
{
    if (self.indicator.hidden) return;
    
    if (animated) {
        self.indicator.alpha = 1;
        self.indicator.hidden = NO;
        [UIView animateWithDuration:kAnimationDuration animations:^{
            self.indicator.alpha = 0;
        } completion:^(BOOL finished) {
            self.indicator.alpha = 1;
            self.indicator.hidden = YES;
        }];
    } else {
        self.indicator.alpha = 1;
        self.indicator.hidden = YES;
    }
}

- (void)refreshTextLayer:(BOOL)selected
{
    if (self.currentSection < 0 || self.currentSection >= (NSInteger)self.subTextLayers.count) return;
    
    CATextLayer *textLayer = self.subTextLayers[self.currentSection];
    UIColor *backgroundColor, *foregroundColor;
    if (selected) {
        backgroundColor = self.configuration.indexItemSelectedBackgroundColor;
        foregroundColor = self.configuration.indexItemSelectedTextColor;
    } else {
        backgroundColor = self.configuration.indexItemBackgroundColor;
        foregroundColor = self.configuration.indexItemTextColor;
    }
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    textLayer.backgroundColor = backgroundColor.CGColor;
    textLayer.foregroundColor = foregroundColor.CGColor;
    [CATransaction commit];
}

#pragma mark - UITouch and UIEvent

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    // 当滑动索引视图时，防止其他手指去触发事件
    if (self.touchingIndexView) return YES;
    
    CALayer *firstLayer = self.searchLayer ?: self.subTextLayers.firstObject;
    if (!firstLayer) return NO;
    CALayer *lastLayer = self.subTextLayers.lastObject ?: self.searchLayer;
    if (!lastLayer) return NO;
    
    CGFloat space = self.configuration.indexItemRightMargin * 2;
    if (point.x > self.bounds.size.width - space - self.configuration.indexItemHeight
        && point.y > CGRectGetMinY(firstLayer.frame) - space
        && point.y < CGRectGetMaxY(lastLayer.frame) + space) {
        return YES;
    }
    return NO;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchingIndexView = YES;
    CGPoint location = [touch locationInView:self];
    NSInteger currentPosition = PositionOfTextLayerInY(location.y, kIndexViewMargin, kIndexViewSpace);
    if (currentPosition < 0 || currentPosition >= (NSInteger)self.dataSource.count) return YES;
    
    NSInteger deta = self.searchLayer ? 1 : 0;
    NSInteger currentSection = currentPosition - deta;
    [self hideIndicator:NO];
    self.currentSection = currentSection;
    [self showIndicator:YES];
    [self onActionWithDidSelect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexView:didSelectAtSection:)]) {
        [self.delegate indexView:self didSelectAtSection:self.currentSection];
    }
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchingIndexView = YES;
    CGPoint location = [touch locationInView:self];
    NSInteger currentPosition = PositionOfTextLayerInY(location.y, kIndexViewMargin, kIndexViewSpace);
    
    if (currentPosition < 0) {
        currentPosition = 0;
    } else if (currentPosition >= (NSInteger)self.dataSource.count) {
        currentPosition = self.dataSource.count - 1;
    }
    
    NSInteger deta = self.searchLayer ? 1 : 0;
    NSInteger currentSection = currentPosition - deta;
    if (currentSection == self.currentSection) return YES;
    
    [self hideIndicator:NO];
    self.currentSection = currentSection;
    [self showIndicator:NO];
    [self onActionWithDidSelect];
    if (self.delegate && [self.delegate respondsToSelector:@selector(indexView:didSelectAtSection:)]) {
        [self.delegate indexView:self didSelectAtSection:self.currentSection];
    }
    return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
    self.touchingIndexView = NO;
    [self hideIndicator:YES];
}

- (void)cancelTrackingWithEvent:(UIEvent *)event
{
    self.touchingIndexView = NO;
    [self hideIndicator:YES];
}

#pragma mark - Getters and Setters

- (void)setDataSource:(NSArray<NSString *> *)dataSource
{
    if (_dataSource == dataSource) return;
    
    _dataSource = dataSource.copy;
    
    [self configSubLayersAndSubviews];
    [self configCurrentSection];
}

- (void)setCurrentSection:(NSInteger)currentSection
{
    if (currentSection == _currentSection) return;
    if ((currentSection < 0 && currentSection != TFY_IndexViewSearchSection)
        || currentSection >= (NSInteger)self.subTextLayers.count) {
        [self refreshTextLayer:NO];
        return;
    }
    
    [self refreshTextLayer:NO];
    _currentSection = currentSection;
    [self refreshTextLayer:YES];
}

- (void)setStartSection:(NSUInteger)startSection {
    if (_startSection == startSection) return;
    _startSection = startSection;
    [self configCurrentSection];
}

- (NSMutableArray *)subTextLayers
{
    if (!_subTextLayers) {
        _subTextLayers = [NSMutableArray array];
    }
    return _subTextLayers;
}

- (UILabel *)indicator
{
    if (!_indicator) {
        _indicator = [UILabel new];
        _indicator.layer.backgroundColor = self.configuration.indicatorBackgroundColor.CGColor;
        _indicator.textColor = self.configuration.indicatorTextColor;
        _indicator.font = self.configuration.indicatorTextFont;
        _indicator.textAlignment = NSTextAlignmentCenter;
        _indicator.hidden = YES;
        
        switch (self.configuration.indexViewStyle) {
            case TFY_IndexViewStyleDefault:
            {
                CGFloat indicatorRadius = self.configuration.indicatorHeight / 2;
                CGFloat sinPI_4_Radius = sin(M_PI_4) * indicatorRadius;
                _indicator.bounds = CGRectMake(0, 0, (4 * sinPI_4_Radius), 2 * indicatorRadius);
                
                CAShapeLayer *maskLayer = [CAShapeLayer layer];
                maskLayer.path = [self drawIndicatorPath].CGPath;
                _indicator.layer.mask = maskLayer;
            }
                break;
                
            case TFY_IndexViewStyleCenterToast:
            {
                _indicator.bounds = CGRectMake(0, 0, self.configuration.indicatorHeight, self.configuration.indicatorHeight);
                _indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
                _indicator.layer.cornerRadius = self.configuration.indicatorCornerRadius;
            }
                break;
                
            default:
                break;
        }
    }
    return _indicator;
}

- (UIImpactFeedbackGenerator *)generator {
    if (!_generator) {
        _generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
    }
    return _generator;
}

@end
