package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;
import org.json.JSONObject;

public class SetUserPropertiesFunction implements FREFunction
{

	private static String TAG = "SetUserProperties";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		JSONObject properties = new JSONObject();
		if ( arg1[0]  != null && arg1[1] != null)
		{
			FREArray paramsKeys = (FREArray) arg1[0];
			FREArray paramsValue = (FREArray) arg1[1];

			try {
				long paramsLength = paramsKeys.getLength();
				for (long i = 0; i < paramsLength; i++)
				{
					FREObject key = paramsKeys.getObjectAt(i);
					FREObject value = paramsValue.getObjectAt(i);
					String keyString = key.getAsString();
					String valueString = value.getAsString();
					properties.put(keyString, valueString);
				}
			
			} catch (Exception e)
			{
				e.printStackTrace();
			}

		}

		if(properties != null && properties.length() > 0)
		{
			Amplitude.getInstance().setUserProperties(properties);
			Log.d(TAG, "Set user properties: " + properties.toString());
		} else {
			Log.d(TAG, "User properties incorrect.");
		}

		return null;
	}

}
