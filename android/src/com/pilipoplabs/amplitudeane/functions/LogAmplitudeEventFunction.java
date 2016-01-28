package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;

import org.json.JSONObject;

import com.amplitude.api.Amplitude;

public class LogAmplitudeEventFunction implements FREFunction
{

	private static String TAG = "LogAmplitudeEvent";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		String eventID = null;
		try {
			eventID = arg1[0].getAsString();
		} 
		catch (Exception e)
		{
			e.printStackTrace();
		}

		JSONObject properties = new JSONObject();		
		if ( arg1[1]  != null && arg1[2] != null)
		{
			FREArray paramsKeys = (FREArray) arg1[1];
			FREArray paramsValue = (FREArray) arg1[2];

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

		Boolean outOfSession = false;
		if ( arg1[1]  != null && arg1[2] != null && arg1[3] != null)
		{
			try 
			{
				outOfSession = arg1[3].getAsBool();
			} catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		if(eventID != null)
		{
			if(properties != null && properties.length() > 0)
			{
				Amplitude.getInstance().logEvent(eventID, properties, outOfSession);
				Log.d(TAG, "Logged event with ID: " + eventID + ", properties: " + properties.toString() + " and outOfSession: " + outOfSession.toString());
			} else {
				Amplitude.getInstance().logEvent(eventID);
				Log.d(TAG, "Logged event with ID: " + eventID + ", without properties");
			}
		}


		return null;
	}

}
