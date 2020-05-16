/* SQL database to store client queries

You are Chief Troubleshooter at a SAAS company called Bloop. Your service has a built-in feedback form
that users can fill out to submit bugs or suggestions to the Bloop team. You must manage the timely influx
and resolution of these user submissions. Design an SQL database structure that will account for all of the
information you think you might need to handle such a task. Provide the tables, fields, and relationships
for your database. As Chief Troubleshooter, what are some common queries that you might employ?
Provide the full SQL code for one such SQL query.
Bloop’s user base is old-fashioned; 70% of the feedback forms you receive are mailed in by paper
envelope. How do you account for this in the management of your database?
If you like, you may refine what the Bloop service does to help develop your thoughts.

*/

/*
	TABLES OF INFORMATION

	1. Client table. Stores information about the clients
	2. Product table. Stores information about the product
	3. Feedback table. Stores information about feedback.

 */

CREATE DOMAIN D_STATUS VARCHAR(11)
	CHECK (VALUE IN ('Raw Data', 'In Progress', 'Done'));


CREATE DOMAIN D_METHODCOLLECTED VARCHAR(10)
	CHECK (VALUE IN ('Mail', 'Electronic'));

CREATE DOMAIN D_DEPARTMENT VARCHAR(8)
	CHECK (VALUE IN ('Finance', 'R and D', 'PR', 'Safety'));

CREATE TABLE CLIENT (
	/* Contact information */
	ClientName		VARCHAR		(30),
	ClientNumber	INT 		NOT NULL,

	Address			VARCHAR 	(30),
	PostalCode 		CHAR 		(6),

	City			VARCHAR 	(20),
	Country 		VARCHAR 	(20),

	DateJoined	 	DATE,

	PRIMARY KEY 	(ClientNumber) 
);

CREATE TABLE PRODUCT (
	ProductName 	VARCHAR 	(20),
	ProductNumber 	INT,
	Department 		VARCHAR 	(20)
);

CREATE TABLE FEEDBACK (
	/* Store info about data collection */

	Type 			VARCHAR	(30), 		/* Complaint, bug, suggestion, etc. */
	MethodCollected	D_METHODCOLLECTED,	/* Mail or Electronic. This could be stored in a Boolean variable */
	ClientNumber	INT, 				/* Store the number of the client who sent the feedback */
	DateReceived 	DATE,				/* Format: YYYY-MM-DD */

	IDNumber 		INT 	NOT NULL,	/* Give feedback and ID number. This will keep its place in the queue */
	Feedback		VARCHAR (1000),		/* Store the text of the feedback. This is a bit memory inefficient, but bundles all the data together */

	Status 			D_STATUS,	 		-- Raw Data, In Progress, or Done

	/* Store which department it should go to */
	Priority 		INT,				/* Flag more important queries */
	Department 		D_DEPARTMENT,		/* Choose which department to direct the feedback to */
	ProductNumber 	INT, 				/* Product number of item */
	DateResolved 	DATE,				/* Date resolved or NULL */

	PRIMARY KEY 	(IDNumber),
	FOREIGN KEY 	(ClientNumber) REFERENCES CLIENT (ClientNumber),
	FOREIGN KEY 	(ProductNumber) REFERENCES PRODUCT (ProductNumber)

);

/* 
	EXAMPLE CODE TO DEAL WITH FEEDBACK
	
	1. Take example raw feedback
	2. Analyze the feedback, label it appropriately
	3. Having resolved the feedback, mark the feedback as Done

 */


/* 1. Add a feedback into the database */


-- Generate next feedback number
SELECT 	MAX(IDNumber)
AS 		EndQueue
FROM 	FEEDBACK;

-- Add raw feedback info into queue
INSERT INTO FEEDBACK (Type, MethodCollected, ClientNumber, DateReceived, FeedbackNumber, Feedback, Status)
VALUES 		('Bug', 'Electronic', 12345, 2020-05-13, EndQueue+1, 'Finance Program crashed!', 'Raw Data');


/* 2. Analyze and label feedback */


-- Find lowest IDNumber of unlabelled queries
SELECT 	MIN(IDNumber)
AS 		StartQueue
FROM 	FEEDBACK
WHERE 	Status='Raw Data';

-- Label this feedback appropriately
UPDATE 	FEEDBACK
SET 	Status='In Progress', Priority='0',Department='Finance',ProductNumber=54321
WHERE 	IDNumber = StartQueue


/* 3. Resolve feedback */


-- After the feedback has been resolved, mark as done
UPDATE 	FEEDBACK
SET 	Status='Done',DateResolved=2020-05-15
WHERE 	IDNumber = StartQueue
