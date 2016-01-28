package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

public class SetSecondsBetweenSessionsFunction implements FREFunction
{

	private static String TAG = "SetSecondsBetweenSessions";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		long seconds = 0;
		try {
			seconds = arg1[0].getAsInt();
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}
		if(seconds > 0)
		{
			Amplitude.getInstance().setMinTimeBetweenSessionsMillis(seconds * 1000);
			Log.d(TAG, "Set new value between sessions: " + seconds + " seconds");
		} else 
		{
			Log.d(TAG, "Incorrect time input.");
		}
		return null;
	}

}
