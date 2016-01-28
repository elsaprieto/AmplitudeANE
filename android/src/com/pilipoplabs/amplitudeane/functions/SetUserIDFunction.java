package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

public class SetUserIDFunction implements FREFunction
{

	private static String TAG = "SetUserID";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		String userID = null;
		try {
			userID = arg1[0].getAsString();
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}

		if(userID != null)
		{
			Amplitude.getInstance().setUserId(userID);
			Log.d(TAG, "Set user ID: " + userID);
		}
		else
		{
			Log.d(TAG, "Wrong user ID.");
		}
		return null;
	}

}
