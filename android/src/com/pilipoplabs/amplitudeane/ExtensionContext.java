package com.pilipoplabs.amplitudeane;

import java.util.HashMap;
import java.util.Map;

import android.util.Log;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.pilipoplabs.amplitudeane.functions.InitializeApiKeyFunction;
import com.pilipoplabs.amplitudeane.functions.LogAmplitudeEventFunction;
import com.pilipoplabs.amplitudeane.functions.SetUserIDFunction;
import com.pilipoplabs.amplitudeane.functions.LogRevenueFunction;
import com.pilipoplabs.amplitudeane.functions.SetUserPropertiesFunction;
import com.pilipoplabs.amplitudeane.functions.UnsetUserPropertiesFunction;
import com.pilipoplabs.amplitudeane.functions.SetOnceUserPropertiesFunction;
import com.pilipoplabs.amplitudeane.functions.SetOptOutFunction;
import com.pilipoplabs.amplitudeane.functions.SetSecondsBetweenSessionsFunction;

public class ExtensionContext extends FREContext
{	
	public ExtensionContext()
	{
	}
	
	@Override
	public void dispose()
	{
		Extension.context = null;
	}

	@Override
	public Map<String, FREFunction> getFunctions()
	{
		Map<String, FREFunction> functionMap = new HashMap<String, FREFunction>();
		functionMap.put("initializeApiKey", new InitializeApiKeyFunction());
		functionMap.put("logAmplitudeEvent", new LogAmplitudeEventFunction());
		functionMap.put("setUserID", new SetUserIDFunction());
		functionMap.put("logRevenue", new LogRevenueFunction());
		functionMap.put("setUserProperties", new SetUserPropertiesFunction());
		functionMap.put("unsetUserProperties", new UnsetUserPropertiesFunction());
		functionMap.put("setOnceUserProperties", new SetOnceUserPropertiesFunction());
		functionMap.put("setOptOut", new SetOptOutFunction());
		functionMap.put("setSecondsBetweenSessions", new SetSecondsBetweenSessionsFunction());		
		return functionMap;	
	}
}
