package gov.nih.nci.gss.api;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.NameValuePair;
import org.apache.http.client.ResponseHandler;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.impl.client.BasicResponseHandler;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.protocol.HTTP;
import org.apache.log4j.Logger;

/**
 * A background query which runs against the caB2B REST API. Specify the parameters
 * and run this object in a thread. It will call the queryComplete() in the
 * specified QueryService when it has completed. At that point isDone() will be 
 * returning true, and there will either be an error which is accessible with 
 * getException() or a result accessible with getResultJson().
 * 
 * @author <a href="mailto:rokickik@mail.nih.gov">Konrad Rokicki</a>
 */
public class Cab2bQuery implements Runnable, Serializable {

    private static Logger log = Logger.getLogger(Cab2bQuery.class);
    
    private transient final QueryService queryService;
    
    private final QueryParams params;

    private String jobId;
    
    private boolean isDone;
    
    private String resultJson;

    private Exception exception;
    
    /**
     * Create a new query, ready to be run.
     * @param params the parameters to use
     * @param service the QueryService to notify when the query is done
     */
    public Cab2bQuery(String jobId, QueryParams params, QueryService service) {
    	this.jobId = jobId;
        this.params = params;
        this.queryService = service;
    }

    /**
     * Implements Runnable.
     */
    public void run() {

    	DefaultHttpClient httpclient = new DefaultHttpClient();
        
        try {
            log.info("Executing query: "+getJobId());

        	String modelGroup = queryService.getCab2bTranslator().getModelGroupForServiceGroup(params.getServiceGroup());
        	
            List<NameValuePair> parameters = new ArrayList<NameValuePair>();
            parameters.add(new BasicNameValuePair("searchString", params.getSearchString()));
            parameters.add(new BasicNameValuePair("modelGroup", modelGroup));
            parameters.add(new BasicNameValuePair("serviceUrl", params.getServiceUrl()));

            String url = queryService.getQueryURL()+"?"+URLEncodedUtils.format(parameters, HTTP.UTF_8);
            
            HttpGet httpget = new HttpGet(url);
            ResponseHandler<String> responseHandler = new BasicResponseHandler();
            String result = httpclient.execute(httpget, responseHandler);

            log.info("Completed query "+getJobId()+", Response length: "+result.length());
            
            synchronized (this) {
                this.resultJson = result;
                this.isDone = true;
                queryService.queryCompleted(this);
            }
        }
        catch (Exception e) {
        	log.info("Caught exception",e);
            synchronized (this) {
                this.exception = e;
                this.isDone = true;
                queryService.queryCompleted(this);
            }
        }
        finally {
        	httpclient.getConnectionManager().shutdown();
        }
    }

    /**
     * Return the parameters for this query.
     * @return
     */
    public QueryParams getQueryParams() {
        return params;
    }

    /**
     * Has the query been run and completed?
     * @return
     */
    public synchronized boolean isDone() {
        return isDone;
    }

    /**
     * The unique identifier of this query job.
     * @return
     */
    public String getJobId() {
		return jobId;
	}

	/**
     * Returns the resulting JSON. 
     * Note: this may contain an application-specific error.
     * @return
     */
    public synchronized String getResultJson() {
        return resultJson;
    }

    /**
     * Returns the exception which occurred during query processing, if any.
     * @return
     */
    public synchronized Exception getException() {
        return exception;
    }

}
