
TRUNCATE TABLE SIMPLE_NAME;

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","CaDSR.*?","caDSR");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","EVS.*?","Enterprise Vocabulary Service");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",".*?CaArray.*?","caArray");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","caTissue_Core.*?","caTissue Core");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","caTissue_Suite.*?","caTissue Suite");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",".*?CaTissueCore.*?","caTissue Core");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",".*?CaTissueSuite.*?","caTissue Suite");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","NCIA.*?","NCIA");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","caTissue.*?","caTissue");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","ChromosomalSegmentOverlapAcrossSources","CSOAS");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","OpenClinicaCRF","OpenClinical CRF");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","WorkflowFactoryService","Workflow Factory");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","TavernaWorkflowService","Taverna");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","AuthenticationService","Authentication");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","GlobalModelExchange","GME");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","GridGrouper","Grid Grouper");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","CredentialDelegationService","Credential Delegation");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName","FederatedQueryProcessor","Federated Query Processor ");

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName","NCI(\\s)?CB(IIT)?","NCI Center for Biomedical Informatics and Information Technology");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",".*?-\s?NCICB","NCI Center for Biomedical Informatics and Information Technology");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",".*?-\s?WUSTL","Washington University in St.Louis");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",".*?-\s?NCL","Nanotechnology Characterization Laboratory");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",".*?-\s?GTEM","GTEM");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",".*?-\s?Stanford","Stanford University Cancer Center");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName","The Broad Institute.+","The Broad Institute");
INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName","Center for Biomedical Informatics and Information Technology","NCI Center for Biomedical Informatics and Information Technology");
