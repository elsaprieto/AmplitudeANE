package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

import com.amplitude.api.Identify;
import com.adobe.fre.FREArray;
import org.json.JSONObject;

public class SetOnceUserPropertiesFunction implements FREFunction
{

	private static String TAG = "SetOnceUserProperties";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		Identify properties = new Identify();
		JSONObject propertiesJSON = new JSONObject();
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
					propertiesJSON.put(keyString, valueString);
					properties.setOnce(keyString, valueString);
				}
			
			} catch (Exception e)
			{
				e.printStackTrace();
			}

		}

		if(properties != null && propertiesJSON.length() > 0)
		{
			Amplitude.getInstance().identify(properties);
			Log.d(TAG, "Setonce user properties: " + propertiesJSON.toString());
		} else {
			Log.d(TAG, "User properties incorrect.");
		}

		return null;
	}

}
