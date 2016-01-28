package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

public class SetOptOutFunction implements FREFunction
{

	private static String TAG = "SetOptOut";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		Boolean optOut = false;
		try 
		{
			optOut = arg1[0].getAsBool();
		} catch (Exception e)
		{
			e.printStackTrace();
		}
		Amplitude.getInstance().setOptOut(optOut);
		Log.d(TAG, "Set opt-out to: " + optOut);
		return null;
	}

}
