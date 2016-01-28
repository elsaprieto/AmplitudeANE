package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

import com.amplitude.api.Identify;
import com.adobe.fre.FREArray;
import org.json.JSONObject;

public class UnsetUserPropertiesFunction implements FREFunction
{

	private static String TAG = "UnsetUserProperties";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		Identify properties = new Identify();
		JSONObject propertiesJSON = new JSONObject();
		if ( arg1[0]  != null)
		{
			FREArray paramsKeys = (FREArray) arg1[0];
			try {
				long paramsLength = paramsKeys.getLength();
				for (long i = 0; i < paramsLength; i++)
				{
					FREObject key = paramsKeys.getObjectAt(i);
					String keyString = key.getAsString();
					propertiesJSON.put(keyString, "");
					properties.unset(keyString);
				}
			
			} catch (Exception e)
			{
				e.printStackTrace();
			}

		}

		if(properties != null && propertiesJSON.length() > 0)
		{
			Amplitude.getInstance().identify(properties);
			Log.d(TAG, "Unset user properties: " + propertiesJSON.toString());
		} else {
			Log.d(TAG, "User properties incorrect.");
		}

		return null;
	}

}
