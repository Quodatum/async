package com.quodatum.async;

import java.util.concurrent.ScheduledThreadPoolExecutor;

public class ExecutorSingleton {
	private static ScheduledThreadPoolExecutor instance = null;
	private static int poolSize=1; 
	protected ExecutorSingleton() {
	}
 
	// Lazy Initialization (If required then only)
	public static ScheduledThreadPoolExecutor getInstance() {
		if (instance == null) {
			// Thread Safe. Might be costly operation in some case
			synchronized (ExecutorSingleton.class) {
				if (instance == null) {
					instance = new ScheduledThreadPoolExecutor(poolSize);
				}
			}
		}
		return instance;
	}
	public static void poolSize(int newSize){
		poolSize=newSize;
		if(instance != null){
			instance.shutdownNow();
			instance=null;
		}
	}
	public static String status(){
		return instance.toString();
	}
}
