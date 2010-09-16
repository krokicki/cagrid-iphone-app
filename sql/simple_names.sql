
TRUNCATE TABLE SIMPLE_NAME;


-- %% RULES FOR HIDING SERVICES %%

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME,HIDE) VALUES ("ServiceName",
"^(AuthenticationService)$","$1",1);

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME,HIDE) VALUES ("ServiceName",
"^(CredentialDelegationService)$","$1",1);

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME,HIDE) VALUES ("ServiceName",
"^(GTS)$","$1",1);

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME,HIDE) VALUES ("ServiceName",
"^(Dorian)$","$1",1);


-- %% RULES FOR HIDING HOSTS %%

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME,HIDE) VALUES ("HostName",
"^(bdarc)$","$1",1);

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME,HIDE) VALUES ("HostName",
"^(QA)$","$1",1);



-- %% RULES FOR SERVICE NAMES %%

-- Remove "service" from service name

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",
"(Grid|Data|Analytical)?(Service|Svc)(_v\\d+_\\d+|\\d+)?$","");

-- Lowercase "ca" prefix

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",
"^Ca([A-Z])","ca$1");

-- caBIO43 -> caBIO

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",
"^(caBIO)\\d+$","$1");

-- camod -> caMOD

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",
"^camod$","caMOD");

-- Washu-CaTissueSuite -> caTissue Suite

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("ServiceName",
"^Washu-CaTissueSuite$","caTissue Suite");


-- %% RULES FOR HOST NAMES %%

-- Remove trailing whitespace

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"(.*?)\\s+$","$1");

-- Remove quotes

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^\"(.*?)\"$","$1");

-- Add a space after any punctuation

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"(\\w)[\\.,;](\\w)","$1. $2");

-- Fred Hutch Cancer Research Center

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^Fred Hutch Cancer Research Center$","Fred Hutchinson Cancer Research Center");

-- caNanoLab-GTEM

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^(.*?)-GTEM$","GTEM");

-- caNanoLab-NCICBIIT
-- CBIIT
-- NCI CBIIT
-- NCI CBITT (misspelling)
-- NCICBIIT

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^.*?(NCI\\s?)?CBI(I|T)T.*?$","NCI Center for Biomedical Informatics and Information Technology");

-- Center for Biomedical Informatics and Information Technology

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^(Center for Biomedical Informatics and Information Technology)$","NCI $1");

-- National Cancer Institute Center for Bioinformatics

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^National Cancer Institute Center for (Bioinformatics|Biomedical Informatics and Information Technology)$","NCI Center for Biomedical Informatics and Information Technology");

-- The Broad Institute of MIT and Harvard

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^(The Broad Institute).+$","Broad Institute");

-- UVA Medical School - Public Health Sciences
-- UVA Cancer Center - Public Health Sciences

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^UVA (\\w+) - Public Health Sciences","University of Virginia Public Health Sciences");

-- University of Manchester, Computer Science, myGrid test services

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^University of Manchester.*?$","University of Manchester");

-- University of Virginia Public Health Sciences Admin

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^University of Virginia Public Health Sciences Admin$","University of Virginia Public Health Sciences");

-- Washington University
-- Washington University at St. Louis

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^Washington University( at St\\. Louis)?$","Washington University in St. Louis");

-- Center for Biomedical Informatics (actually WUSTL CBMI)

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^Center for Biomedical Informatics$","Washington University in St. Louis");

-- H.Lee. Moffitt Cancer Center
-- INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
-- "^H\.Lee\. Moffitt Cancer Center$","H. Lee. Moffitt Cancer Center");

-- nntc

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^nntc$","National NeuroAIDS Tissue Consortium");


-- Are these still used?

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^WESTAT$","Westat Inc.");

INSERT INTO SIMPLE_NAME (TYPE,PATTERN,SIMPLE_NAME) VALUES ("HostName",
"^The (Holden Comprehensive Cancer Center)$","$1");

