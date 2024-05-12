#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <rootless.h>
#import "Tweak.h"
#import "libcolorpicker.h"
//#import "Debug.h"


// ====================== Preferences ======================

bool enabled;
bool customImageEnabled;
bool tintEnabled;
NSString *cornFilename;
NSString *tintColorStr;
float opacity;
float offset;
float scale;

// ====================== Globals ======================

NSInteger cornBarWidth = 0;
NSInteger cornBarHeight = 0;
UIImage *cornImage = nil;


UIImage *tintImage(UIImage *image, UIColor *color) {
    // Create a graphics context
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();

    // Flip the coordinate system
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // Draw the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);

    // Apply the tint color to non-transparent pixels
    CGContextSetBlendMode(context, kCGBlendModeColor);
    CGContextClipToMask(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    [color setFill];
    CGContextFillRect(context, CGRectMake(0, 0, image.size.width, image.size.height));

    // Get the tinted image
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();

    // Cleanup
    UIGraphicsEndImageContext();

    return tintedImage;
}




// Loading the image in %ctor caused safemode and
// loading it after springboard is done is too late,
// so just check if it has been loaded before and return it if so
UIImage *GetCornImage() {
	if (cornImage == nil) {
		NSString *imagePath;
		if (customImageEnabled) {
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];
			imagePath = [documentsDirectory stringByAppendingPathComponent:@"cornbar_custom.png"];
			cornImage = [UIImage imageWithContentsOfFile:imagePath];
		}

		// If custom image failed to load, fall back to built in image
		if (!cornImage) {
			imagePath = [NSString stringWithFormat:@"/Library/CornBar/%@", cornFilename];
			imagePath = ROOT_PATH_NS(imagePath);
			cornImage = [UIImage imageWithContentsOfFile:imagePath];
		}

		if (tintEnabled) {
			UIColor *tintColor = LCPParseColorString(tintColorStr, @"#ffffff");
			cornImage = tintImage(cornImage, tintColor);
		}

		cornBarWidth = (int)cornImage.size.width / 4 * scale;
		cornBarHeight = (int)cornImage.size.height / 4 * scale;

		// Safety check in case a custom image is way too big
		if (cornBarHeight > 100)
			cornBarHeight = 100;

		//[Debug Log: [NSString stringWithFormat:@"corn width: %f  height: %f", cornImage.size.width, cornImage.size.height]];
	}
	return cornImage;
}

// ====================== Hooks ======================

%group AllHooks

	%hook MTLumaDodgePillSettings
		-(void)setMinWidth:(double)arg1 {
			//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinWidth:(double)arg1   %f", arg1]];
			if (!cornBarWidth)
				GetCornImage();

			%orig(cornBarWidth);
		}

		-(void)setMaxWidth:(double)arg1 {
			if (!cornBarWidth)
				GetCornImage();

			//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinWidth:(double)arg1   %f", arg1]];
			%orig(cornBarWidth);
		}

		-(void)setHeight:(double)arg1 {
			if (!cornBarHeight)
				GetCornImage();

			//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinHeight:(double)arg1   %f", arg1]];
			%orig(cornBarHeight);
		}

		-(void)setEdgeSpacing:(double)arg1 {
			//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  --(void)setEdgeSpacing:(double)arg1   %f", arg1]];
			%orig(offset);
		}
	%end


	%hook MTLumaDodgePillView
		%property (strong) UIImageView *cornView;

		%new
		-(void)initCorn {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
			imageView.alpha = opacity;
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.frame = CGRectMake(0, 0, cornBarWidth, cornBarHeight);

			[self addSubview:imageView];
			self.cornView = imageView;
		}

		-(id)init {
			MTLumaDodgePillView *origObj =  %orig;
			[origObj initCorn];
			return origObj;
		}

		-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3 {
			//[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];
			//[Debug Log:[NSString stringWithFormat:@"arg1 x: %f  y: %f  width: %f  height: %f", arg1.origin.x, arg1.origin.y, arg1.size.width, arg1.size.height]];
			MTLumaDodgePillView *origObj =  %orig;
			[origObj initCorn];
			return origObj;
		}

		-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
			//[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2"];
			MTLumaDodgePillView *origObj = %orig;
			[origObj initCorn];
			return origObj;
		}

		-(id)initWithFrame:(CGRect)arg1 {
			MTLumaDodgePillView *origObj = %orig;
			[origObj initCorn];
			return origObj;
		}

		-(id)initWithCoder:(id)arg1 {
			MTLumaDodgePillView *origObj = %orig;
			[origObj initCorn];
			return origObj;
		}

		-(void)setStyle:(long long)arg1 {
			//[Debug Log:@"MTLumaDodgePillView setStyle"];
			%orig(40); // 40 for some reason makes it invisible
		}

		-(void)layoutSubviews {
			//[Debug Log:@"MTLumaDodgePillView  -(void)layoutSubviews"];
			//[Debug Log:[NSString stringWithFormat:@"frame  width: %f  height: %f", self.frame.size.width, self.frame.size.height]];
			%orig;

			NSInteger width = self.frame.size.width;
			NSInteger height = self.frame.size.height;
			self.cornView.frame = CGRectMake(0, 0, width, height);
			self.cornView.center = CGPointMake(width / 2, height / 2);
		}
	%end

	%hook MTStaticColorPillView
		%property (strong) UIImageView *cornView;

		%new
		- (void)initCorn {
			UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
			imageView.alpha = opacity;
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.frame = CGRectMake(0, 0, cornBarWidth, cornBarHeight);

			[self addSubview:imageView];
			self.cornView = imageView;
		}

		-(id)init {
			MTStaticColorPillView *origObj =  %orig;
			[origObj initCorn];
			return origObj;
		}

		-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
			//[Debug Log:@"MTStaticColorPillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];
			MTStaticColorPillView *origObj =  %orig;
			[origObj initCorn];
			return origObj;
		}

		-(id)initWithFrame:(CGRect)arg1 {
			MTStaticColorPillView *origObj =  %orig;
			[origObj initCorn];
			return origObj;

		}

		-(void)setPillColor:(id)arg1 {
			%orig([UIColor clearColor]);
		}

		-(void) layoutSubviews {
			%orig;

			NSInteger width = self.frame.size.width;
			NSInteger height = self.frame.size.height;
			self.cornView.frame = CGRectMake(0, 0, width, height);
			self.cornView.center = CGPointMake(width / 2, height / 2);
		}
	%end

	/*
	%hook SBFHomeGrabberSettings
		-(void)setEdgeProtectOverride:(NSInteger)arg1 {
			//[Debug Log:[NSString stringWithFormat:@"SBFHomeGrabberSettings  -(void)setEdgeProtectOverride:(NSInteger)arg1  %li", arg1]];
			%orig(false);
		}
	%end
	*/
%end

// ====================== Constructor ======================

%ctor {
	//[Debug Log:@"================= init ======================="];


	NSDictionary *defaultPrefs = @{
		@"kEnabled": @YES,
		@"kCustomImageEnabled": @NO,
		@"kTintEnabled": @NO,
		@"kCornFilename": @"cornbar_medium.png",
		@"kTintColor": @"#FFFFFF",
		@"kOpacity": @1.0f,
		@"kOffset": @8.0,
		@"kScale": @1.0,
	};

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.wrp1002.cornbar"];
	[prefs registerDefaults:defaultPrefs];


	enabled = [prefs boolForKey:@"kEnabled"];
	customImageEnabled = [prefs boolForKey:@"kCustomImageEnabled"];
	tintEnabled = [prefs boolForKey:@"kTintEnabled"];
	cornFilename = [prefs stringForKey:@"kCornFilename"];
	tintColorStr = [prefs stringForKey:@"kTintColor"];
	opacity = [prefs floatForKey:@"kOpacity"];
	offset = [prefs floatForKey:@"kOffset"];
	scale = [prefs floatForKey:@"kScale"];

	//[Debug Log:[NSString stringWithFormat:@"Loaded prefs: %i  %@  %f  %f  %f", enabled, cornFilename, opacity, offset, scale]];

	if (enabled)
		%init(AllHooks);
}

