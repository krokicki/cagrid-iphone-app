package gov.nih.nci.gss.grid;

import gov.nih.nci.cagrid.discovery.client.DiscoveryClient;
import gov.nih.nci.cagrid.metadata.MetadataUtils;
import gov.nih.nci.cagrid.metadata.ServiceMetadata;
import gov.nih.nci.cagrid.metadata.dataservice.UMLClass;
import gov.nih.nci.cagrid.metadata.common.Address;
import gov.nih.nci.cagrid.metadata.common.PointOfContact;
import gov.nih.nci.cagrid.metadata.common.ResearchCenter;
import gov.nih.nci.cagrid.metadata.dataservice.DomainModel;
import gov.nih.nci.cagrid.metadata.exceptions.InvalidResourcePropertyException;
import gov.nih.nci.cagrid.metadata.exceptions.QueryInvalidException;
import gov.nih.nci.cagrid.metadata.exceptions.RemoteResourcePropertyRetrievalException;
import gov.nih.nci.cagrid.metadata.exceptions.ResourcePropertyRetrievalException;
import gov.nih.nci.cagrid.metadata.service.Service;
import gov.nih.nci.gss.grid.GridAutoDiscoveryException;
import gov.nih.nci.gss.util.Constants;
import gov.nih.nci.gss.DomainClass;
import gov.nih.nci.gss.GridService;
import gov.nih.nci.gss.DataService;
import gov.nih.nci.gss.AnalyticalService;
import gov.nih.nci.gss.HostingCenter;

import java.net.ConnectException;
import java.net.SocketException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;

import org.apache.axis.message.addressing.EndpointReferenceType;
import org.apache.axis.types.URI.MalformedURIException;
import org.apache.log4j.Logger;

/**
 * Borrowed from caNanoLab project Grid service utils for grid node discovery
 * and grid node URL lookup.  Subsequently reborrowed from LSDB.
 * 
 * @author sahnih, pansu, piepenbringc
 * 
 */
public class GridIndexService {
	private static Logger logger = Logger
			.getLogger(GridIndexService.class.getName());

	/**
	 * Query the grid index service by domain model name and return a list of
	 * EndpointReferenceType.
	 * 
	 * @param indexServiceURL
	 * @param application
	 * @param extantURLs
	 * @param appOwner
	 * @return
	 * @throws GridAutoDiscoveryException
	 */
	public static List<GridService> discoverGridServices() throws GridAutoDiscoveryException {
		EndpointReferenceType[] returnedServices = null;
		List<EndpointReferenceType> services = null;
		String indexServiceURL = getGridIndexServiceUrl();

		try {
			DiscoveryClient discoveryClient = new DiscoveryClient(
					indexServiceURL);
			returnedServices = discoveryClient.getAllServices(true);
		} catch (MalformedURIException e) {
			logger.error(e.getMessage(), e);
		} catch (RemoteResourcePropertyRetrievalException e) {
			logger.error(e.getMessage(), e);
		} catch (QueryInvalidException e) {
			logger.error(e.getMessage(), e);
		} catch (ResourcePropertyRetrievalException e) {
			logger.error(e.getMessage(), e);
		}

		if (returnedServices != null) {
			services = new ArrayList<EndpointReferenceType>(Arrays
					.asList(returnedServices));
		}
		return populateServiceMetadata(services);
	}

	public static List<GridService> populateServiceMetadata(
			List<EndpointReferenceType> services) {
		Set<GridService> gridNodeSet = new HashSet<GridService>();
		if (services != null) {
			for (EndpointReferenceType service : services) {
				GridService gridNode = null;
				try {
					ServiceMetadata serviceMetaData = MetadataUtils.getServiceMetadata(service);
					if (serviceMetaData != null) {
						DomainModel domainModel = null;
						try {
						domainModel = MetadataUtils.getDomainModel(service);
						} catch (Exception e) {
							String err = "No domain model for: "
								+ service.getAddress().toString();
							logger.info(err);
						}
						gridNode = populateGridService(service,serviceMetaData,domainModel);
					}
				} catch (Exception e) {
					String err = "Can't successfully obtain grid service metadata: "
							+ service.getAddress().toString();
					logger.warn(err);
				}
				if (gridNode != null) {
					logger.info("Adding a GridService: " + gridNode.getName() + " : "
							+ gridNode.getUrl());
					gridNodeSet.add(gridNode);
				}
			}
		}
		return new ArrayList<GridService>(gridNodeSet);
	}

	public static String getServiceVersion(EndpointReferenceType service) {
		String version = null;
		if (service != null) {
			try {
				DomainModel model = gov.nih.nci.cagrid.metadata.MetadataUtils
						.getDomainModel(service);
				version = model.getProjectVersion();
				String desp = model.getProjectDescription();
				logger.debug("Model Version: " + desp);
			} catch (InvalidResourcePropertyException e) {
				logger.warn(e.getMessage(), e);
			} catch (RemoteResourcePropertyRetrievalException e) {
				logger.warn(e.getMessage(), e);
			} catch (ResourcePropertyRetrievalException e) {
				logger.warn(e.getMessage(), e);
			}
		}
		return version;
	}
	
    public static GridService populateGridService(EndpointReferenceType serviceER, ServiceMetadata metadata, DomainModel model) {    	
    	// TODO: Populate Grid Service
    	GridService newService = null;
    	
    	if (metadata != null && model != null) {
    		newService = new DataService();
    	} else {
    		newService = new AnalyticalService();
    	}
    	
    	// Get the buried service description from the metadata
    	Service serviceData = metadata.getServiceDescription().getService();

    	// Build GridService object
    	newService.setName(serviceData.getName());
    	newService.setDescription(serviceData.getDescription());
    	newService.setVersion(serviceData.getVersion());
    	newService.setUrl(serviceER.getAddress().toString());
    	newService.setType(translateServiceType(serviceData.getName()));
    	
    	// Get POC objects
		newService.setPointOfContacts(populatePOCList(serviceData.getPointOfContactCollection().getPointOfContact()));
    	
    	// Build Hosting Center object
		newService.setHostingCenter(populateHostingCenter(metadata));
		
		// Build Domain Model object for data services
		if (newService.getClass() == DataService.class) {
			((DataService)newService).setDomainModel(populateDomainModel(model));
		}
		
    	logger.debug("Built GridService for " + newService.getName());
    	return newService;
    }
    
    private static gov.nih.nci.gss.DomainModel populateDomainModel(DomainModel model) {
    	gov.nih.nci.gss.DomainModel newModel = new gov.nih.nci.gss.DomainModel();
    	
    	newModel.setDescription(model.getProjectDescription());
    	newModel.setLongName(model.getProjectLongName());
    	newModel.setVersion(model.getProjectVersion());

    	Collection<DomainClass> classList = new HashSet<DomainClass>();
    	for (UMLClass umlClass : model.getExposedUMLClassCollection().getUMLClass()) {
    	  DomainClass newClass = new DomainClass();
    	  
    	  newClass.setClassName(umlClass.getClassName());
    	  newClass.setDescription(umlClass.getDescription());
    	  newClass.setDomainPackage(umlClass.getPackageName());
    	  classList.add(newClass);
    	}
		newModel.setClasses(classList);
		
		return newModel;
	}

	private static Collection<gov.nih.nci.gss.PointOfContact> populatePOCList(gov.nih.nci.cagrid.metadata.common.PointOfContact[] POCs) {

    	Collection<gov.nih.nci.gss.PointOfContact> POClist = new HashSet<gov.nih.nci.gss.PointOfContact>();
		
		for (gov.nih.nci.cagrid.metadata.common.PointOfContact POC : POCs) {
			gov.nih.nci.gss.PointOfContact newPOC = new gov.nih.nci.gss.PointOfContact();
			
			newPOC.setAffiliation(POC.getAffiliation());
			newPOC.setEmail(POC.getEmail());
			newPOC.setRole(POC.getRole());
			String name = POC.getFirstName();
			if (name == null || name.trim().length() == 0) {
				name = POC.getLastName();
			} else {
				name = name + " " + POC.getLastName();
			}
			newPOC.setName(name);
			POClist.add(newPOC);
		}
		return POClist;
	}

	private static HostingCenter populateHostingCenter(ServiceMetadata metadata) {
		gov.nih.nci.gss.HostingCenter newCenter = new gov.nih.nci.gss.HostingCenter();

		ResearchCenter center = metadata.getHostingResearchCenter().getResearchCenter();
		
		if (center != null) {
			Address rcAddress = center.getAddress();
			newCenter.setCountryCode(rcAddress.getCountry());
			newCenter.setLocality(rcAddress.getLocality());
			newCenter.setPostalCode(rcAddress.getPostalCode());
			newCenter.setStateProvince(rcAddress.getStateProvince());
			String streetAddr = rcAddress.getStreet2();
			if (streetAddr == null || streetAddr.trim().length() == 0) {
				streetAddr = rcAddress.getStreet1();
			} else {
				streetAddr = rcAddress.getStreet1() + "\n" + streetAddr;
			}
			newCenter.setStreet(streetAddr);
			newCenter.setLongName(center.getDisplayName());
			newCenter.setShortName(center.getShortName());
			
			// Build Hosting Center POCs
			newCenter.setPointOfContacts(populatePOCList(center.getPointOfContactCollection().getPointOfContact()));
		}
		
		return newCenter;
	}

	private static String translateServiceType(String name) {
		// TODO Translate names
		return name;
	}

	public static String getGridIndexServiceUrl() {
       	String indexService = System.getProperty(Constants.GRID_INDEX_SERVICE_URL);       
    	return ("http://" + indexService);
    }

}