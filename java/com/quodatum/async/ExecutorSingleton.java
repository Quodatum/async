package com.quodatum.async;

import java.util.concurrent.ScheduledThreadPoolExecutor;

public class ExecutorSingleton {
	private static ScheduledThreadPoolExecutor instance = null;
	private static int threads=1; 
	protected ExecutorSingleton() {
	}
 
	// Lazy Initialization (If required then only)
	public static ScheduledThreadPoolExecutor getInstance() {
		if (instance == null) {
			// Thread Safe. Might be costly operation in some case
			synchronized (ExecutorSingleton.class) {
				if (instance == null) {
					instance = new ScheduledThreadPoolExecutor(threads);
				}
			}
		}
		return instance;
	}
	public static void threads(int newThreads){
		threads=newThreads;
		if(instance != null){
			instance.shutdownNow();
			instance=null;
		}
	}
	public static String status(){
		return instance.toString();
	}
}
