package com.pilipoplabs.amplitudeane;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREExtension;

public class Extension implements FREExtension
{
	public static String TAG = "AmplitudeANE";
	public static FREContext context;

	
	public FREContext createContext(String extId)
	{
		context = new ExtensionContext();
		return context;
	}

	public void dispose()
	{
		Log.d(TAG, "AmplitudeANE disposed.");
		context = null;
	}
	
	public void initialize()
	{
		Log.d(TAG, "AmplitudeANE initialized.");
	}
}
