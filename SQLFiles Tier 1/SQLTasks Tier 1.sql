/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/*QUESTIONS*/
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */
SELECT name FROM `Facilities` WHERE membercost > 0;

/* Q2: How many facilities do not charge a fee to members? */
SELECT count(*) FROM `Facilities` WHERE membercost = 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */
SELECT facid, name, membercost, monthlymaintenance FROM `Facilities` 
WHERE membercost > 0
AND membercost < monthlymaintenance * 0.2;


/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */
SELECT * FROM `Facilities` WHERE facid in (1,5);


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */
SELECT name, monthlymaintenance,
CASE WHEN monthlymaintenance >100
THEN 'expensive'
ELSE 'cheap'
END AS label
FROM `Facilities`;


/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */
SELECT 
surname as lastname,
firstname
FROM `Members`;

/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */
SELECT DISTINCT
f.name as facility_name,
CONCAT_WS(' ', firstname, surname) as member_name
FROM `Bookings`
LEFT JOIN `Facilities` as f
USING (facid)
LEFT JOIN `Members` as m
USING (memid)
WHERE facid in (0,1)
ORDER BY member_name;

/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */
SELECT 
f.name as facility_name,
CONCAT_WS(' ', firstname, surname) as member_name,
case when memid = 0 then guestcost
else membercost end as cost
FROM `Bookings` as b
LEFT JOIN `Facilities` as f
USING (facid)
LEFT JOIN `Members` as m
USING (memid)
WHERE b.starttime like '2012-09-14%'
AND (
    (memid = 0 and guestcost > 30) or
    (memid != 0 and membercost > 30)
    );


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT 
f.name as facility_name,
CONCAT_WS(' ', firstname, surname) as member_name,
case when memid = 0 then guestcost
else membercost end as cost
FROM `Bookings` as b
LEFT JOIN `Facilities` as f
USING (facid)
LEFT JOIN `Members` as m
USING (memid)
WHERE b.starttime like '2012-09-14%'
AND (
    (memid = 0 and guestcost > 30) or
    (memid != 0 and membercost > 30)
    );

/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

('Table Tennis', 90)
('Snooker Table', 115)
('Pool Table', 265)
('Badminton Court', 604.5)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

(15, 'Bader', 'Florence', '264 Ursula Drive, Westford', 84923, '(833) 499-3527', '9', '2012-08-10 17:52:03')
(16, 'Baker', 'Timothy', '329 James Street, Reading', 58393, '833-941-0824', '13', '2012-08-15 10:34:25')
(5, 'Butters', 'Gerald', '1065 Huntingdon Avenue, Boston', 56754, '(844) 078-4130', '1', '2012-07-09 10:44:09')
(13, 'Farrell', 'Jemima', '103 Firth Avenue, North Reading', 57392, '(855) 016-0163', '', '2012-08-10 14:28:01')
(20, 'Genting', 'Matthew', '4 Nunnington Place, Wingfield, Boston', 52365, '(811) 972-1377', '5', '2012-08-19 14:55:55')
(11, 'Jones', 'David', '976 Gnats Close, Reading', 33862, '(844) 536-8036', '4', '2012-08-06 16:32:55')
(4, 'Joplette', 'Janice', '20 Crossing Road, New York', 234, '(833) 942-4710', '1', '2012-07-03 10:25:05')
(30, 'Purview', 'Millicent', '641 Drudgery Close, Burnington, Boston', 34232, '(855) 941-9786', '2', '2012-09-18 19:04:01')
(3, 'Rownam', 'Tim', '23 Highway Way, Boston', 23423, '(844) 693-0723', '', '2012-07-03 09:32:15')
(1, 'Smith', 'Darren', '8 Bloomsbury Close, Boston', 4321, '555-555-5555', '', '2012-07-02 12:02:05')
(2, 'Smith', 'Tracy', '8 Bloomsbury Close, New York', 4321, '555-555-5555', '', '2012-07-02 12:08:23')
(9, 'Stibbons', 'Ponder', '5 Dragons Way, Winchester', 87630, '(833) 160-3900', '6', '2012-07-25 17:09:05')
(6, 'Tracy', 'Burton', '3 Tunisia Drive, Boston', 45678, '(822) 354-9973', '', '2012-07-15 08:52:55')

/* Q12: Find the facilities with their usage by member, but not guests */
('Badminton Court', 344)
('Massage Room 1', 421)
('Massage Room 2', 27)
('Pool Table', 783)
('Snooker Table', 421)
('Squash Court', 195)
('Table Tennis', 385)
('Tennis Court 1', 308)
('Tennis Court 2', 276)


/* Q13: Find the facilities usage by month, but not guests */
('Badminton Court', 18, '07')
('Badminton Court', 662, '08')
('Badminton Court', 2141, '09')
('Massage Room 1', 1, '07')
('Massage Room 1', 666, '08')
('Massage Room 1', 2154, '09')
('Massage Room 2', 99, '07')
('Massage Room 2', 671, '08')
('Massage Room 2', 2160, '09')
('Pool Table', 4, '07')
('Pool Table', 680, '08')
('Pool Table', 2172, '09')
('Snooker Table', 3, '07')
('Snooker Table', 677, '08')
('Snooker Table', 2166, '09')
('Squash Court', 2, '07')
('Squash Court', 673, '08')
('Squash Court', 2162, '09')
('Table Tennis', 0, '07')
('Table Tennis', 665, '08')
('Table Tennis', 2145, '09')
('Tennis Court 1', 6, '07')
('Tennis Court 1', 658, '08')
('Tennis Court 1', 2130, '09')
('Tennis Court 2', 17, '07')
('Tennis Court 2', 660, '08')
('Tennis Court 2', 2135, '09')
