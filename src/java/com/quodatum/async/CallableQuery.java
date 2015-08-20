package com.quodatum.async;

/*
 * Async query utilities
 * @copyright Quodatum
 * @licence BSD
 * @author andy bunce
 * @since aug 2015
 * 
 */
import java.util.Date;
import java.util.concurrent.Callable;

import org.basex.core.Context;
import org.basex.core.users.UserText;
import org.basex.query.QueryException;
import org.basex.query.QueryProcessor;
import org.basex.query.value.Value;
import org.basex.server.Log;
import org.basex.util.Performance;


public class CallableQuery implements Callable<Value> {
	private String xquery;
	private Context ctx;
	public Date started;
	public Date ended;

	public CallableQuery( Context context,String xquery) {
		this.xquery = xquery;
		this.ctx = new Context(context);
		this.ctx.user(ctx.users.get(UserText.ADMIN));
	}

	@Override
	public Value call() throws QueryException {
		try {
			log( "STARTED: "+xquery,null);
			Performance perf=new Performance();
			// Create a query processor
			@SuppressWarnings("resource")
			QueryProcessor proc = new QueryProcessor(xquery, ctx);
			// Execute the query
			Value value = proc.value();
			ended = new Date();
			// Print result as string.
			// System.out.println("result----------------");
			// System.out.println(value);
			log("ENDED", perf);
			//doAfter(ctx);
			return value;

		} catch (Exception ex) {
			// @TODO raise good error
			System.out.println(ex.getMessage());
			log( "ERROR: "+xquery,null);
			throw new QueryException(ex.getMessage());
		}
	}
	private void log(String msg,Performance perf){
		ctx.log.write("ASYNC", ctx.user(), Log.LogType.INFO, msg, perf);
	}
	private void doAfter(Context ctx) {
		// TODO Auto-generated method stub
		String xq="declare variable $v as xs:string external:='test2';admin:write-log($v, 'TASK')";
		
		// Execute the query
		try {
			@SuppressWarnings("resource")
			QueryProcessor proc = new QueryProcessor(xq, ctx);
			proc.bind("start", started);
			proc.value();
		} catch (QueryException e) {
		}
		
	}
}