package com.quodatum.async;

/*
 * Async query utilities
 * @copyright Quodatum
 * @licence BSD
 * @author andy bunce
 * @since aug 2015
 * 
 */
import java.util.concurrent.FutureTask;
import java.util.concurrent.TimeUnit;

import org.basex.core.Context;
import org.basex.query.QueryModule;
import org.basex.query.value.Value;
import org.basex.server.Log;
import org.basex.server.Log.LogType;
import org.basex.util.Performance;

public class Async extends QueryModule {
	private static Context context=new Context();
	
	/*
	 * time unit
	 */
	@Requires(Permission.NONE)
	public static TimeUnit timeUnit(final String unit) {
		return TimeUnit.valueOf(unit);
	}

	/*
	 * runnable for query
	 */
	@Requires(Permission.ADMIN)
	public static FutureTask<Value> futureTask(final String xquery) {
		return new FutureTask<Value>(new CallableQuery(context,xquery));
	}

	@Requires(Permission.ADMIN)
	public static FutureTask<Value> futureTask(final String xquery,final String fulfilled) {
		return new FutureTask<Value>(new CallableQuery(context,xquery,fulfilled));
	}
	@Requires(Permission.ADMIN)
	public static FutureTask<Value> futureTask(final String xquery,final String fulfilled,final String rejected) {
		return new FutureTask<Value>(new CallableQuery(context,xquery,fulfilled,rejected));
	}
	@Requires(Permission.ADMIN)
	public void writeLog( String msg) {
		context.log.write("ASYNC", context.user(), Log.LogType.INFO,  msg, null);
	}
	/*
	 * queue of tasks
	 */
	@Requires(Permission.ADMIN)
	public static Object[]  queue() {
		return ExecutorSingleton.getInstance().getQueue().toArray();
	}
	
}
