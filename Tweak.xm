
#import <UIKit/UIKit.h>
#import "substrate.h"
#import "logos/logos.h"
#import <rootless.h>
#import "Tweak.h"
#import "Debug.h"


NSInteger cornBarWidth = 130;

%hook MTLumaDodgePillSettings
	-(void)setMinWidth:(double)arg1 {
		[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinWidth:(double)arg1   %f", arg1]];
		//%orig(130);
		%orig;
	}
	-(void)setMaxWidth:(double)arg1 {
		[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinWidth:(double)arg1   %f", arg1]];
		//%orig(130);
		%orig;
	}
	-(void)setHeight:(double)arg1 {
		[Debug Log:[NSString stringWithFormat:@"MTLumaDodgePillSettings  -(void)setMinHeight:(double)arg1   %f", arg1]];
		//%orig(34);
		%orig;
	}
%end


%hook MTPillView
%property (retain) UIImageView *cornView;

-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
	[Debug Log:@"MTPillView  -(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 "];
	MTPillView *origObj = %orig(arg1, arg2);
	origObj.clipsToBounds = NO;
	return origObj;
}
%end


%hook MTLumaDodgePillView
	%property (retain) UIImageView *cornView;

	-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3 {
		[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];
		[Debug Log:[NSString stringWithFormat:@"arg1 x: %f  y: %f  width: %f  height: %f", arg1.origin.x, arg1.origin.y, arg1.size.width, arg1.size.height]];

		MTLumaDodgePillView *origObj =  %orig;
		origObj.clipsToBounds = NO;

		NSString *imagePath = ROOT_PATH_NS(@"/Library/CornBar/cornbar.png");
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image]; // Create a UIImageView with the loaded image
		imageView.contentMode = UIViewContentModeScaleAspectFit; // Adjust content mode as needed
		imageView.frame = CGRectMake(-64, -17, 256, 34);

		[origObj addSubview:imageView];
		origObj.cornView = imageView;

		return %orig;

	}

	-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
		[Debug Log:@"MTLumaDodgePillView initWithFrame:(CGRect)arg1 settings:(id)arg2"];
		MTLumaDodgePillView *origObj = %orig;
		origObj.clipsToBounds = NO;
		return origObj;
	}

	-(void)layoutSubviews {
		[Debug Log:@"MTLumaDodgePillView  -(void)layoutSubviews"];
		[Debug Log:[NSString stringWithFormat:@"frame  width: %f  height: %f", self.frame.size.width, self.frame.size.height]];
		%orig;

		//self.cornView.frame = self.frame;
		NSInteger extraWidth = 8;
		NSInteger width = self.frame.size.width + extraWidth;
		NSInteger height = self.frame.size.height;
		self.cornView.frame = CGRectMake(0, 0, width, 34);
		self.cornView.center = CGPointMake(width / 2 - extraWidth / 2, height / 2);
	}
%end

%hook MTStaticColorPillView
	%property (retain) UIImageView *cornView;
	- (id)backgroundColor:(id)arg1 {
		return %orig;
	}
	- (id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
		[Debug Log:@"MTStaticColorPillView initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3"];

		MTStaticColorPillView *origObj =  %orig;
		origObj.clipsToBounds = NO;


		NSString *imagePath = ROOT_PATH_NS(@"/Library/CornBar/cornbar.png");
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image]; // Create a UIImageView with the loaded image
		imageView.contentMode = UIViewContentModeScaleAspectFit; // Adjust content mode as needed
		imageView.frame = CGRectMake(0, 0, 256, 34);

		[origObj addSubview:imageView];

		imageView.center = origObj.center;

		//origObj.cornView = imageView;

		return %orig;
	}
	- (void)setBackgroundColor:(id)arg1 {
		%orig;
	}
	- (void) layoutSubviews {
		%orig;

		NSInteger extraWidth = 8;
		NSInteger width = self.frame.size.width + extraWidth;
		NSInteger height = self.frame.size.height;
		self.cornView.frame = CGRectMake(0, 0, width, 34);
		self.cornView.center = CGPointMake(width / 2 - extraWidth / 2, height / 2);

		//self.alpha = 0;
		//self.backgroundColor = [UIColor clearColor];
		self.hidden = YES;
	}
%end


/*
%hook SBHomeGrabberView
	%property (retain) UIImageView *cornView;
	-(id)initWithFrame:(CGRect)arg1 {
		[Debug Log:@"SBHomeGrabberView   -(id)initWithFrame:(CGRect)arg1"];
		SBHomeGrabberView *origObj = %orig;


		origObj.clipsToBounds = NO;

		//CGRect screenBounds = [UIScreen mainScreen].fixedCoordinateSpace.bounds;

		NSString *imagePath = ROOT_PATH_NS(@"/Library/CornBar/cornbar.png");
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image]; // Create a UIImageView with the loaded image
		imageView.contentMode = UIViewContentModeScaleAspectFit; // Adjust content mode as needed

		imageView.frame = CGRectMake(-2, -17, 256, 34);

		[origObj addSubview:imageView];

		imageView.center = origObj.center;

		origObj.cornView = imageView;


		return origObj;
	}


	-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 shouldEnableGestures:(BOOL)arg3 {
		[Debug Log:@"SBHomeGrabberView   -(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 shouldEnableGestures:(BOOL)arg3"];
		SBHomeGrabberView *origObj = %orig;


		origObj.clipsToBounds = NO;

		//CGRect screenBounds = [UIScreen mainScreen].fixedCoordinateSpace.bounds;

		NSString *imagePath = ROOT_PATH_NS(@"/Library/CornBar/cornbar.png");
		UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image]; // Create a UIImageView with the loaded image
		imageView.contentMode = UIViewContentModeScaleAspectFit; // Adjust content mode as needed

		MTLumaDodgePillView* pillView = MSHookIvar<MTLumaDodgePillView*>(self, "_pillView");

		imageView.frame = pillView.frame;
		imageView.center = pillView.center;

		[pillView addSubview:imageView];

		origObj.cornView = imageView;

		return origObj;
	}


	-(void)layoutSubviews {
		%orig;
		[Debug Log:[NSString stringWithFormat:@"parent obj: %@    %i", [self.superview class], [self.superview isHidden]]];
		[Debug Log:[NSString stringWithFormat:@"width: %f", self.frame.size.width]];

		MTLumaDodgePillView* pillView = MSHookIvar<MTLumaDodgePillView*>(self, "_pillView");

		self.cornView.frame = pillView.frame;
		self.cornView.center = CGPointMake(pillView.frame.size.width/2, pillView.frame.size.height/2);
	}
%end
*/





%ctor {
	[Debug Log:@"================= init ======================="];
}