package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

public class InitializeApiKeyFunction implements FREFunction
{

	private static String TAG = "InitializeApiKey";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		String apiKey = null;
		String userID = null;
		try
		{
			apiKey = arg1[0].getAsString();
			if(arg1[1] != null)
			{
				userID = arg1[1].getAsString();
			}
		}
		catch (Exception e)
		{
			e.printStackTrace();
		}
		
		if (apiKey != null)
		{
			Amplitude.getInstance().initialize(arg0.getActivity().getApplicationContext(), apiKey, userID);
			Log.d(TAG, "Starting Amplitude session with API key: " + apiKey + " and userID: " + userID);
		}
		
		return null;
	}

}
