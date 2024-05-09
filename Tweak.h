
@interface MTPillView : UIView
@property (strong) UIImageView *cornView;
-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 ;
-(id)initWithFrame:(CGRect)arg1 ;
-(id)init;
@end

@interface MTLumaDodgePillView : MTPillView
+(void)initialize;
+(Class)layerClass;
+(CGSize)suggestedSizeForContentWidth:(double)arg1 withSettings:(id)arg2 ;
+(BOOL)supportsBackgroundLuminanceObserving;
-(void)initCorn;
-(void)bounce;
-(void)layoutSubviews;
-(long long)style;
-(BOOL)_shouldAnimatePropertyWithKey:(id)arg1 ;
-(void)_updateStyle;
-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 ;
-(void)animationDidStop:(id)arg1 finished:(BOOL)arg2 ;
-(CGSize)sizeThatFits:(CGSize)arg1 ;
-(NSString *)description;
-(void)setStyle:(long long)arg1 ;
-(BOOL)_shouldAnimatePropertyAdditivelyWithKey:(id)arg1 ;
-(void)backdropLayer:(id)arg1 didChangeLuma:(double)arg2 ;
-(void)dealloc;
-(id)initWithFrame:(CGRect)arg1 settings:(id)arg2 graphicsQuality:(long long)arg3 ;
-(void)setBackgroundLuminanceBias:(long long)arg1 ;
-(void)resetBackgroundLuminanceHysteresis;
-(double)suggestedEdgeSpacing;
-(CGSize)suggestedSizeForContentWidth:(double)arg1 ;
-(long long)backgroundLuminance;
-(long long)backgroundLuminanceBias;
@end


@interface MTStaticColorPillView : MTPillView
- (void)initCorn;
- (id)backgroundColor:(id)arg1;
- (id)initWithFrame:(CGRect)arg1 settings:(id)arg2;
- (id)pillColor;
- (void)setBackgroundColor:(id)arg1;
- (void)setPillColor:(id)arg1;
@end


@interface SBHomeGrabberView : UIView {
	MTLumaDodgePillView* _pillView;
}
@property (retain) UIImageView *cornView;
-(void)layoutSubviews;
@end


@interface MTLumaDodgePillStyleSettings
@property (assign,nonatomic) double colorAddOpacity;                      //@synthesize colorAddOpacity=_colorAddOpacity - In the implementation block
@property (assign,nonatomic) double lumaMapPlusColorOpacity;              //@synthesize lumaMapPlusColorOpacity=_lumaMapPlusColorOpacity - In the implementation block
@property (assign,nonatomic) double overlayBlendOpacity;                  //@synthesize overlayBlendOpacity=_overlayBlendOpacity - In the implementation block
@property (assign,nonatomic) double blur;                                 //@synthesize blur=_blur - In the implementation block
@property (assign,nonatomic) double brightness;                           //@synthesize brightness=_brightness - In the implementation block
@property (assign,nonatomic) double saturation;                           //@synthesize saturation=_saturation - In the implementation block
+(id)settingsControllerModule;
-(void)setDefaultValues;
-(double)blur;
-(double)brightness;
-(void)setBrightness:(double)arg1 ;
-(void)setSaturation:(double)arg1 ;
-(double)saturation;
-(void)setBlur:(double)arg1 ;
-(void)setColorAddOpacity:(double)arg1 ;
-(void)setLumaMapPlusColorOpacity:(double)arg1 ;
-(void)setOverlayBlendOpacity:(double)arg1 ;
-(double)colorAddOpacity;
-(double)lumaMapPlusColorOpacity;
-(double)overlayBlendOpacity;
@end


@interface MTLumaDodgePillSettings {

	double _minWidth;
	double _maxWidth;
	double _height;
	double _edgeSpacing;
	double _colorAddWhiteness;
	double _brightLumaThreshold;
	double _darkLumaThreshold;
	double _initialLumaThreshold;
	double _cornerRadius;
	long long _cornerMask;
	MTLumaDodgePillStyleSettings* _noneSettings;
	MTLumaDodgePillStyleSettings* _thinSettings;
	MTLumaDodgePillStyleSettings* _graySettings;
	MTLumaDodgePillStyleSettings* _blackSettings;
	MTLumaDodgePillStyleSettings* _whiteSettings;
}
@property (assign,nonatomic) double minWidth;                                           //@synthesize minWidth=_minWidth - In the implementation block
@property (assign,nonatomic) double maxWidth;                                           //@synthesize maxWidth=_maxWidth - In the implementation block
@property (assign,nonatomic) double height;                                             //@synthesize height=_height - In the implementation block
@property (assign,nonatomic) double edgeSpacing;                                        //@synthesize edgeSpacing=_edgeSpacing - In the implementation block
@property (assign,nonatomic) double colorAddWhiteness;                                  //@synthesize colorAddWhiteness=_colorAddWhiteness - In the implementation block
@property (assign,nonatomic) double brightLumaThreshold;                                //@synthesize brightLumaThreshold=_brightLumaThreshold - In the implementation block
@property (assign,nonatomic) double darkLumaThreshold;                                  //@synthesize darkLumaThreshold=_darkLumaThreshold - In the implementation block
@property (assign,nonatomic) double initialLumaThreshold;                               //@synthesize initialLumaThreshold=_initialLumaThreshold - In the implementation block
@property (assign,nonatomic) double cornerRadius;                                       //@synthesize cornerRadius=_cornerRadius - In the implementation block
@property (assign,nonatomic) long long cornerMask;                                      //@synthesize cornerMask=_cornerMask - In the implementation block
@property (nonatomic,retain) MTLumaDodgePillStyleSettings * noneSettings;               //@synthesize noneSettings=_noneSettings - In the implementation block
@property (nonatomic,retain) MTLumaDodgePillStyleSettings * thinSettings;               //@synthesize thinSettings=_thinSettings - In the implementation block
@property (nonatomic,retain) MTLumaDodgePillStyleSettings * graySettings;               //@synthesize graySettings=_graySettings - In the implementation block
@property (nonatomic,retain) MTLumaDodgePillStyleSettings * blackSettings;              //@synthesize blackSettings=_blackSettings - In the implementation block
@property (nonatomic,retain) MTLumaDodgePillStyleSettings * whiteSettings;              //@synthesize whiteSettings=_whiteSettings - In the implementation block
+(id)sharedInstance;
+(id)settingsControllerModule;
-(void)setDefaultValues;
-(double)edgeSpacing;
-(void)setHeight:(double)arg1 ;
-(long long)cornerMask;
-(double)maxWidth;
-(double)minWidth;
-(void)setCornerRadius:(double)arg1 ;
-(double)cornerRadius;
-(void)setEdgeSpacing:(double)arg1 ;
-(double)height;
-(void)setMinWidth:(double)arg1 ;
-(void)setMaxWidth:(double)arg1 ;
-(void)setCornerMask:(long long)arg1 ;
-(void)setColorAddWhiteness:(double)arg1 ;
-(void)setBrightLumaThreshold:(double)arg1 ;
-(void)setDarkLumaThreshold:(double)arg1 ;
-(void)setInitialLumaThreshold:(double)arg1 ;
-(void)setNoneSettings:(MTLumaDodgePillStyleSettings *)arg1 ;
-(void)setThinSettings:(MTLumaDodgePillStyleSettings *)arg1 ;
-(void)setGraySettings:(MTLumaDodgePillStyleSettings *)arg1 ;
-(void)setBlackSettings:(MTLumaDodgePillStyleSettings *)arg1 ;
-(void)setWhiteSettings:(MTLumaDodgePillStyleSettings *)arg1 ;
-(double)colorAddWhiteness;
-(double)brightLumaThreshold;
-(double)darkLumaThreshold;
-(double)initialLumaThreshold;
-(MTLumaDodgePillStyleSettings *)noneSettings;
-(MTLumaDodgePillStyleSettings *)thinSettings;
-(MTLumaDodgePillStyleSettings *)graySettings;
-(MTLumaDodgePillStyleSettings *)blackSettings;
-(MTLumaDodgePillStyleSettings *)whiteSettings;
@end