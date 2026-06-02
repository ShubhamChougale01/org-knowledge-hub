// Rule: MERGE only on the unique key (employee_id). SET all other properties.
// This avoids Neo4j refusing to MERGE on null property values.

// CEO
MERGE (e:Employee {employee_id: 'EMP-CEO-001'})
SET e.full_name = 'Rajesh Sharma', e.email = 'rajesh.sharma@coditas.com', e.phone = '+91-9876543210', e.dob = date('1968-03-15'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2010-01-15'), e.total_experience_years = 25.0, e.org_experience_years = 15.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== TECH DEPARTMENT (60 employees) ====================
// CTO
MERGE (e:Employee {employee_id: 'EMP-TECH-001'})
SET e.full_name = 'Arvind Patel', e.email = 'arvind.patel@coditas.com', e.phone = '+91-8765432100', e.dob = date('1970-05-22'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2012-06-01'), e.total_experience_years = 23.0, e.org_experience_years = 13.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Tech Heads (2)
MERGE (e:Employee {employee_id: 'EMP-TECH-002'})
SET e.full_name = 'Priya Verma', e.email = 'priya.verma@coditas.com', e.phone = '+91-8765432101', e.dob = date('1975-07-10'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2014-08-15'), e.total_experience_years = 20.0, e.org_experience_years = 11.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-003'})
SET e.full_name = 'Vikram Singh', e.email = 'vikram.singh@coditas.com', e.phone = '+91-8765432102', e.dob = date('1976-09-18'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2013-07-20'), e.total_experience_years = 21.0, e.org_experience_years = 12.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Product Managers (6)
MERGE (e:Employee {employee_id: 'EMP-TECH-004'})
SET e.full_name = 'Ananya Gupta', e.email = 'ananya.gupta@coditas.com', e.phone = '+91-8765432103', e.dob = date('1985-02-14'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2016-03-10'), e.total_experience_years = 15.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-005'})
SET e.full_name = 'Ashok Desai', e.email = 'ashok.desai@coditas.com', e.phone = '+91-8765432104', e.dob = date('1982-11-05'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2017-01-15'), e.total_experience_years = 16.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-006'})
SET e.full_name = 'Kavya Reddy', e.email = 'kavya.reddy@coditas.com', e.phone = '+91-8765432105', e.dob = date('1987-06-28'), e.gender = 'Female', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2015-09-20'), e.total_experience_years = 14.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-007'})
SET e.full_name = 'Rohit Nair', e.email = 'rohit.nair@coditas.com', e.phone = '+91-8765432106', e.dob = date('1984-08-12'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2016-05-01'), e.total_experience_years = 15.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-008'})
SET e.full_name = 'Shreya Singh', e.email = 'shreya.singh@coditas.com', e.phone = '+91-8765432107', e.dob = date('1988-01-22'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-02-10'), e.total_experience_years = 13.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-009'})
SET e.full_name = 'Nikhil Joshi', e.email = 'nikhil.joshi@coditas.com', e.phone = '+91-8765432108', e.dob = date('1986-04-30'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2015-11-15'), e.total_experience_years = 14.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Senior Engineers (15) — EMP-TECH-010 is Shubham Chougale (the specific employee from spec)
MERGE (e:Employee {employee_id: 'EMP-TECH-010'})
SET e.full_name = 'Shubham Chougale', e.email = 'shubham.morya@coditas.com', e.phone = '+91-9876543211', e.dob = date('1997-06-15'), e.gender = 'Male', e.address = 'Pune, Maharashtra', e.employment_type = 'Full-time', e.joining_date = date('2024-12-31'), e.total_experience_years = 4.5, e.org_experience_years = 1.5, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-011'})
SET e.full_name = 'Mohan Rao', e.email = 'mohan.rao@coditas.com', e.phone = '+91-8765432109', e.dob = date('1985-12-08'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2014-06-20'), e.total_experience_years = 14.0, e.org_experience_years = 11.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-012'})
SET e.full_name = 'Divya Iyer', e.email = 'divya.iyer@coditas.com', e.phone = '+91-8765432110', e.dob = date('1986-03-17'), e.gender = 'Female', e.address = 'Chennai, India', e.employment_type = 'Full-time', e.joining_date = date('2015-04-10'), e.total_experience_years = 13.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-013'})
SET e.full_name = 'Sanjay Chopra', e.email = 'sanjay.chopra@coditas.com', e.phone = '+91-8765432111', e.dob = date('1987-09-25'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2016-01-15'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-014'})
SET e.full_name = 'Anjali Mishra', e.email = 'anjali.mishra@coditas.com', e.phone = '+91-8765432112', e.dob = date('1988-05-10'), e.gender = 'Female', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2016-08-01'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-015'})
SET e.full_name = 'Aditya Sinha', e.email = 'aditya.sinha@coditas.com', e.phone = '+91-8765432113', e.dob = date('1989-02-28'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2017-03-15'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-016'})
SET e.full_name = 'Renu Pandey', e.email = 'renu.pandey@coditas.com', e.phone = '+91-8765432114', e.dob = date('1990-07-12'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2017-05-20'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-017'})
SET e.full_name = 'Mahesh Trivedi', e.email = 'mahesh.trivedi@coditas.com', e.phone = '+91-8765432115', e.dob = date('1986-11-15'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2015-09-01'), e.total_experience_years = 13.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-018'})
SET e.full_name = 'Swati Saxena', e.email = 'swati.saxena@coditas.com', e.phone = '+91-8765432116', e.dob = date('1991-04-08'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-01-10'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-019'})
SET e.full_name = 'Rajesh Bhat', e.email = 'rajesh.bhat@coditas.com', e.phone = '+91-8765432117', e.dob = date('1987-08-20'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2016-04-15'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-020'})
SET e.full_name = 'Meera Banerjee', e.email = 'meera.banerjee@coditas.com', e.phone = '+91-8765432118', e.dob = date('1992-01-30'), e.gender = 'Female', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2018-06-01'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-021'})
SET e.full_name = 'Vikram Menon', e.email = 'vikram.menon@coditas.com', e.phone = '+91-8765432119', e.dob = date('1988-06-25'), e.gender = 'Male', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-02-20'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-022'})
SET e.full_name = 'Neha Kapoor', e.email = 'neha.kapoor@coditas.com', e.phone = '+91-8765432120', e.dob = date('1990-10-12'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-11-01'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-023'})
SET e.full_name = 'Abhishek Kumar', e.email = 'abhishek.kumar@coditas.com', e.phone = '+91-8765432121', e.dob = date('1989-03-18'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2016-07-15'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-024'})
SET e.full_name = 'Pooja Verma', e.email = 'pooja.verma@coditas.com', e.phone = '+91-8765432122', e.dob = date('1991-08-05'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-02-10'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Engineers (20)
MERGE (e:Employee {employee_id: 'EMP-TECH-025'})
SET e.full_name = 'Rahul Singh', e.email = 'rahul.singh@coditas.com', e.phone = '+91-8765432123', e.dob = date('1992-05-15'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-08-01'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-026'})
SET e.full_name = 'Deepika Nair', e.email = 'deepika.nair@coditas.com', e.phone = '+91-8765432124', e.dob = date('1993-09-10'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2019-01-15'), e.total_experience_years = 7.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-027'})
SET e.full_name = 'Sameer Patel', e.email = 'sameer.patel@coditas.com', e.phone = '+91-8765432125', e.dob = date('1991-02-22'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2018-04-10'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-028'})
SET e.full_name = 'Isha Sharma', e.email = 'isha.sharma@coditas.com', e.phone = '+91-8765432126', e.dob = date('1992-12-08'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2019-03-01'), e.total_experience_years = 6.5, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-029'})
SET e.full_name = 'Varun Rao', e.email = 'varun.rao@coditas.com', e.phone = '+91-8765432127', e.dob = date('1990-07-30'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2018-05-20'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-030'})
SET e.full_name = 'Sneha Gupta', e.email = 'sneha.gupta.tech@coditas.com', e.phone = '+91-8765432128', e.dob = date('1993-03-14'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2019-06-15'), e.total_experience_years = 6.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-031'})
SET e.full_name = 'Arjun Desai', e.email = 'arjun.desai@coditas.com', e.phone = '+91-8765432129', e.dob = date('1991-11-05'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2018-09-01'), e.total_experience_years = 7.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-032'})
SET e.full_name = 'Tina Singh', e.email = 'tina.singh@coditas.com', e.phone = '+91-8765432130', e.dob = date('1994-04-20'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2019-07-10'), e.total_experience_years = 6.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-033'})
SET e.full_name = 'Praveen Kumar', e.email = 'praveen.kumar@coditas.com', e.phone = '+91-8765432131', e.dob = date('1992-01-28'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-10-15'), e.total_experience_years = 7.5, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-034'})
SET e.full_name = 'Rupali Reddy', e.email = 'rupali.reddy@coditas.com', e.phone = '+91-8765432132', e.dob = date('1993-06-12'), e.gender = 'Female', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2019-02-01'), e.total_experience_years = 6.5, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-035'})
SET e.full_name = 'Manoj Verma', e.email = 'manoj.verma@coditas.com', e.phone = '+91-8765432133', e.dob = date('1990-08-18'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-06-01'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-036'})
SET e.full_name = 'Riya Joshi', e.email = 'riya.joshi@coditas.com', e.phone = '+91-8765432134', e.dob = date('1994-02-25'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2019-08-20'), e.total_experience_years = 5.5, e.org_experience_years = 5.5, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-037'})
SET e.full_name = 'Suresh Nair', e.email = 'suresh.nair@coditas.com', e.phone = '+91-8765432135', e.dob = date('1991-09-30'), e.gender = 'Male', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-11-10'), e.total_experience_years = 7.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-038'})
SET e.full_name = 'Pooja Singh', e.email = 'pooja.singh@coditas.com', e.phone = '+91-8765432136', e.dob = date('1993-05-15'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2019-04-01'), e.total_experience_years = 6.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-039'})
SET e.full_name = 'Nikhil Gupta', e.email = 'nikhil.gupta@coditas.com', e.phone = '+91-8765432137', e.dob = date('1992-10-08'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-12-01'), e.total_experience_years = 7.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-040'})
SET e.full_name = 'Anjali Chopra', e.email = 'anjali.chopra@coditas.com', e.phone = '+91-8765432138', e.dob = date('1994-07-22'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2019-09-15'), e.total_experience_years = 5.0, e.org_experience_years = 5.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-041'})
SET e.full_name = 'Sandeep Reddy', e.email = 'sandeep.reddy@coditas.com', e.phone = '+91-8765432139', e.dob = date('1991-03-12'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2018-07-20'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-042'})
SET e.full_name = 'Kavya Singh', e.email = 'kavya.singh@coditas.com', e.phone = '+91-8765432140', e.dob = date('1993-11-28'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2019-05-10'), e.total_experience_years = 6.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-043'})
SET e.full_name = 'Rohan Sharma', e.email = 'rohan.sharma@coditas.com', e.phone = '+91-8765432141', e.dob = date('1990-06-05'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-02-01'), e.total_experience_years = 8.5, e.org_experience_years = 7.5, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-044'})
SET e.full_name = 'Shriya Iyer', e.email = 'shriya.iyer@coditas.com', e.phone = '+91-8765432142', e.dob = date('1994-09-18'), e.gender = 'Female', e.address = 'Chennai, India', e.employment_type = 'Full-time', e.joining_date = date('2019-10-01'), e.total_experience_years = 5.0, e.org_experience_years = 5.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Associate Engineers (16)
MERGE (e:Employee {employee_id: 'EMP-TECH-045'})
SET e.full_name = 'Akshay Patel', e.email = 'akshay.patel@coditas.com', e.phone = '+91-8765432143', e.dob = date('1995-01-15'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-046'})
SET e.full_name = 'Manisha Verma', e.email = 'manisha.verma@coditas.com', e.phone = '+91-8765432144', e.dob = date('1996-03-22'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-047'})
SET e.full_name = 'Saurab Nair', e.email = 'saurab.nair@coditas.com', e.phone = '+91-8765432145', e.dob = date('1995-08-10'), e.gender = 'Male', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-048'})
SET e.full_name = 'Varsha Singh', e.email = 'varsha.singh@coditas.com', e.phone = '+91-8765432146', e.dob = date('1996-05-18'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-09-10'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-049'})
SET e.full_name = 'Harshit Gupta', e.email = 'harshit.gupta@coditas.com', e.phone = '+91-8765432147', e.dob = date('1995-11-25'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2020-10-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-050'})
SET e.full_name = 'Nikita Desai', e.email = 'nikita.desai@coditas.com', e.phone = '+91-8765432148', e.dob = date('1996-02-12'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-051'})
SET e.full_name = 'Viraj Reddy', e.email = 'viraj.reddy@coditas.com', e.phone = '+91-8765432149', e.dob = date('1995-07-30'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-20'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-052'})
SET e.full_name = 'Priyanka Sharma', e.email = 'priyanka.sharma@coditas.com', e.phone = '+91-8765432150', e.dob = date('1996-04-08'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-10'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-053'})
SET e.full_name = 'Yash Trivedi', e.email = 'yash.trivedi@coditas.com', e.phone = '+91-8765432151', e.dob = date('1995-09-16'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2020-09-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-054'})
SET e.full_name = 'Disha Kapoor', e.email = 'disha.kapoor@coditas.com', e.phone = '+91-8765432152', e.dob = date('1996-06-22'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-10-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-055'})
SET e.full_name = 'Chirag Saxena', e.email = 'chirag.saxena@coditas.com', e.phone = '+91-8765432153', e.dob = date('1995-12-10'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-20'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-056'})
SET e.full_name = 'Swara Bhat', e.email = 'swara.bhat@coditas.com', e.phone = '+91-8765432154', e.dob = date('1996-08-05'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-25'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-057'})
SET e.full_name = 'Ashish Patel', e.email = 'ashish.patel@coditas.com', e.phone = '+91-8765432155', e.dob = date('1995-03-20'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-058'})
SET e.full_name = 'Neha Sharma', e.email = 'neha.sharma@coditas.com', e.phone = '+91-8765432156', e.dob = date('1996-10-14'), e.gender = 'Female', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2020-09-20'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-059'})
SET e.full_name = 'Karan Singh', e.email = 'karan.singh@coditas.com', e.phone = '+91-8765432157', e.dob = date('1995-05-28'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-10-05'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-TECH-060'})
SET e.full_name = 'Surbhi Reddy', e.email = 'surbhi.reddy@coditas.com', e.phone = '+91-8765432158', e.dob = date('1996-01-02'), e.gender = 'Female', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-10'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== DELIVERY DEPARTMENT (35 employees) ====================
// Delivery Heads (2)
MERGE (e:Employee {employee_id: 'EMP-DEL-001'})
SET e.full_name = 'Satish Rao', e.email = 'satish.rao@coditas.com', e.phone = '+91-8765432159', e.dob = date('1972-04-18'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2013-09-01'), e.total_experience_years = 22.0, e.org_experience_years = 12.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-002'})
SET e.full_name = 'Meena Yadav', e.email = 'meena.yadav@coditas.com', e.phone = '+91-8765432160', e.dob = date('1976-08-25'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2014-10-15'), e.total_experience_years = 20.0, e.org_experience_years = 11.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Project Managers (5)
MERGE (e:Employee {employee_id: 'EMP-DEL-003'})
SET e.full_name = 'Vikram Mittal', e.email = 'vikram.mittal@coditas.com', e.phone = '+91-8765432161', e.dob = date('1983-06-12'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2015-11-20'), e.total_experience_years = 16.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-004'})
SET e.full_name = 'Anjaly Mohta', e.email = 'anjaly.mohta@coditas.com', e.phone = '+91-8765432162', e.dob = date('1985-02-08'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2016-03-10'), e.total_experience_years = 15.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-005'})
SET e.full_name = 'Rajesh Kumaran', e.email = 'rajesh.kumaran@coditas.com', e.phone = '+91-8765432163', e.dob = date('1984-09-30'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2016-05-01'), e.total_experience_years = 15.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-006'})
SET e.full_name = 'Priya Nambiar', e.email = 'priya.nambiar@coditas.com', e.phone = '+91-8765432164', e.dob = date('1986-01-14'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-04-15'), e.total_experience_years = 13.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-007'})
SET e.full_name = 'Anil Chakraborty', e.email = 'anil.chakraborty@coditas.com', e.phone = '+91-8765432165', e.dob = date('1982-11-22'), e.gender = 'Male', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2015-12-10'), e.total_experience_years = 16.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Senior Analysts (10)
MERGE (e:Employee {employee_id: 'EMP-DEL-008'})
SET e.full_name = 'Shreya Dutta', e.email = 'shreya.dutta@coditas.com', e.phone = '+91-8765432166', e.dob = date('1988-07-16'), e.gender = 'Female', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2016-08-20'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-009'})
SET e.full_name = 'Ravi Shankar', e.email = 'ravi.shankar@coditas.com', e.phone = '+91-8765432167', e.dob = date('1987-03-10'), e.gender = 'Male', e.address = 'Chennai, India', e.employment_type = 'Full-time', e.joining_date = date('2017-01-15'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-010'})
SET e.full_name = 'Divya Menon', e.email = 'divya.menon@coditas.com', e.phone = '+91-8765432168', e.dob = date('1989-05-22'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-06-10'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-011'})
SET e.full_name = 'Arun Gupta', e.email = 'arun.gupta@coditas.com', e.phone = '+91-8765432169', e.dob = date('1986-09-08'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2016-07-01'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-012'})
SET e.full_name = 'Padma Joshi', e.email = 'padma.joshi@coditas.com', e.phone = '+91-8765432170', e.dob = date('1990-02-14'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-03-01'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-013'})
SET e.full_name = 'Ganesh Iyer', e.email = 'ganesh.iyer@coditas.com', e.phone = '+91-8765432171', e.dob = date('1987-11-30'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2017-02-20'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-014'})
SET e.full_name = 'Sunita Verma', e.email = 'sunita.verma@coditas.com', e.phone = '+91-8765432172', e.dob = date('1989-08-12'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-04-15'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-015'})
SET e.full_name = 'Srinivas Rao', e.email = 'srinivas.rao@coditas.com', e.phone = '+91-8765432173', e.dob = date('1986-04-25'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2016-09-01'), e.total_experience_years = 12.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-016'})
SET e.full_name = 'Geetha Kumari', e.email = 'geetha.kumari@coditas.com', e.phone = '+91-8765432174', e.dob = date('1990-06-18'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-05-10'), e.total_experience_years = 8.5, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-017'})
SET e.full_name = 'Ramesh Patel', e.email = 'ramesh.patel@coditas.com', e.phone = '+91-8765432175', e.dob = date('1988-10-05'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2017-08-15'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Analysts (12)
MERGE (e:Employee {employee_id: 'EMP-DEL-018'})
SET e.full_name = 'Savita Das', e.email = 'savita.das@coditas.com', e.phone = '+91-8765432176', e.dob = date('1991-03-20'), e.gender = 'Female', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2018-09-01'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-019'})
SET e.full_name = 'Arjun Prabhu', e.email = 'arjun.prabhu@coditas.com', e.phone = '+91-8765432177', e.dob = date('1992-01-14'), e.gender = 'Male', e.address = 'Chennai, India', e.employment_type = 'Full-time', e.joining_date = date('2019-01-15'), e.total_experience_years = 7.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-020'})
SET e.full_name = 'Lakshmi Desai', e.email = 'lakshmi.desai@coditas.com', e.phone = '+91-8765432178', e.dob = date('1990-08-28'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2018-10-10'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-021'})
SET e.full_name = 'Vikrant Yadav', e.email = 'vikrant.yadav@coditas.com', e.phone = '+91-8765432179', e.dob = date('1991-06-12'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2019-02-01'), e.total_experience_years = 7.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-022'})
SET e.full_name = 'Nirmala Bhat', e.email = 'nirmala.bhat@coditas.com', e.phone = '+91-8765432180', e.dob = date('1989-11-05'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-11-20'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-023'})
SET e.full_name = 'Sohan Kumar', e.email = 'sohan.kumar@coditas.com', e.phone = '+91-8765432181', e.dob = date('1990-02-16'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2019-03-15'), e.total_experience_years = 7.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-024'})
SET e.full_name = 'Tejaswi Nair', e.email = 'tejaswi.nair@coditas.com', e.phone = '+91-8765432182', e.dob = date('1991-09-22'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2019-04-01'), e.total_experience_years = 6.5, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-025'})
SET e.full_name = 'Rajiv Singhal', e.email = 'rajiv.singhal@coditas.com', e.phone = '+91-8765432183', e.dob = date('1989-05-08'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-12-10'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-026'})
SET e.full_name = 'Shreya Kapoor', e.email = 'shreya.kapoor@coditas.com', e.phone = '+91-8765432184', e.dob = date('1992-04-10'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2019-05-20'), e.total_experience_years = 6.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-027'})
SET e.full_name = 'Harish Verma', e.email = 'harish.verma@coditas.com', e.phone = '+91-8765432185', e.dob = date('1990-07-30'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2019-01-10'), e.total_experience_years = 7.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-028'})
SET e.full_name = 'Aparna Roy', e.email = 'aparna.roy@coditas.com', e.phone = '+91-8765432186', e.dob = date('1991-12-18'), e.gender = 'Female', e.address = 'Kolkata, India', e.employment_type = 'Full-time', e.joining_date = date('2019-06-01'), e.total_experience_years = 6.0, e.org_experience_years = 6.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-029'})
SET e.full_name = 'Naveen Gupta', e.email = 'naveen.gupta@coditas.com', e.phone = '+91-8765432187', e.dob = date('1989-03-25'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-08-15'), e.total_experience_years = 8.5, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// Associates (6)
MERGE (e:Employee {employee_id: 'EMP-DEL-030'})
SET e.full_name = 'Pooja Mishra', e.email = 'pooja.mishra@coditas.com', e.phone = '+91-8765432188', e.dob = date('1993-02-10'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-031'})
SET e.full_name = 'Siddharth Sharma', e.email = 'siddharth.sharma@coditas.com', e.phone = '+91-8765432189', e.dob = date('1994-05-15'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-10'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-032'})
SET e.full_name = 'Madhavi Singh', e.email = 'madhavi.singh@coditas.com', e.phone = '+91-8765432190', e.dob = date('1993-08-22'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-033'})
SET e.full_name = 'Abhishek Nair', e.email = 'abhishek.nair@coditas.com', e.phone = '+91-8765432191', e.dob = date('1994-01-08'), e.gender = 'Male', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-09-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-034'})
SET e.full_name = 'Ritika Rao', e.email = 'ritika.rao@coditas.com', e.phone = '+91-8765432192', e.dob = date('1993-11-30'), e.gender = 'Female', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-20'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-DEL-035'})
SET e.full_name = 'Vinay Soni', e.email = 'vinay.soni@coditas.com', e.phone = '+91-8765432193', e.dob = date('1994-03-12'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2020-10-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== SALES DEPARTMENT (20 employees) ====================
MERGE (e:Employee {employee_id: 'EMP-SAL-001'})
SET e.full_name = 'Karan Bhatnagar', e.email = 'karan.bhatnagar@coditas.com', e.phone = '+91-8765432194', e.dob = date('1975-06-10'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2013-08-15'), e.total_experience_years = 21.0, e.org_experience_years = 12.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-002'})
SET e.full_name = 'Priya Malhotra', e.email = 'priya.malhotra@coditas.com', e.phone = '+91-8765432195', e.dob = date('1983-03-25'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2015-09-10'), e.total_experience_years = 15.0, e.org_experience_years = 10.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-003'})
SET e.full_name = 'Rajesh Mittal', e.email = 'rajesh.mittal@coditas.com', e.phone = '+91-8765432196', e.dob = date('1982-11-08'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2016-01-20'), e.total_experience_years = 16.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-004'})
SET e.full_name = 'Anita Sharma', e.email = 'anita.sharma@coditas.com', e.phone = '+91-8765432197', e.dob = date('1984-05-12'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2016-04-15'), e.total_experience_years = 14.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-005'})
SET e.full_name = 'Aditya Agrawal', e.email = 'aditya.agrawal@coditas.com', e.phone = '+91-8765432198', e.dob = date('1983-09-20'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-02-01'), e.total_experience_years = 13.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-006'})
SET e.full_name = 'Sneha Kulkarni', e.email = 'sneha.kulkarni@coditas.com', e.phone = '+91-8765432199', e.dob = date('1988-02-18'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2017-06-01'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-007'})
SET e.full_name = 'Sunil Rao', e.email = 'sunil.rao@coditas.com', e.phone = '+91-8765432200', e.dob = date('1987-07-22'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2017-08-15'), e.total_experience_years = 10.5, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-008'})
SET e.full_name = 'Nivedita Singh', e.email = 'nivedita.singh@coditas.com', e.phone = '+91-8765432201', e.dob = date('1989-04-10'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-01-20'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-009'})
SET e.full_name = 'Vikas Pandey', e.email = 'vikas.pandey@coditas.com', e.phone = '+91-8765432202', e.dob = date('1986-11-05'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2017-03-10'), e.total_experience_years = 12.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-010'})
SET e.full_name = 'Rashmi Gupta', e.email = 'rashmi.gupta@coditas.com', e.phone = '+91-8765432203', e.dob = date('1990-06-28'), e.gender = 'Female', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2018-05-01'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-011'})
SET e.full_name = 'Prakash Verma', e.email = 'prakash.verma@coditas.com', e.phone = '+91-8765432204', e.dob = date('1987-09-15'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-02-01'), e.total_experience_years = 10.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-012'})
SET e.full_name = 'Vandana Singh', e.email = 'vandana.singh@coditas.com', e.phone = '+91-8765432205', e.dob = date('1989-12-20'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2018-06-15'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-013'})
SET e.full_name = 'Sanjiv Yadav', e.email = 'sanjiv.yadav@coditas.com', e.phone = '+91-8765432206', e.dob = date('1988-03-08'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-11-01'), e.total_experience_years = 10.5, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-014'})
SET e.full_name = 'Shreya Menon', e.email = 'shreya.menon@coditas.com', e.phone = '+91-8765432207', e.dob = date('1990-08-12'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-07-20'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-015'})
SET e.full_name = 'Ramesh Rao', e.email = 'ramesh.rao@coditas.com', e.phone = '+91-8765432208', e.dob = date('1987-02-25'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2017-10-10'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-016'})
SET e.full_name = 'Ankita Verma', e.email = 'ankita.verma@coditas.com', e.phone = '+91-8765432209', e.dob = date('1992-04-18'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-017'})
SET e.full_name = 'Vivek Saxena', e.email = 'vivek.saxena@coditas.com', e.phone = '+91-8765432210', e.dob = date('1993-07-20'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-018'})
SET e.full_name = 'Preeti Nair', e.email = 'preeti.nair@coditas.com', e.phone = '+91-8765432211', e.dob = date('1992-11-05'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-10'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-019'})
SET e.full_name = 'Ashish Joshi', e.email = 'ashish.joshi@coditas.com', e.phone = '+91-8765432212', e.dob = date('1993-05-12'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-09-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-SAL-020'})
SET e.full_name = 'Priya Chopra', e.email = 'priya.chopra@coditas.com', e.phone = '+91-8765432213', e.dob = date('1992-09-25'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2020-10-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== MARKETING DEPARTMENT (15 employees) ====================
MERGE (e:Employee {employee_id: 'EMP-MKT-001'})
SET e.full_name = 'Shreya Patel', e.email = 'shreya.patel@coditas.com', e.phone = '+91-8765432214', e.dob = date('1976-02-20'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2014-03-10'), e.total_experience_years = 19.0, e.org_experience_years = 11.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-002'})
SET e.full_name = 'Arjun Mittal', e.email = 'arjun.mittal@coditas.com', e.phone = '+91-8765432215', e.dob = date('1984-04-15'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2016-05-20'), e.total_experience_years = 14.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-003'})
SET e.full_name = 'Kavya Desai', e.email = 'kavya.desai@coditas.com', e.phone = '+91-8765432216', e.dob = date('1986-07-10'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2017-01-15'), e.total_experience_years = 13.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-004'})
SET e.full_name = 'Nikhil Sharma', e.email = 'nikhil.sharma@coditas.com', e.phone = '+91-8765432217', e.dob = date('1985-10-22'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2016-08-01'), e.total_experience_years = 14.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-005'})
SET e.full_name = 'Divya Singh', e.email = 'divya.singh@coditas.com', e.phone = '+91-8765432218', e.dob = date('1989-01-18'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-06-10'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-006'})
SET e.full_name = 'Sanjay Verma', e.email = 'sanjay.verma@coditas.com', e.phone = '+91-8765432219', e.dob = date('1988-05-30'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-02-01'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-007'})
SET e.full_name = 'Neha Iyer', e.email = 'neha.iyer@coditas.com', e.phone = '+91-8765432220', e.dob = date('1990-03-12'), e.gender = 'Female', e.address = 'Chennai, India', e.employment_type = 'Full-time', e.joining_date = date('2018-04-15'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-008'})
SET e.full_name = 'Rajesh Chopra', e.email = 'rajesh.chopra@coditas.com', e.phone = '+91-8765432221', e.dob = date('1987-08-25'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2017-09-20'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-009'})
SET e.full_name = 'Priya Yadav', e.email = 'priya.yadav@coditas.com', e.phone = '+91-8765432222', e.dob = date('1991-02-14'), e.gender = 'Female', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2018-07-01'), e.total_experience_years = 7.5, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-010'})
SET e.full_name = 'Vikram Rao', e.email = 'vikram.rao@coditas.com', e.phone = '+91-8765432223', e.dob = date('1989-06-20'), e.gender = 'Male', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-05-10'), e.total_experience_years = 8.5, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-011'})
SET e.full_name = 'Sneha Patel', e.email = 'sneha.patel.mkt@coditas.com', e.phone = '+91-8765432224', e.dob = date('1990-09-08'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2018-08-20'), e.total_experience_years = 7.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-012'})
SET e.full_name = 'Arun Singh', e.email = 'arun.singh@coditas.com', e.phone = '+91-8765432225', e.dob = date('1988-11-15'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2017-10-01'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-013'})
SET e.full_name = 'Ritika Sharma', e.email = 'ritika.sharma@coditas.com', e.phone = '+91-8765432226', e.dob = date('1993-03-20'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-10'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-014'})
SET e.full_name = 'Siddharth Patel', e.email = 'siddharth.patel@coditas.com', e.phone = '+91-8765432227', e.dob = date('1994-06-12'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-20'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-MKT-015'})
SET e.full_name = 'Aisha Khan', e.email = 'aisha.khan@coditas.com', e.phone = '+91-8765432228', e.dob = date('1993-08-08'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== HR DEPARTMENT (10 employees) ====================
MERGE (e:Employee {employee_id: 'EMP-HR-001'})
SET e.full_name = 'Sheila Iyer', e.email = 'sheila.iyer@coditas.com', e.phone = '+91-8765432229', e.dob = date('1970-05-15'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2012-07-01'), e.total_experience_years = 23.0, e.org_experience_years = 13.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-002'})
SET e.full_name = 'Vikram Desai', e.email = 'vikram.desai@coditas.com', e.phone = '+91-8765432230', e.dob = date('1978-09-22'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2014-08-20'), e.total_experience_years = 18.0, e.org_experience_years = 11.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-003'})
SET e.full_name = 'Priya Sinha', e.email = 'priya.sinha@coditas.com', e.phone = '+91-8765432231', e.dob = date('1985-03-10'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2016-04-15'), e.total_experience_years = 14.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-004'})
SET e.full_name = 'Ramesh Gupta', e.email = 'ramesh.gupta@coditas.com', e.phone = '+91-8765432232', e.dob = date('1983-11-28'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2016-06-01'), e.total_experience_years = 15.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-005'})
SET e.full_name = 'Sneha Verma', e.email = 'sneha.verma@coditas.com', e.phone = '+91-8765432233', e.dob = date('1988-02-05'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2017-05-20'), e.total_experience_years = 11.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-006'})
SET e.full_name = 'Arun Nair', e.email = 'arun.nair@coditas.com', e.phone = '+91-8765432234', e.dob = date('1987-07-12'), e.gender = 'Male', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2018-01-15'), e.total_experience_years = 10.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-007'})
SET e.full_name = 'Divya Sharma', e.email = 'divya.sharma@coditas.com', e.phone = '+91-8765432235', e.dob = date('1989-06-18'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2018-03-10'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-008'})
SET e.full_name = 'Sanjiv Rao', e.email = 'sanjiv.rao@coditas.com', e.phone = '+91-8765432236', e.dob = date('1988-04-25'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2017-09-01'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-009'})
SET e.full_name = 'Pooja Nair', e.email = 'pooja.nair@coditas.com', e.phone = '+91-8765432237', e.dob = date('1992-05-20'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-HR-010'})
SET e.full_name = 'Rajesh Singh', e.email = 'rajesh.singh@coditas.com', e.phone = '+91-8765432238', e.dob = date('1993-08-10'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== FINANCE DEPARTMENT (12 employees) ====================
MERGE (e:Employee {employee_id: 'EMP-FIN-001'})
SET e.full_name = 'Sudhir Verma', e.email = 'sudhir.verma@coditas.com', e.phone = '+91-8765432239', e.dob = date('1968-10-05'), e.gender = 'Male', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2011-06-01'), e.total_experience_years = 24.0, e.org_experience_years = 14.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-002'})
SET e.full_name = 'Anjali Saxena', e.email = 'anjali.saxena@coditas.com', e.phone = '+91-8765432240', e.dob = date('1980-02-20'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2013-08-15'), e.total_experience_years = 19.0, e.org_experience_years = 12.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-003'})
SET e.full_name = 'Rakesh Kumar', e.email = 'rakesh.kumar@coditas.com', e.phone = '+91-8765432241', e.dob = date('1985-04-12'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2016-01-20'), e.total_experience_years = 14.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-004'})
SET e.full_name = 'Laxmi Desai', e.email = 'laxmi.desai@coditas.com', e.phone = '+91-8765432242', e.dob = date('1984-07-28'), e.gender = 'Female', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2016-03-10'), e.total_experience_years = 15.0, e.org_experience_years = 9.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-005'})
SET e.full_name = 'Priya Menon', e.email = 'priya.menon@coditas.com', e.phone = '+91-8765432243', e.dob = date('1989-01-15'), e.gender = 'Female', e.address = 'Kochi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-06-01'), e.total_experience_years = 10.0, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-006'})
SET e.full_name = 'Sunder Rao', e.email = 'sunder.rao@coditas.com', e.phone = '+91-8765432244', e.dob = date('1988-05-22'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2018-02-15'), e.total_experience_years = 9.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-007'})
SET e.full_name = 'Deepa Sharma', e.email = 'deepa.sharma@coditas.com', e.phone = '+91-8765432245', e.dob = date('1990-03-10'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2018-04-01'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-008'})
SET e.full_name = 'Mohan Singh', e.email = 'mohan.singh@coditas.com', e.phone = '+91-8765432246', e.dob = date('1989-11-08'), e.gender = 'Male', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2017-09-20'), e.total_experience_years = 9.5, e.org_experience_years = 8.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-009'})
SET e.full_name = 'Ritu Gupta', e.email = 'ritu.gupta@coditas.com', e.phone = '+91-8765432247', e.dob = date('1991-02-20'), e.gender = 'Female', e.address = 'Mumbai, India', e.employment_type = 'Full-time', e.joining_date = date('2018-05-10'), e.total_experience_years = 8.0, e.org_experience_years = 7.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-010'})
SET e.full_name = 'Arjun Reddy', e.email = 'arjun.reddy@coditas.com', e.phone = '+91-8765432248', e.dob = date('1993-04-15'), e.gender = 'Male', e.address = 'Hyderabad, India', e.employment_type = 'Full-time', e.joining_date = date('2020-06-20'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-011'})
SET e.full_name = 'Neha Rajpoot', e.email = 'neha.rajpoot@coditas.com', e.phone = '+91-8765432249', e.dob = date('1992-09-22'), e.gender = 'Female', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2020-07-15'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-FIN-012'})
SET e.full_name = 'Vilas Desai', e.email = 'vilas.desai@coditas.com', e.phone = '+91-8765432250', e.dob = date('1993-06-08'), e.gender = 'Male', e.address = 'Pune, India', e.employment_type = 'Full-time', e.joining_date = date('2020-08-01'), e.total_experience_years = 4.0, e.org_experience_years = 4.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();

// ==================== EXECUTIVE DEPARTMENT (2 extra VPs) ====================
MERGE (e:Employee {employee_id: 'EMP-EXE-001'})
SET e.full_name = 'Mohan Pillai', e.email = 'mohan.pillai@coditas.com', e.phone = '+91-8765432251', e.dob = date('1972-01-12'), e.gender = 'Male', e.address = 'Bangalore, India', e.employment_type = 'Full-time', e.joining_date = date('2012-04-01'), e.total_experience_years = 22.0, e.org_experience_years = 13.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
MERGE (e:Employee {employee_id: 'EMP-EXE-002'})
SET e.full_name = 'Anjali Kapoor', e.email = 'anjali.kapoor@coditas.com', e.phone = '+91-8765432252', e.dob = date('1974-08-18'), e.gender = 'Female', e.address = 'Delhi, India', e.employment_type = 'Full-time', e.joining_date = date('2013-09-15'), e.total_experience_years = 21.0, e.org_experience_years = 12.0, e.current_status = 'Active', e.profile_photo_url = null, e.created_at = datetime();
