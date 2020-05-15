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

CREATE TABLE CLIENT (
	/* Contact information */
	ClientName		CHAR	(30),
	ClientNumber	INT,

	Address			CHAR 	(30),
	PostalCode 		CHAR 	(6),

	City			CHAR 	(20),
	Country 		CHAR 	(20),

	DateJoined	 	CHAR	(8) 
);

CREATE TABLE PRODUCT (
	ProductName 	CHAR 	(20),
	ProductNumber 	INT,
	Department 		CHAR 	(20)

);

CREATE TABLE FEEDBACK (
	/* Store info about data collection */

	Type 			CHAR	(30), 		/* Complaint, bug, suggestion, etc. */
	MethodCollected	CHAR	(10), 		/* Mail or Electronic. This could be stored in a Boolean variable */
	ClientNumber	INT, 				/* Store the number of the client who sent the feedback */
	DateReceived 	DATE,				/* Format: YYYY-MM-DD */

	FeedbackNumber 	INT,				/* Add feedback to queue */
	Feedback		CHAR 	(1000),		/* Store the text of the feedback. This is a bit memory inefficient, but bundles all the data together */

	Status 			CHAR 	(11) 		-- Raw Data, In Progress, or Done

	/* Store which department it should go to */
	Priority 		INT,				/* Flag more important queries */
	Department 		CHAR	(20),		/* Choose which department to direct the feedback to */
	ProductNumber 	INT, 				/* Product number of item */
	DateResolved 	DATE				/* Date resolved or NULL */

);

/* 
	EXAMPLE CODE TO DEAL WITH FEEDBACK
	
	1. Take example raw feedback
	2. Analyze the feedback, label it appropriately
	3. Having resolved the feedback, mark the feedback as Done

 */


/* 1. Add a feedback into the database */


-- Generate next feedback number
SELECT MAX(FeedbackNumber)
AS EndQueue
FROM FEEDBACK;

-- Add Feedback info
INSERT INTO FEEDBACK (Type, MethodCollected, ClientNumber, DateReceived, FeedbackNumber, Feedback, Status)
VALUES ('Bug', 'Electronic', 12345, 2020-05-13, EndQueue+1, 'Finance Program crashed!', 'Raw Data');


/* 2. Analyze and label feedback */


-- Find lowest FeedbackNumber of unlabelled queries
SELECT MIN(FeedbackNumber)
AS StartQueue
FROM FEEDBACK
WHERE Status='Raw Data';

-- Label this feedback appropriately
UPDATE FEEDBACK
SET Status='In Progress', Priority='0',Department='Finances',ProductNumber=54321
WHERE FeedbackNumber = StartQueue


/* 3. Resolve feedback */


-- After the feedback has been resolved, mark as done
UPDATE FEEDBACK
SET Status='Done',DateResolved=2020-05-15
WHERE FeedbackNumber = StartQueue
