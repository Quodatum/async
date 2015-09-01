package com.quodatum.async;

/**
 * This class provides a callable  execution of QueryProcessor
 * (attribute values, text contents, full-texts).
 *
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
import org.basex.query.QueryIOException;
import org.basex.query.QueryProcessor;
import org.basex.query.value.Value;
import org.basex.query.value.ValueBuilder;
import org.basex.query.value.node.FElem;
import org.basex.server.Log;
import org.basex.server.Log.LogType;
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
	public Value call()  {
		Boolean error=false;
		try {
			log(Log.LogType.INFO, "STARTED: "+xquery,null);
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
			log(Log.LogType.INFO,"ENDED", perf);
			onFulfilled();
			return value;

		} catch (Exception ex) {
			// @TODO raise good error
			error=true;
			System.out.println(ex.getMessage());
			log(Log.LogType.ERROR, "ERROR: "+ex.getMessage(),null);
			FElem elem2 = new FElem("eror");
			ValueBuilder vb = new ValueBuilder();
			vb.add(elem2);
			return vb.value();
		} 
	}
	
	private void log(LogType type, String msg,Performance perf){
		 String id=this.toString();
		ctx.log.write("ASYNC", ctx.user(), Log.LogType.INFO, id + " "+msg, perf);
	}
	
	
	// called after successful call
	private void onFulfilled() {
		String xq="2+3";
		log(Log.LogType.INFO,"FULFILLED", null);
		// Execute the query
		try {
			@SuppressWarnings("resource")
			QueryProcessor proc = new QueryProcessor(xq, this.ctx);
			proc.bind("start", started);
			Value value = proc.value();
			value.serialize();
		} catch (Exception e) {
			log(Log.LogType.ERROR, "FULFILLED: "+e.getMessage(),null);
		} 
		
	}
	private void onRejected(Context ctx) {
//@todo
	}
}
