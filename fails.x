
%hook MTPillView
%property (retain) UIImageView *cornView;

-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 {
	[Debug Log:@"MTPillView  -(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 "];

	[Debug Log:[NSString stringWithFormat:@"settings: %@", [arg2 class]]];

	MTLumaDodgePillSettings *settings = arg2;

	[Debug Log:[NSString stringWithFormat:@"settings: %f  %f", [settings colorAddWhiteness], [settings brightLumaThreshold]]];


	MTPillView *origObj = %orig(arg1, arg2);

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

	/*
	// Assuming containerView is the view you want to center within its parent
	// and parentView is its parent view

	// Calculate the center point of the parent view, accounting for its current orientation
	CGPoint parentCenter = CGPointMake(CGRectGetMidX(origObj.bounds), CGRectGetMidY(origObj.bounds));

	// Convert the parent center point to the containerView's coordinate system
	CGPoint convertedCenter = [origObj convertPoint:parentCenter toView:containerView.superview];


	// Calculate the origin point for the containerView to center it within the parent view
	CGFloat xOrigin = convertedCenter.x - (containerView.frame.size.width / 2);
	CGFloat yOrigin = convertedCenter.y - (containerView.frame.size.height / 2);

	// Set the new frame for the containerView
	containerView.frame = CGRectMake(xOrigin, yOrigin, containerView.frame.size.width, containerView.frame.size.height);
	*/





	return origObj;
}


-(id)initWithFrame:(CGRect)arg1 {
	[Debug Log:@"MTPillView  -(id)initWithFrame:(CGRect)arg1 "];
	return %orig;
}

-(id)init{
	[Debug Log:@"MTPillView  -(id)init"];
	return %orig;
}

-(void)layoutSubviews {
	[Debug Log:@"MTPillView  -(void)layoutSubviews"];
	%orig;

	//UIView *containerView = self.cornView;
	/*
	// Assuming containerView is the view you want to center within its parent
	// and parentView is its parent view

	// Calculate the center point of the parent view, accounting for its current orientation
	CGPoint parentCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

	// Convert the parent center point to the containerView's coordinate system
	CGPoint convertedCenter = [self convertPoint:parentCenter toView:containerView.superview];


	// Calculate the origin point for the containerView to center it within the parent view
	CGFloat xOrigin = convertedCenter.x - (containerView.frame.size.width / 2);
	CGFloat yOrigin = convertedCenter.y - (containerView.frame.size.height / 2);

	// Set the new frame for the containerView
	containerView.frame = CGRectMake(xOrigin, yOrigin, containerView.frame.size.width, containerView.frame.size.height);

	UIView *containerView = self.cornView;
	CGPoint parentCenter = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));

	// Convert the parent center point to the containerView's coordinate system
	CGPoint convertedCenter = [self convertPoint:parentCenter toView:containerView.superview];


	// Calculate the origin point for the containerView to center it within the parent view
	CGFloat xOrigin = convertedCenter.x - (containerView.frame.size.width / 2);
	CGFloat yOrigin = convertedCenter.y - (containerView.frame.size.height / 2);

	// Set the new frame for the containerView
	containerView.frame = CGRectMake(xOrigin, yOrigin, containerView.frame.size.width, containerView.frame.size.height);

	//containerView.hidden = self.hidden;
	//self.hidden = YES;
	//containerView.hidden = NO;
	*/
	//self.alpha = 0;
	//self.backgroundColor = [UIColor clearColor];
	//self.cornView.alpha = 1.0;

	[Debug Log:[NSString stringWithFormat:@"width: %f", self.frame.size.width]];

	//self.cornView.frame = CGRectMake(-2, -17, 300, 34);
	//self.alpha = 0.0;

	[Debug Log:[NSString stringWithFormat:@"parent obj: %@  alpha:%f,%f  %i", [self.superview class], self.alpha, self.superview.alpha, [self isHidden]]];

	self.cornView.frame = self.frame;
	self.cornView.center =  CGPointMake(self.frame.size.width/2, self.frame.size.height/2);


}
%end
