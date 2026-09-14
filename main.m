#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

// ==========================================
// ✏️ قسم التعديل السريع (المعلومات والروابط)
// ==========================================
static NSString * const kAlertTitle      = @"اســتـمـتـع";
static NSString * const kAlertMessage    = @"التراث ستور عالم خيالي من تطبيقات";
static NSString * const kButtonJoinTitle = @"تفعيل المميزات ☑";
static NSString * const kButtonOKTitle   = @"حسناً";
static NSString * const kChannelURL      = @"tg://resolve?domain=turath_st";
static NSString * const kFallbackURL     = @"https://t.me/turath_st";
static NSString * const kGifURL          = @"https://raw.githubusercontent.com/Ham8d/Stcker.gif/refs/heads/main/IMG_6672.gif";
// ==========================================

// دالة مساعدة لتحويل بيانات الـ GIF إلى صور متحركة أصلية في iOS
@interface UIImage (AnimatedGIF)
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data;
@end

@implementation UIImage (AnimatedGIF)
+ (UIImage *)animatedImageWithAnimatedGIFData:(NSData *)data {
    if (!data) return nil;
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    size_t count = CGImageSourceGetCount(source);
    if (count <= 1) {
        if (source) CFRelease(source);
        return [[UIImage alloc] initWithData:data];
    }
    NSMutableArray *images = [NSMutableArray array];
    NSTimeInterval duration = 0.0f;
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        if (!image) continue;
        
        NSDictionary *dict = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(source, i, NULL);
        NSDictionary *gifDict = dict[(NSString *)kCGImagePropertyGIFDictionary];
        NSNumber *delayTime = gifDict[(NSString *)kCGImagePropertyGIFUnclampedDelayTime];
        if (!delayTime) {
            delayTime = gifDict[(NSString *)kCGImagePropertyGIFDelayTime];
        }
        duration += [delayTime doubleValue];
        [images addObjectsFromArray:@[[UIImage imageWithCGImage:image]]];
        CGImageRelease(image);
    }
    if (duration <= 0.0f) {
        duration = (1.0f / 10.0f) * count;
    }
    UIImage *animatedImage = [UIImage animatedImageWithImages:images duration:duration];
    if (source) CFRelease(source);
    return animatedImage;
}
@end

@interface CustomTurathAlertView : UIView
@end

@implementation CustomTurathAlertView

+ (void)show {
    UIWindow *keyWindow = nil;
    for (UIWindow *w in [UIApplication sharedApplication].windows) {
        if (w.isKeyWindow) {
            keyWindow = w;
            break;
        }
    }
    if (!keyWindow) return;

    if ([keyWindow viewWithTag:998877]) return;

    UIView *bgOverlay = [[UIView alloc] initWithFrame:keyWindow.bounds];
    bgOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    bgOverlay.tag = 998877;
    bgOverlay.alpha = 0.0;

    CGFloat alertWidth = MIN(keyWindow.bounds.size.width - 50, 340);
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = [UIColor colorWithRed:0.11 green:0.13 blue:0.16 alpha:1.0];
    alertView.layer.cornerRadius = 18;
    alertView.layer.masksToBounds = YES;
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    [bgOverlay addSubview:alertView];

    UIView *dotsContainer = [[UIView alloc] init];
    dotsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:dotsContainer];

    NSArray *dotColors = @[
        [UIColor colorWithRed:0.98 green:0.36 blue:0.35 alpha:1.0],
        [UIColor colorWithRed:0.99 green:0.76 blue:0.18 alpha:1.0],
        [UIColor colorWithRed:0.24 green:0.78 blue:0.36 alpha:1.0]
    ];

    for (int i = 0; i < 3; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(i * 18, 0, 11, 11)];
        dot.backgroundColor = dotColors[i];
        dot.layer.cornerRadius = 5.5;
        [dotsContainer addSubview:dot];
    }

    UIView *headerContainer = [[UIView alloc] init];
    headerContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:headerContainer];

    // العنوان أولاً ليكون في الجهة المقابلة
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = kAlertTitle;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor colorWithRed:0.40 green:0.65 blue:0.95 alpha:1.0];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerContainer addSubview:titleLabel];

    // الملصق المتحرك بحجم أكبر بـ 10% (35x35) وفي الجهة الأخرى
    UIImageView *gifImageView = [[UIImageView alloc] init];
    gifImageView.contentMode = UIViewContentModeScaleAspectFit;
    gifImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [headerContainer addSubview:gifImageView];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *gifData = [NSData dataWithContentsOfURL:[NSURL URLWithString:kGifURL]];
        if (gifData) {
            UIImage *gifImage = [UIImage animatedImageWithAnimatedGIFData:gifData];
            dispatch_async(dispatch_get_main_queue(), ^{
                gifImageView.image = gifImage;
            });
        }
    });

    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.text = kAlertMessage;
    msgLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    msgLabel.textColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 0;
    msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:msgLabel];

    UIView *sep1 = [[UIView alloc] init];
    sep1.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
    sep1.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:sep1];

    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [joinBtn setTitle:kButtonJoinTitle forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.68 blue:0.98 alpha:1.0] forState:UIControlStateNormal];
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    joinBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [joinBtn addTarget:self action:@selector(didTapJoin:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:joinBtn];

    UIView *sep2 = [[UIView alloc] init];
    sep2.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
    sep2.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:sep2];

    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [okBtn setTitle:kButtonOKTitle forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.68 blue:0.98 alpha:1.0] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [okBtn addTarget:self action:@selector(didTapDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:okBtn];

    [NSLayoutConstraint activateConstraints:@[
        [alertView.centerXAnchor constraintEqualToAnchor:bgOverlay.centerXAnchor],
        [alertView.centerYAnchor constraintEqualToAnchor:bgOverlay.centerYAnchor],
        [alertView.widthAnchor constraintEqualToConstant:alertWidth],

        [dotsContainer.topAnchor constraintEqualToAnchor:alertView.topAnchor constant:14],
        [dotsContainer.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:16],
        [dotsContainer.widthAnchor constraintEqualToConstant:50],
        [dotsContainer.heightAnchor constraintEqualToConstant:12],

        [headerContainer.topAnchor constraintEqualToAnchor:dotsContainer.bottomAnchor constant:10],
        [headerContainer.centerXAnchor constraintEqualToAnchor:alertView.centerXAnchor],
        [headerContainer.heightAnchor constraintEqualToConstant:35],

        // Title Label في البداية
        [titleLabel.leadingAnchor constraintEqualToAnchor:headerContainer.leadingAnchor],
        [titleLabel.centerYAnchor constraintEqualToAnchor:headerContainer.centerYAnchor],

        // GIF Image بجانب العنوان من الجهة الأخرى وبحجم 35x35
        [gifImageView.leadingAnchor constraintEqualToAnchor:titleLabel.trailingAnchor constant:8],
        [gifImageView.trailingAnchor constraintEqualToAnchor:headerContainer.trailingAnchor],
        [gifImageView.centerYAnchor constraintEqualToAnchor:headerContainer.centerYAnchor],
        [gifImageView.widthAnchor constraintEqualToConstant:35],
        [gifImageView.heightAnchor constraintEqualToConstant:35],

        [msgLabel.topAnchor constraintEqualToAnchor:headerContainer.bottomAnchor constant:12],
        [msgLabel.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:16],
        [msgLabel.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor constant:-16],

        [sep1.topAnchor constraintEqualToAnchor:msgLabel.bottomAnchor constant:18],
        [sep1.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [sep1.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [sep1.heightAnchor constraintEqualToConstant:0.5],

        [joinBtn.topAnchor constraintEqualToAnchor:sep1.bottomAnchor],
        [joinBtn.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [joinBtn.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [joinBtn.heightAnchor constraintEqualToConstant:48],

        [sep2.topAnchor constraintEqualToAnchor:joinBtn.bottomAnchor],
        [sep2.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [sep2.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [sep2.heightAnchor constraintEqualToConstant:0.5],

        [okBtn.topAnchor constraintEqualToAnchor:sep2.bottomAnchor],
        [okBtn.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [okBtn.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [okBtn.heightAnchor constraintEqualToConstant:48],
        [okBtn.bottomAnchor constraintEqualToAnchor:alertView.bottomAnchor]
    ]];

    [keyWindow addSubview:bgOverlay];

    alertView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 animations:^{
        bgOverlay.alpha = 1.0;
        alertView.transform = CGAffineTransformIdentity;
    }];
}

+ (void)didTapJoin:(UIButton *)sender {
    NSURL *primaryURL = [NSURL URLWithString:kChannelURL];
    NSURL *fallbackURL = [NSURL URLWithString:kFallbackURL];

    if ([[UIApplication sharedApplication] canOpenURL:primaryURL]) {
        [[UIApplication sharedApplication] openURL:primaryURL options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:fallbackURL options:@{} completionHandler:nil];
    }
}

+ (void)didTapDismiss:(UIButton *)sender {
    UIView *bgOverlay = [sender superview];
    while (bgOverlay && bgOverlay.tag != 998877) {
        bgOverlay = bgOverlay.superview;
    }

    [UIView animateWithDuration:0.2 animations:^{
        bgOverlay.alpha = 0.0;
    } completion:^(BOOL finished) {
        [bgOverlay removeFromSuperview];
    }];
}

@end

__attribute__((constructor))
static void initTweak(void) {
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidBecomeActiveNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [CustomTurathAlertView show];
        });
    }];
}
