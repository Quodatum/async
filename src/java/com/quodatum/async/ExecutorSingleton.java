package com.quodatum.async;
/**
 * This class provides a ThreadPoolExecutor
 * 
 *
 * @copyright Quodatum
 * @licence BSD
 * @author andy bunce
 * @since aug 2015
 * 
 */
import java.util.concurrent.ScheduledThreadPoolExecutor;

import org.basex.query.QueryModule;
import org.basex.query.QueryResource;

public class ExecutorSingleton extends QueryModule implements QueryResource{
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

	@Override
	public void close() {
		// TODO Auto-generated method stub
		
	}
}
