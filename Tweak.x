#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <rootless.h>
#import "Tweak.h"
//#import "Debug.h"


// ====================== Preferences ======================

bool enabled;
NSString *cornFilename;
float opacity;
float offset;
float scale;

// ====================== Globals ======================

NSInteger cornBarWidth = 0;
NSInteger cornBarHeight = 0;
UIImage *cornImage = nil;


// Loading the image in %ctor caused safemode and
// loading it after springboard is done is too late,
// so just check if it has been loaded before and return it if so
UIImage *GetCornImage() {
	if (cornImage == nil) {
		NSString *imagePath = [NSString stringWithFormat:@"/Library/CornBar/%@", cornFilename];
		imagePath = ROOT_PATH_NS(imagePath);
		cornImage = [UIImage imageWithContentsOfFile:imagePath];

		cornBarWidth = (int)cornImage.size.width / 4 * scale;
		cornBarHeight = (int)cornImage.size.height / 4 * scale;

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

		-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3 {
			//[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];
			//[Debug Log:[NSString stringWithFormat:@"arg1 x: %f  y: %f  width: %f  height: %f", arg1.origin.x, arg1.origin.y, arg1.size.width, arg1.size.height]];

			MTLumaDodgePillView *origObj =  %orig;

			UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
			imageView.alpha = opacity;
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.frame = CGRectMake(0, 0, cornBarWidth, cornBarHeight);

			[origObj addSubview:imageView];
			origObj.cornView = imageView;
			//origObj.transform = CGAffineTransformMakeScale(scale, scale);

			return origObj;

		}

		-(void)setStyle:(long long)arg1 {
			//[Debug Log:@"MTLumaDodgePillView setStyle"];
			%orig(40); // 40 for some reason makes it invisible
			//%orig;
		}

		-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
			//[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2"];
			MTLumaDodgePillView *origObj = %orig;

			UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
			imageView.alpha = opacity;
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.frame = CGRectMake(0, 0, cornBarWidth, cornBarHeight);

			[origObj addSubview:imageView];
			origObj.cornView = imageView;

			return origObj;
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

		-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
			//[Debug Log:@"MTStaticColorPillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];

			MTStaticColorPillView *origObj =  %orig;

			UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
			imageView.alpha = opacity;
			imageView.contentMode = UIViewContentModeScaleAspectFit;
			imageView.frame = CGRectMake(0, 0, cornBarWidth, cornBarHeight);

			[origObj addSubview:imageView];
			origObj.cornView = imageView;

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
		@"kCornFilename": @"cornbar_medium.png",
		@"kOpacity": @1.0f,
		@"kOffset": @8.0,
		@"kScale": @1.0,
	};

	NSUserDefaults *prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.wrp1002.cornbar"];
	[prefs registerDefaults:defaultPrefs];


	enabled = [prefs boolForKey:@"kEnabled"];
	cornFilename = [prefs stringForKey:@"kCornFilename"];
	opacity = [prefs floatForKey:@"kOpacity"];
	offset = [prefs floatForKey:@"kOffset"];
	scale = [prefs floatForKey:@"kScale"];

	//[Debug Log:[NSString stringWithFormat:@"Loaded prefs: %i  %@  %f  %f  %f", enabled, cornFilename, opacity, offset, scale]];

	if (enabled)
		%init(AllHooks);
}

