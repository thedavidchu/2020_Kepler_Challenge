/* SQL database to store client queries*/

CREATE TABLE CLIENT (
	/* Contact information */
	ClientName	CHAR (30),
	ClientNumber	INT(10),
	Address		CHAR(30),
	City		CHAR(20),
	Country 	CHAR(20),

	/* Store type of data collected */

	Type 		CHAR(30),
	DateReceived 	CHAR(8) 
);

CREATE TABLE QUERY (
	/* Store type of data collected */

	Type 		CHAR(30),
	MethodCollected	CHAR(10), /* Mail or electronic. This could be stored in a Boolean variable */
	DateReceived 	CHAR(8) 

);
