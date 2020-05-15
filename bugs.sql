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

DISCLAIMER: I have no experience with SQL and I am not 100% clear with its full capabilities.

*/

/*
Process:
1. Receive query
2. Take info, put into database
3. Analyze and label query
4. Send to various departments in order of priority
5. Resolve

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

CREATE TABLE QUERY (
	/* Store info about data collection */

	Type 			CHAR	(30), 		/* Complaint, bug, suggestion, etc. */
	MethodCollected	CHAR	(10), 		/* Mail or electronic. This could be stored in a Boolean variable */
	ClientNumber	INT, 				/* Store the number of the client who sent the query */
	DateReceived 	DATE,			/* Format: YYYYMMDD */

	QueryNumber 	INT,				/* Add query to queue */
	Query 			CHAR 	(1000),		/* Store the text of the query. This is a bit memory inefficient, but bundles all the data together */

	/* Store which department it should go to */
	Priority 		INT,				/* Flag more important queries */
	Department 		CHAR	(20),		/* Choose which department to direct the query to */
	DateResolved 	DATE				/* Date resolved or NULL */

);


/* Find all unlabelled queries */
SELECT * FROM QUERY WHERE Priority IS NULL;

