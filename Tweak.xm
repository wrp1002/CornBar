#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import <rootless.h>
#import "Tweak.h"
//#import "Debug.h"


// ====================== Globals ======================


NSInteger cornBarWidth = 130;
NSInteger cornBarHeight = 17;
UIImage *cornImage = nil;

// Loading the image in %ctor caused safemode and
// loading it after springboard is done is too late,
// so just check if it has been loaded before and return it if so
UIImage *GetCornImage() {
	if (cornImage == nil) {
		NSString *imagePath = @"/Library/CornBar/cornbar.png";
		imagePath = ROOT_PATH_NS(imagePath);
		cornImage = [UIImage imageWithContentsOfFile:imagePath];
	}
	return cornImage;
}


// ====================== Hooks ======================


%hook MTLumaDodgePillSettings
	-(void)setMinWidth:(double)arg1 {
		//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinWidth:(double)arg1   %f", arg1]];
		%orig(cornBarWidth);
	}
	-(void)setMaxWidth:(double)arg1 {
		//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinWidth:(double)arg1   %f", arg1]];
		%orig(cornBarWidth);
	}
	-(void)setHeight:(double)arg1 {
		//[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinHeight:(double)arg1   %f", arg1]];
		%orig(cornBarHeight);
	}
%end


%hook MTLumaDodgePillView
	%property (strong) UIImageView *cornView;

	-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3 {
		//[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];
		//[Debug Log:[NSString stringWithFormat:@"arg1 x: %f  y: %f  width: %f  height: %f", arg1.origin.x, arg1.origin.y, arg1.size.width, arg1.size.height]];

		MTLumaDodgePillView *origObj =  %orig;


		UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
		imageView.contentMode = UIViewContentModeScaleAspectFit;

		[origObj addSubview:imageView];
		origObj.cornView = imageView;

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
		imageView.contentMode = UIViewContentModeScaleAspectFit;

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
		origObj.clipsToBounds = NO;

		UIImageView *imageView = [[UIImageView alloc] initWithImage:GetCornImage()];
		imageView.contentMode = UIViewContentModeScaleAspectFit;

		[origObj addSubview:imageView];
		origObj.cornView = imageView;

		return origObj;
	}

	-(void)setBackgroundColor:(id)arg1 {
		%orig;
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


// ====================== Constructor ======================

%ctor {
	//[Debug Log:@"================= init ======================="];


}

