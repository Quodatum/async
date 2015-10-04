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
import java.util.concurrent.Callable;

import org.basex.core.Context;
import org.basex.core.users.UserText;
import org.basex.query.value.Value;

public class CallableQuery implements Callable<Value> {
	private String xquery;
	private String fulfilled;
	private String rejected;
	private Context ctx;
	String id = this.toString();

	public CallableQuery(Context context, String xquery) {
		this(context, xquery, null, null);

	}

	public CallableQuery(Context context, String xquery, String fulfilled) {
		this(context, xquery, fulfilled, null);
	}

	public CallableQuery(Context context, String xquery, String fulfilled,
			String rejected) {
		this.xquery = xquery;
		this.fulfilled = fulfilled;
		this.rejected = rejected;
		// @TODO use or remove
		this.ctx = new Context(context);
		this.ctx.user(ctx.users.get(UserText.ADMIN));

	}

	@Override
	public Value call() {
		RunQuery q1 = new RunQuery(xquery, id);
		if (q1.run("xquery")) {
			if (fulfilled != null) {
				RunQuery q2 = new RunQuery(fulfilled, id);
				q2.bind("value", q1.value());
				q2.bind("time", q1.time());
				q2.run("fulfilled");
			}
		} else {
			if (rejected != null) {
				RunQuery q3 = new RunQuery(rejected, id);
				q3.run("rejected");
			}
		}
		return q1.value();
	}
}
