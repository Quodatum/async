package com.quodatum.async;

/*
 * Run query trap errors
 * @copyright Quodatum
 * @licence BSD
 * @author andy bunce
 * @since sept 2015
 * 
 */
import org.basex.core.Context;
import org.basex.query.QueryException;
import org.basex.query.QueryProcessor;
import org.basex.query.value.Value;
import org.basex.server.Log;
import org.basex.server.Log.LogType;
import org.basex.util.Performance;

public class RunQuery {
	Context context = new Context();
	private Value result;
	private Boolean ok = false;
	private QueryProcessor proc;
	private String id;
	private String time;

	public RunQuery(String query, String id) {
		proc = new QueryProcessor(query, context);
		this.id = id;
	}

	public void bind(final String name, final Object value) {
		try {
			proc.bind(name, value);
		} catch (QueryException ex) {
			log(Log.LogType.ERROR, "bind" + " ERROR: " + ex.getMessage(), null);
		}
	}

	public Boolean run(String role) {
		// Create a query processor
		/** Performance timer, using nano seconds. */
		log(Log.LogType.INFO, role + " STARTED: " + proc.query(), null);
		long time = System.nanoTime();
		try {
			// Execute the query
			result = proc.value();
			time = System.nanoTime() - time;
			this.time = Math.round(time / 10000d) / 100d + " ms";

			log(Log.LogType.INFO, role + " ENDED " + this.time, null);
			// Print result as string.
			System.out.println(result);

			ok = true;
		} catch (Exception ex) {
			System.out.println(ex.getMessage());
			log(Log.LogType.ERROR, role + " ERROR: " + ex.getMessage(), null);
		}
		return ok;
	}

	public Value value() {
		return result;
	}

	public String time() {
		return time;
	}

	public void stop() {
		proc.stop();
	}

	private void log(LogType type, String msg, Performance perf) {
		context.log.write("ASYNC", context.user(), type, id + " " + msg, perf);
	}
}