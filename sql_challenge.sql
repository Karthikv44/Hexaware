-- 1.Provide a SQL script that initializes the database for the Job Board scenario “CareerHub”.

CREATE DATABASE careerhub;

-- 2.	Create tables for Companies, Jobs, Applicants and Applications.
-- 3.	Define appropriate primary keys, foreign keys, and constraints.
-- 4.	Ensure the script handles potential errors, such as if the database or tables already exist.

CREATE TABLE companies (
	 companyid INT PRIMARY KEY,
     companyname VARCHAR(255),
     location VARCHAR(255)
	 );

CREATE TABLE jobs (
    jobid INT PRIMARY KEY,
    companyid INT,
    jobtitle VARCHAR(255),
    jobdescription TEXT,
    joblocation VARCHAR(255),
    salary DECIMAL(10, 2),
    jobtype VARCHAR(50),
    posteddate DATE,
    FOREIGN KEY (companyID) REFERENCES companies(companyID)
);

CREATE TABLE applicants (
    applicantid INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20),
	state VARCHAR(50),
	city VARCHAR(50),
    resume TEXT
);

CREATE TABLE applications (
    applicationid INT PRIMARY KEY,
    jobid INT,
    applicantid INT,
    applicationdate DATE,
    coverletter TEXT,
    FOREIGN KEY (jobid) REFERENCES jobs(jobid),
    FOREIGN KEY (applicantid) REFERENCES applicants(applicantid)
);

INSERT INTO Companies (CompanyID, CompanyName, Location) VALUES
(1,'Tech Innovations', 'San Francisco'),
(2,'Data Driven Inc', 'New York'),
(3,'GreenTech Solutions', 'Austin'),
(4,'CodeCrafters', 'Boston'),
(5,'HexaWare Technologies', 'Chennai');


INSERT INTO Jobs (jobid, CompanyID, JobTitle, JobDescription, JobLocation, Salary, JobType, PostedDate) VALUES
(1,1, 'Frontend Developer', 'Develop user-facing features', 'San Francisco', 75000, 'Full-time', '2023-01-10'),
(2,2, 'Data Analyst', 'Interpret data models', 'New York', 68000, 'Full-time', '2023-02-20'),
(3,3, 'Environmental Engineer', 'Develop environmental solutions', 'Austin', 85000, 'Full-time', '2023-03-15'),
(4,1, 'Backend Developer', 'Handle server-side logic', 'Remote', 77000, 'Full-time', '2023-04-05'),
(5,4, 'Software Engineer', 'Develop and test software systems', 'Boston', 90000, 'Full-time', '2023-01-18'),
(6,5, 'HR Coordinator', 'Manage hiring processes', 'Chennai', 45000, 'Contract', '2023-04-25'),
(7,2, 'Senior Data Analyst', 'Lead data strategies', 'New York', 95000, 'Full-time', '2023-01-22');


INSERT INTO Applicants (applicantid, FirstName, LastName, Email, Phone,state, city, Resume) VALUES
(1,'John', 'Doe','john.doe@example.com','123-456-7890', 'Tamilnadu','chennai', 'Experienced web developer with 5 years of experience.'),
(2,'Jane', 'Smith','jane.smith@example.com', '234-567-8901','Andhrapradesh','hyderabad', 'Data enthusiast with 3 years of experience in data analysis.'),
(3,'Alice', 'Johnson', 'alice.johnson@example.com', '345-678-9012','Tamilnadu','chennai', 'Environmental engineer with 4 years of field experience.'),
(4,'Bob', 'Brown', 'bob.brown@example.com', '456-789-0123','Maharashtra','mumbai', 'Seasoned software engineer with 8 years of experience.');


INSERT INTO Applications (applicationid ,jobid, ApplicantID, ApplicationDate, CoverLetter) VALUES
(1, 1, 1, '2023-04-01', 'I am excited to apply for the Frontend Developer position.'),
(2, 2, 2, '2023-04-02', 'I am interested in the Data Analyst position.'),
(3, 3, 3, '2023-04-03', 'I am eager to bring my expertise to your team as an Environmental Engineer.'),
(4, 4, 4, '2023-04-04', 'I am applying for the Backend Developer role to leverage my skills.'),
(5, 5, 1, '2023-04-05', 'I am also interested in the Software Engineer position at CodeCrafters.');


-- 5.Write an SQL query to count the number of applications received for each job listing in the "Jobs" table. Display the job title and the corresponding application count. Ensure that it lists all jobs, even if they have no applications.


select j.jobtitle, count(a.jobid) as [application count] from jobs j
left join applications a on j.jobid = a.jobid
group by jobtitle

-- 6.Develop an SQL query that retrieves job listings from the "Jobs" table within a specified salary range. Allow parameters for the minimum and maximum salary values. Display the job title, company name, location, and salary for each matching job.

select  jobtitle, c.CompanyName, location,  salary from jobs j
join companies c on j.companyid = c.companyid
where salary between 60000 and 90000

--  7.Write an SQL query that retrieves the job application history for a specific applicant. 
--Allow a parameter for the ApplicantID, and return a result set with the job titles, company names, and application dates for all the jobs the applicant has applied to.

select j.jobtitle, c.companyname, applicationdate from applications a
join jobs j on a.jobid = j.jobid
join companies c on j.companyid = c.companyid 
where applicantid = 1

-- 8.	Create an SQL query that calculates and displays the average salary offered by all companies for job listings in the "Jobs" table. 
-- Ensure that the query filters out jobs with a salary of zero.

select companyname, avg(salary) as[Average Salary] from jobs j
join companies c on j.companyid = c.companyid
where salary > 0
group by companyname

-- 9.	Write an SQL query to identify the company that has posted the most job listings. Display the company name along with the count of job listings they have posted.
-- Handle ties if multiple companies have the same maximum count.

select c.companyname, count(j.companyid) as [Job Listings] from jobs j
join companies c on j.companyid = c.companyid
group by j.companyid, c.companyname
order by [Job Listings] desc
offset 0 rows
fetch next 1 rows only

-- 10.	Find the applicants who have applied for positions in companies located in 'CityX' and have at least 3 years of experience.

update applicants
set city = 'CityX'
where applicantid = 2

select * from applicants
where city = 'CityX'
and resume like '%3%' or resume like '%4%' or resume like '%5%'

-- 11.Retrieve a list of distinct job titles with salaries between $60,000 and $80,000.

select  distinct(jobtitle) from jobs
where salary between 60000 and 80000

-- 12.Find the jobs that have not received any applications.

select * from jobs
where jobid not in (select jobid from applications)

-- 13.Retrieve a list of job applicants along with the companies they have applied to and the positions they have applied for.

select a.firstname,a.lastname,c.companyname,j.jobtitle from applicants a
join applications b on a.applicantid = b.applicantid
join jobs j on b.jobid = j.jobid
join companies c on j.companyid = c.companyid


-- 14.Retrieve a list of companies along with the count of jobs they have posted, even if they have not received any applications.

select a.companyname, count(j.companyid) as [job count] from companies a
left join jobs j on j.companyid = a.companyid
group by companyname

-- 15.List all applicants along with the companies and positions they have applied for, including those who have not applied.


select a.firstname,a.lastname,c.companyname,j.jobtitle from applicants a
left join applications b on a.applicantid = b.applicantid
join jobs j on b.jobid = j.jobid
join companies c on j.companyid = c.companyid

-- 16.Find companies that have posted jobs with a salary higher than the average salary of all jobs.

select * from companies c
join jobs j on c.companyid = j.companyid
where salary > (select avg(salary) from jobs)

-- 17.Display a list of applicants with their names and a concatenated string of their city and state

select firstname, lastname, CONCAT(city,',',state) from applicants

-- 18.	Retrieve a list of jobs with titles containing either 'Developer' or 'Engineer'.

select * from jobs 
where jobtitle like '%Developer%' or jobtitle like '%Engineer%' 

-- 19.Retrieve a list of applicants and the jobs they have applied for, including those who have not applied and jobs without applicants.

select a.firstname,a.lastname,j.jobtitle from applicants a
left join applications b on a.applicantid = b.applicantid
left join jobs j on b.jobid = j.jobid




select * from jobs
select * from applications
select * from applicants
select * from companies

-- 20.List all combinations of applicants and companies where the company is in a specific city and the applicant has more than 2 years of experience. For example: city=Chennai

select a.applicantid, a.firstName, a.lastName, c.companyid, c.companyname from applicants a
cross join companies c
where c.location = 'Chennai' and (resume like '%2%' or resume like '%3%' or resume like '%4%' or resume like '%5%')