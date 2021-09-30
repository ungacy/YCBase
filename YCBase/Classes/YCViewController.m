//
//  YCViewController.m
//  YCBase
//
//  Created by Ye Tao on 05/23/2021.
//  Copyright (c) 2021 Ye Tao. All rights reserved.
//

#import "YCViewController.h"
#import "YCNavigationController.h"
#import <Masonry/Masonry.h>

@interface YCNavigationController ()

@property (nonatomic, assign) BOOL yc_isBeingPresented;

@end

@interface YCViewController ()

@property (nonatomic, assign) BOOL yc_viewAppeared;

@property (nonatomic, strong) UIColor *yc_previousNaviColor;

@end

@implementation YCViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _reloadWhenAppear = YES;
        _noReloadOnce = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self navigationBarHandler];
    [self defaultUI];
    // Do any additional setup after loading the view.
}

- (void)navigationBarHandler {
    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
        if (self.navigationController.topViewController == self) {
            self.navigationController.navigationBarHidden = _hideNavigationBar;
        }
    }
}

- (void)changeNavigationBarColor {
    if (!self.navigationBarBackgroundColor) {
        return;
    }
    self.yc_previousNaviColor = self.yc_previousNaviColor ?: self.navigationController.navigationBar.barTintColor;
    self.navigationController.navigationBar.backgroundColor = self.navigationBarBackgroundColor;
    self.navigationController.navigationBar.barTintColor = self.navigationBarBackgroundColor;
    if (@available(iOS 13, *)) {
        UINavigationBarAppearance *navBar = self.navigationController.navigationBar.standardAppearance;
        navBar.backgroundColor = self.navigationBarBackgroundColor;
        self.navigationController.navigationBar.standardAppearance = navBar;
        self.navigationController.navigationBar.scrollEdgeAppearance = navBar;
    }
}

- (void)restoreNavigationBarColor {
    if (!self.navigationBarBackgroundColor) {
        return;
    }
    self.navigationController.navigationBar.backgroundColor = self.yc_previousNaviColor;
    self.navigationController.navigationBar.barTintColor = self.yc_previousNaviColor;
    if (@available(iOS 13, *)) {
        UINavigationBarAppearance *navBar = self.navigationController.navigationBar.standardAppearance;
        navBar.backgroundColor = self.yc_previousNaviColor;
        self.navigationController.navigationBar.standardAppearance = navBar;
        self.navigationController.navigationBar.scrollEdgeAppearance = navBar;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self changeNavigationBarColor];
    self.yc_viewAppeared = YES;
    [self navigationBarHandler];
    if (_noReloadOnce) {
        _noReloadOnce = NO;
        return;
    }
    if (_reloadWhenAppear || _reloadOnce) {
        [self loadData];
        _reloadOnce = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.yc_viewAppeared = NO;
    [self.view endEditing:YES];
    [self restoreNavigationBarColor];
}

- (void)loadData {
}

- (void)defaultUI {
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.navigationController.isBeingPresented) {
        self.navigationItem.leftBarButtonItem = [self barItemWithImage:self.navigationController.navigationBar.backIndicatorImage selector:@selector(goBack)];
        return;
    }
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > 1 && viewControllers.lastObject == self) {
        self.navigationItem.hidesBackButton = YES;
        self.navigationItem.leftBarButtonItem = [self barItemWithImage:self.navigationController.navigationBar.backIndicatorImage selector:@selector(goBack)];
        //修复navigationController侧滑关闭失效的问题
        self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    }
}

- (void)goBack {
    YCNavigationController *navi = (YCNavigationController *)self.navigationController;
    if (navi.yc_isBeingPresented && navi.viewControllers.count == 1) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    [navi popViewControllerAnimated:YES];
}

- (void)backward:(NSUInteger)level {
    NSArray *viewControllers = self.navigationController.viewControllers;
    if (viewControllers.count > level) {
        UIViewController *target = viewControllers[viewControllers.count - level - 1];
        [self.navigationController popToViewController:target animated:YES];
    }
}

#pragma mark Did Set

- (void)setReloadWhenAppear:(BOOL)reloadWhenAppear {
    if (reloadWhenAppear == _reloadWhenAppear) {
        return;
    }
    _reloadWhenAppear = reloadWhenAppear;
    if (!_reloadWhenAppear) {
        [self loadData];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)shouldAutorotate {
    return NO;
}

// Which screen directions are supported.
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    if (!viewControllerToPresent.transitioningDelegate) {
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    }
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end

@implementation YCViewController (YCNavi)

- (UIBarButtonItem *)barItemWithTitle:(NSString *)title selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:selector];
    return item;
}

- (UIBarButtonItem *)barItemWithImage:(UIImage *)image selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:image
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:selector];
    return item;
}

- (UIBarButtonItem *)barItemWithIcon:(NSString *)icon selector:(SEL)selector {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:icon]
                                                             style:UIBarButtonItemStylePlain
                                                            target:self
                                                            action:selector];
    return item;
}

@end
