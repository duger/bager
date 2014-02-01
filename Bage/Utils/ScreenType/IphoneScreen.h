



#define IS_IPHONE5 (([[[UIDevice  currentDevice]systemVersion]floatValue]>=7) ? YES : NO)

#define ScreenHeight (IS_IPHONE5SCREEN ? 548.0 : 460.0)

#define IS_IPHONE5SCREEN ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
