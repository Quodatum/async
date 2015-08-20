/**
 * 
 */
package com.quodatum.async;

import java.util.concurrent.Callable;
import java.util.concurrent.FutureTask;

import org.basex.query.value.Value;

/**
 * @author andy
 *
 */
public class XqFutureTask extends FutureTask<Value> {

	public XqFutureTask(Callable<Value> callable) {
		super(callable);
		// TODO Auto-generated constructor stub
	}

}
