package com.birdgang.fb_audience_network_ad;

import android.content.Context;
import android.graphics.Color;
import android.graphics.PorterDuff;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.GradientDrawable;
import android.os.Build;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import androidx.core.content.res.ResourcesCompat;
import androidx.core.graphics.drawable.DrawableCompat;

import com.facebook.ads.Ad;
import com.facebook.ads.AdError;
import com.facebook.ads.AdIconView;
import com.facebook.ads.AdOptionsView;
import com.facebook.ads.AudienceNetworkAds;
import com.facebook.ads.MediaView;
import com.facebook.ads.NativeAd;
import com.facebook.ads.NativeAdListener;
import com.facebook.ads.NativeAdViewAttributes;
import com.facebook.ads.NativeBannerAd;
import com.facebook.ads.NativeBannerAdView;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;

class FacebookNativeAdPlugin extends PlatformViewFactory {

    private final BinaryMessenger messenger;

    FacebookNativeAdPlugin(BinaryMessenger messenger) {
        super(StandardMessageCodec.INSTANCE);
        this.messenger = messenger;
    }

    @Override
    public PlatformView create(Context context, int id, Object args) {
        return new FacebookNativeAdView(context, id, (HashMap) args, this.messenger);
    }
}

class FacebookNativeAdView implements PlatformView, NativeAdListener {

    private LinearLayout adView;

    private final MethodChannel channel;
    private final HashMap args;
    private final Context context;

    private NativeAd nativeAd;
    private NativeBannerAd bannerAd;

    FacebookNativeAdView(Context context, int id, HashMap args, BinaryMessenger messenger) {
        adView = new LinearLayout(context);
        this.channel = new MethodChannel(messenger, FacebookConstants.NATIVE_AD_CHANNEL + "_" + id);
        this.args = args;
        this.context = context;

        AudienceNetworkAds.initialize(context);

        Log.i("FacebookNativeAdView" , "FacebookConstants.NATIVE_AD_CHANNEL >>  id :: " + FacebookConstants.NATIVE_AD_CHANNEL + "_" + id);

        if ((boolean) args.get("banner_ad")) {
            bannerAd = new NativeBannerAd(context, (String) this.args.get("id"));
            bannerAd.setAdListener(this);
            bannerAd.loadAd();
        } else {
            nativeAd = new NativeAd(context, (String) this.args.get("id"));
            nativeAd.setAdListener(this);
            nativeAd.loadAd();
        }
    }


    private NativeAdViewAttributes getViewAttributes(Context context, HashMap args) {
        NativeAdViewAttributes viewAttributes = new NativeAdViewAttributes(context);

        if (args.get("bg_color") != null)
            viewAttributes.setBackgroundColor(Color.parseColor((String) args.get("bg_color")));
        if (args.get("title_color") != null)
            viewAttributes.setTitleTextColor(Color.parseColor((String) args.get("title_color")));
        if (args.get("desc_color") != null)
            viewAttributes.setDescriptionTextColor(Color.parseColor((String) args.get("desc_color")));
        if (args.get("button_color") != null)
            viewAttributes.setButtonColor(Color.parseColor((String) args.get("button_color")));
        if (args.get("button_title_color") != null)
            viewAttributes.setButtonTextColor(Color.parseColor((String) args.get("button_title_color")));
        if (args.get("button_border_color") != null)
            viewAttributes.setButtonBorderColor(Color.parseColor((String) args.get("button_border_color")));

        return viewAttributes;
    }

    private NativeBannerAdView.Type getBannerSize(HashMap args) {
        final int height = (int) args.get("height");
        switch (height) {
            case 50:
                return NativeBannerAdView.Type.HEIGHT_50;
            case 100:
                return NativeBannerAdView.Type.HEIGHT_100;
            case 120:
                return NativeBannerAdView.Type.HEIGHT_120;
            default:
                return NativeBannerAdView.Type.HEIGHT_120;
        }
    }

    private View inflateView() {
        View view = LayoutInflater.from(context).inflate(R.layout.fb_native_ad_layout_horizontal, null);
        int type = 0;

        if (args.get("adType") != null) {
            try {
                type = (int)args.get("adType");
            } catch (Exception e) {
                type = 0;
            }

            if(type == 0)   view = LayoutInflater.from(context).inflate(R.layout.fb_native_ad_layout_horizontal, null);
            else            view = LayoutInflater.from(context).inflate(R.layout.fb_native_ad_layout_vertical, null);
        }

        LinearLayout mainLayout = view.findViewById(R.id.native_ad_main);
        MediaView mediaView = view.findViewById(R.id.native_ad_media);
        TextView title = view.findViewById(R.id.native_ad_title);
        TextView sponsor = view.findViewById(R.id.native_ad_sponsored_label);
        TextView body = view.findViewById(R.id.native_ad_body);
        TextView buttonText = view.findViewById(R.id.native_ad_button_text);
        LinearLayout buttonAction = view.findViewById(R.id.native_ad_call_to_action);
        LinearLayout adChoiceContainer = view.findViewById(R.id.native_ad_option);


        MediaView icon = new MediaView(context);
        ImageView profile_view = null;

        if(type == 0) {
            icon = view.findViewById(R.id.native_ad_icon);
            profile_view = view.findViewById(R.id.profile_filter);
            profile_view.setBackgroundResource(R.drawable.ic_profile_cover);
        }

        if (args.get("bg_color") != null){
            mainLayout.setBackgroundColor(Color.parseColor((String) args.get("bg_color")));
            if(type == 0) {
                Drawable drawable = ResourcesCompat.getDrawable(context.getResources(), R.drawable.ic_profile_cover, null);
                drawable = DrawableCompat.wrap(drawable);
                DrawableCompat.setTint(drawable, Color.parseColor((String) args.get("bg_color")));
                profile_view.setBackground(drawable);
            }
        }
        else {
            mainLayout.setBackgroundColor(Color.parseColor("#00152d"));
            if(type == 0) {
                Drawable drawable = ResourcesCompat.getDrawable(context.getResources(), R.drawable.ic_profile_cover, null);
                drawable = DrawableCompat.wrap(drawable);
                DrawableCompat.setTint(drawable, Color.parseColor("#00152d"));
                profile_view.setBackground(drawable);
            }
        }

        if (args.get("title_color") != null)    title.setTextColor(Color.parseColor((String) args.get("title_color")));
        else                                    title.setTextColor(Color.parseColor("#ffffff"));

        if (args.get("desc_color") != null)     body.setTextColor(Color.parseColor((String) args.get("desc_color")));
        else                                    body.setTextColor(Color.parseColor("#ffffff"));

        int labelColor;
        if (args.get("label_color") != null) {
            labelColor = Color.parseColor((String) args.get("label_color"));
        }
        else {
            labelColor = Color.argb(0xff, 0x9B, 0xA1, 0xB4);
        }
        sponsor.setTextColor(labelColor);

        AdOptionsView adOptionsView = new AdOptionsView(context, nativeAd, null);
        adOptionsView.setIconColor(Color.argb(0xdd, 0xff, 0xff, 0xff));
        adOptionsView.setIconSizeDp(10);
        adChoiceContainer.removeAllViews();
        adChoiceContainer.addView(adOptionsView, 0);

        GradientDrawable buttonColor = new GradientDrawable();
        buttonColor.setCornerRadius(5.0f);
        if (args.get("button_color") != null)   {
            buttonColor.setColor(Color.parseColor((String) args.get("button_color")));
            buttonAction.setBackground(buttonColor);
        }
        else {
            buttonColor.setColor(Color.parseColor("#f8d000"));
            buttonAction.setBackground(buttonColor);
        }

        if (args.get("button_title_color") != null) {
            buttonText.setTextColor(Color.parseColor((String) args.get("button_title_color")));
        }
        else {
            buttonText.setTextColor(Color.parseColor("#000000"));
        }

        // set the text
        title.setText(nativeAd.getAdvertiserName());
        body.setText(nativeAd.getAdBodyText());
        buttonAction.setVisibility(nativeAd.hasCallToAction() ? View.VISIBLE : View.GONE);
        buttonText.setText(nativeAd.getAdCallToAction());
        sponsor.setText(nativeAd.getSponsoredTranslation());

        List<View> clickableViews = new ArrayList<>();
        clickableViews.add(title);
        clickableViews.add(buttonAction);

        // register the title and CTA button to listen for clicks
        if(type == 0) nativeAd.registerViewForInteraction(view, mediaView, icon, clickableViews);
        else {
            AdIconView ad_icon = null;
            nativeAd.registerViewForInteraction(view, mediaView, ad_icon, clickableViews);
        }

        return view;
    }

    @Override
    public View getView() {
        return adView;
    }

    @Override
    public void dispose() {
    }

    @Override
    public void onError(Ad ad, AdError adError) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("placement_id", ad.getPlacementId());
        args.put("invalidated", ad.isAdInvalidated());
        args.put("error_code", adError.getErrorCode());
        args.put("error_message", adError.getErrorMessage());
        channel.invokeMethod(FacebookConstants.ERROR_METHOD, args);
        Log.e("test", "## adError : " + adError.getErrorMessage());
    }

    @Override
    public void onAdLoaded(Ad ad) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("placement_id", ad.getPlacementId());
        args.put("invalidated", ad.isAdInvalidated());

        if (adView.getChildCount() > 0) {
            adView.removeAllViews();
        }

        if ((boolean) this.args.get("banner_ad")) {
            adView.addView(NativeBannerAdView.render(this.context, this.bannerAd, getBannerSize(this.args), getViewAttributes(this.context, this.args)));
        } else {
            View view = inflateView();
            adView.addView(view);
            //adView.addView(NativeAdView.render(this.context, this.nativeAd, getViewAttributes(this.context, this.args)));
        }

        channel.invokeMethod(FacebookConstants.LOADED_METHOD, args);
    }

    @Override
    public void onAdClicked(Ad ad) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("placement_id", ad.getPlacementId());
        args.put("invalidated", ad.isAdInvalidated());
        channel.invokeMethod(FacebookConstants.CLICKED_METHOD, args);
    }

    @Override
    public void onLoggingImpression(Ad ad) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("placement_id", ad.getPlacementId());
        args.put("invalidated", ad.isAdInvalidated());
        channel.invokeMethod(FacebookConstants.LOGGING_IMPRESSION_METHOD, args);
    }

    @Override
    public void onMediaDownloaded(Ad ad) {
        HashMap<String, Object> args = new HashMap<>();
        args.put("placement_id", ad.getPlacementId());
        args.put("invalidated", ad.isAdInvalidated());
        channel.invokeMethod(FacebookConstants.MEDIA_DOWNLOADED_METHOD, args);
    }
}