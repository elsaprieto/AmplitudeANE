package com.pilipoplabs.amplitudeane.functions;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.adobe.fre.FREObject;
import com.amplitude.api.Amplitude;

public class LogRevenueFunction implements FREFunction
{

	private static String TAG = "LogRevenue";

	@Override
	public FREObject call(FREContext arg0, FREObject[] arg1)
	{
		double price = 0.0;
		if ( arg1[0] != null)
		{
			try {
				price = arg1[0].getAsDouble();
			} 
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		String productID = null;
		if ( arg1[1] != null){
			try {
				productID = arg1[1].getAsString();
			} 
			catch (Exception e)
			{
				e.printStackTrace();
			}
		}

		int quantity = 1;
		if ( arg1[2] != null)
		{
			try {
				quantity = arg1[2].getAsInt();
			} 
			catch (Exception e)
			{
				e.printStackTrace();
			}

		}		

		if(price > 0)
		{
			Amplitude.getInstance().logRevenue(productID, quantity, price);
			Log.d(TAG, "Logged revenue, productID: " + productID + " quantity: " + Integer.toString(quantity) + " price: " + Double.toString(price));
		}
		else 
		{
			Log.d(TAG, "Revenue price incorrect.");
		}

		return null;
	}

}
