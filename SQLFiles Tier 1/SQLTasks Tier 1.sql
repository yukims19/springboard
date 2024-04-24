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
FROM `Members`
WHERE joindate = (select max(joindate) FROM `Members`);

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
CONCAT_WS(' ', firstname, surname) AS member_name,
CASE WHEN memid = 0 THEN guestcost
ELSE membercost end AS cost
FROM `Bookings` AS b
LEFT JOIN `Facilities` AS f
USING (facid)
LEFT JOIN `Members` AS m
USING (memid)
WHERE b.starttime LIKE '2012-09-14%'
AND (
    (memid = 0 and guestcost > 30) or
    (memid != 0 and membercost > 30)
    );


/* Q9: This time, produce the same result as in Q8, but using a subquery. */
SELECT 
f.name as facility_name,
CONCAT_WS(' ', firstname, surname) as member_name,
CASE WHEN memid = 0 THEN guestcost
ELSE membercost END as cost
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

SELECT * FROM (SELECT 
f.name as facility_name,
SUM(
    CASE WHEN memid = 0 THEN guestcost
ELSE membercost END 
) as total_revenue
FROM `Bookings` as b
LEFT JOIN `Facilities` as f
USING (facid)
LEFT JOIN `Members` as m
USING (memid)
GROUP BY facility_name) as revenue
WHERE total_revenue < 1000;

('Table Tennis', 90)
('Snooker Table', 115)
('Pool Table', 265)
('Badminton Court', 604.5)

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT 
m.memid,
m.surname,
m.firstname,
m2.firstname as recomender_firstname,
m2.surname as recomender_surname
FROM `Members` as m
left join `Members` as m2
on m.recommendedby = m2.memid
where m.memid != 0
order by m.surname, m.firstname;

(15, 'Bader', 'Florence', 'Ponder', 'Stibbons')
(12, 'Baker', 'Anne', 'Ponder', 'Stibbons')
(16, 'Baker', 'Timothy', 'Jemima', 'Farrell')
(8, 'Boothe', 'Tim', 'Tim', 'Rownam')
(5, 'Butters', 'Gerald', 'Darren', 'Smith')
(22, 'Coplin', 'Joan', 'Timothy', 'Baker')
(36, 'Crumpet', 'Erica', 'Tracy', 'Smith')
(7, 'Dare', 'Nancy', 'Janice', 'Joplette')
(28, 'Farrell', 'David', None, None)
(13, 'Farrell', 'Jemima', None, None)
(20, 'Genting', 'Matthew', 'Gerald', 'Butters')
(35, 'Hunt', 'John', 'Millicent', 'Purview')
(11, 'Jones', 'David', 'Janice', 'Joplette')
(26, 'Jones', 'Douglas', 'David', 'Jones')
(4, 'Joplette', 'Janice', 'Darren', 'Smith')
(21, 'Mackenzie', 'Anna', 'Darren', 'Smith')
(10, 'Owen', 'Charles', 'Darren', 'Smith')
(17, 'Pinker', 'David', 'Jemima', 'Farrell')
(30, 'Purview', 'Millicent', 'Tracy', 'Smith')
(3, 'Rownam', 'Tim', None, None)
(27, 'Rumney', 'Henrietta', 'Matthew', 'Genting')
(24, 'Sarwin', 'Ramnaresh', 'Florence', 'Bader')
(1, 'Smith', 'Darren', None, None)
(37, 'Smith', 'Darren', None, None)
(14, 'Smith', 'Jack', 'Darren', 'Smith')
(2, 'Smith', 'Tracy', None, None)
(9, 'Stibbons', 'Ponder', 'Burton', 'Tracy')
(6, 'Tracy', 'Burton', None, None)
(33, 'Tupperware', 'Hyacinth', None, None)
(29, 'Worthington-Smyth', 'Henry', 'Tracy', 'Smith')

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

SELECT
f.name as fname,
bookid,
MONTH(starttime) as month
FROM `Bookings`
LEFT JOIN `Facilities` as f
USING (facid)
LEFT JOIN `Members` as m
USING (memid)
group by fname, month
order by fname, month;

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
