#import <UIKit/UIKit.h>

// ==========================================
// ✏️ قسم التعديل السريع (المعلومات والروابط)
// ==========================================
static NSString * const kAlertTitle      = @"اســتـمـتـع";
static NSString * const kAlertMessage    = @"التراث ستور عالم خيالي من تطبيقات";
static NSString * const kButtonJoinTitle = @"☑ تفعيل المميزات";
static NSString * const kButtonOKTitle   = @"حسناً";
static NSString * const kChannelURL      = @"tg://resolve?domain=turath_st";
// ==========================================

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

    // تجنب تكرار عرض النافذة إذا كانت معروضة بالفعل
    if ([keyWindow viewWithTag:998877]) return;

    // Dimmed Background Container
    UIView *bgOverlay = [[UIView alloc] initWithFrame:keyWindow.bounds];
    bgOverlay.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    bgOverlay.tag = 998877;
    bgOverlay.alpha = 0.0;

    // Main Alert Container View (Dark Navy Theme)
    CGFloat alertWidth = MIN(keyWindow.bounds.size.width - 50, 340);
    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = [UIColor colorWithRed:0.11 green:0.13 blue:0.16 alpha:1.0]; // كحلي داكن احترافي
    alertView.layer.cornerRadius = 18;
    alertView.layer.masksToBounds = YES;
    alertView.translatesAutoresizingMaskIntoConstraints = NO;
    [bgOverlay addSubview:alertView];

    // 1. Top Bar with Traffic Light Dots (Red, Yellow, Green)
    UIView *dotsContainer = [[UIView alloc] init];
    dotsContainer.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:dotsContainer];

    NSArray *dotColors = @[
        [UIColor colorWithRed:0.98 green:0.36 blue:0.35 alpha:1.0], // Red
        [UIColor colorWithRed:0.99 green:0.76 blue:0.18 alpha:1.0], // Yellow
        [UIColor colorWithRed:0.24 green:0.78 blue:0.36 alpha:1.0]  // Green
    ];

    for (int i = 0; i < 3; i++) {
        UIView *dot = [[UIView alloc] initWithFrame:CGRectMake(i * 18, 0, 11, 11)];
        dot.backgroundColor = dotColors[i];
        dot.layer.cornerRadius = 5.5;
        [dotsContainer addSubview:dot];
    }

    // 2. Title Label (Mint / Gold Highlight)
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = kAlertTitle;
    titleLabel.font = [UIFont boldSystemFontOfSize:22];
    titleLabel.textColor = [UIColor colorWithRed:0.08 green:0.18 blue:0.36 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:titleLabel];

    // 3. Message Label
    UILabel *msgLabel = [[UILabel alloc] init];
    msgLabel.text = kAlertMessage;
    msgLabel.font = [UIFont systemFontOfSize:15 weight:UIFontWeightMedium];
    msgLabel.textColor = [UIColor colorWithWhite:0.92 alpha:1.0];
    msgLabel.textAlignment = NSTextAlignmentCenter;
    msgLabel.numberOfLines = 0;
    msgLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:msgLabel];

    // Separator Line 1
    UIView *sep1 = [[UIView alloc] init];
    sep1.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
    sep1.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:sep1];

    // 4. Join Channel Button
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [joinBtn setTitle:kButtonJoinTitle forState:UIControlStateNormal];
    [joinBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.68 blue:0.98 alpha:1.0] forState:UIControlStateNormal]; // أزرق بارز
    joinBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightSemibold];
    joinBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [joinBtn addTarget:self action:@selector(didTapJoin:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:joinBtn];

    // Separator Line 2
    UIView *sep2 = [[UIView alloc] init];
    sep2.backgroundColor = [UIColor colorWithWhite:0.25 alpha:0.5];
    sep2.translatesAutoresizingMaskIntoConstraints = NO;
    [alertView addSubview:sep2];

    // 5. Dismiss Button
    UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [okBtn setTitle:kButtonOKTitle forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithRed:0.38 green:0.68 blue:0.98 alpha:1.0] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    okBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [okBtn addTarget:self action:@selector(didTapDismiss:) forControlEvents:UIControlEventTouchUpInside];
    [alertView addSubview:okBtn];

    // Auto Layout Constraints Setup
    [NSLayoutConstraint activateConstraints:@[
        [alertView.centerXAnchor constraintEqualToAnchor:bgOverlay.centerXAnchor],
        [alertView.centerYAnchor constraintEqualToAnchor:bgOverlay.centerYAnchor],
        [alertView.widthAnchor constraintEqualToConstant:alertWidth],

        // Dots Container
        [dotsContainer.topAnchor constraintEqualToAnchor:alertView.topAnchor constant:14],
        [dotsContainer.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:16],
        [dotsContainer.widthAnchor constraintEqualToConstant:50],
        [dotsContainer.heightAnchor constraintEqualToConstant:12],

        // Title
        [titleLabel.topAnchor constraintEqualToAnchor:dotsContainer.bottomAnchor constant:10],
        [titleLabel.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:16],
        [titleLabel.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor constant:-16],

        // Message
        [msgLabel.topAnchor constraintEqualToAnchor:titleLabel.bottomAnchor constant:10],
        [msgLabel.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor constant:16],
        [msgLabel.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor constant:-16],

        // Sep 1
        [sep1.topAnchor constraintEqualToAnchor:msgLabel.bottomAnchor constant:18],
        [sep1.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [sep1.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [sep1.heightAnchor constraintEqualToConstant:0.5],

        // Join Button
        [joinBtn.topAnchor constraintEqualToAnchor:sep1.bottomAnchor],
        [joinBtn.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [joinBtn.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [joinBtn.heightAnchor constraintEqualToConstant:48],

        // Sep 2
        [sep2.topAnchor constraintEqualToAnchor:joinBtn.bottomAnchor],
        [sep2.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [sep2.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [sep2.heightAnchor constraintEqualToConstant:0.5],

        // OK Button
        [okBtn.topAnchor constraintEqualToAnchor:sep2.bottomAnchor],
        [okBtn.leadingAnchor constraintEqualToAnchor:alertView.leadingAnchor],
        [okBtn.trailingAnchor constraintEqualToAnchor:alertView.trailingAnchor],
        [okBtn.heightAnchor constraintEqualToConstant:48],
        [okBtn.bottomAnchor constraintEqualToAnchor:alertView.bottomAnchor]
    ]];

    [keyWindow addSubview:bgOverlay];

    // Animation Fade In & Scale Up
    alertView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 animations:^{
        bgOverlay.alpha = 1.0;
        alertView.transform = CGAffineTransformIdentity;
    }];
}

+ (void)didTapJoin:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:kChannelURL];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
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
