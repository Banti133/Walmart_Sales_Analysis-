-- ------ creation of a databse if not exists ------- --
create database if not exists walmart_sales;
-- ------ selecting all the sales from table ------- --
select * from walmart_sales.w_sales;

						-- -------------------- FEATURE ENGINEERING ------------------------ --


-- ------ insights of sales in Morning, Afternoon and Evening ------- --
select time,(
	case when `time` between "00:00:00" and "12:00:00" then "Morning"
		 when `time` between "12:01:00" and "17:00:00" then "Afternoon"
         else "Evening"
	end
) as time_of_day from w_sales;

alter table w_sales add column time_of_day varchar(20);
-- ------ updated insights of sales in Morning, Afternoon and Evening into the table ------- --
update w_sales set time_of_day =(case when `time` between "00:00:00" and "12:00:00" then "Morning"
									  when `time` between "12:01:00" and "17:00:00" then "Afternoon"
                                      else "Evening"
end);
-- -----extract the days of the week------- ----
select date,dayname(date) from w_sales;

alter table w_sales add column day_name VARCHAR(10);
-- ------ updated insights of extracted days of the week into the table ------- --
update w_sales set day_name = dayname(date);

-- -----extract the months of the year------- ----
select date,monthname(date) from w_sales;

alter table w_sales add column month_name VARCHAR(10);
-- ------ updated insights of months of the year into the table ------- --
update w_sales set month_name = monthname(date);

-- ------------------------------EXPLORATORY DATA ANALYSIS------------------------ -----



                                              -- ------------Generic-------------- ---

-- --------How many unique cities does the data have?------ --
select distinct city from w_sales;
-- -------In which city is each branch?-------- --
select distinct city,branch from w_sales;

                                                -- ----------Product--------- ---

-- -----How many unique product lines does the data have?----- --
select count(distinct product_line) from w_sales;
-- ---------What is the most common payment method?------- --
select payment,count(payment) as cnt  from w_sales group by payment order by cnt desc;
-- ---------What is the most selling product line?------- --
select product_line,sum(quantity) as qty from w_sales group by product_line order by qty desc;
-- ---------What is the total revenue by month?------- --
select month_name as month, sum(total) as total_revenue from w_sales group by month_name order by total_revenue desc;
-- ---------What month had the largest COGS?------- --
select month_name as month,sum(cogs) as cogs from w_sales group by month_name order by cogs desc;
-- ---------What product line had the largest revenue?------- --
select product_line,sum(total) as total_revenue from w_sales group by product_line order by total_revenue desc;
-- ---------What is the city with the largest revenue?------- --
select branch,city,sum(total) as total_revenue from w_sales group by city,branch order by total_revenue;
-- ---------What product line had the largest VAT?------- --
select product_line,avg(tax_pct) as avg_tax from w_sales group by product_line order by avg_tax desc;
-- ---Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales---- --
      -- ---first check the average value------ --
select avg(quantity) as avg_qty from w_sales;
      -- -----now show column------ --
select product_line,(case when avg(quantity)>5.9 then  "Good"
						  else "Bad"
				end) as remark from w_sales group by product_line;
-- ---------Which branch sold more products than average product sold?------- --
select branch,sum(quantity) as qty from w_sales group by branch having sum(quantity)>(select avg(quantity) from w_sales);
-- ---------What is the most common product line by gender?------- --
select gender,product_line ,count(gender) as total_cnt from w_sales group by gender,product_line order by total_cnt desc;
-- ---------What is the average rating of each product line?------- --
select round(avg(rating),2) as avg_rating,product_line from w_sales group by product_line order by avg_rating desc;


                                     -- -----------------Sales---------------------- --

-- ---------Number of sales made in each time of the day per weekday------- --
select time_of_day ,count(*) as total_sales from w_sales where day_name="Sunday" group by time_of_day order by total_sales desc;
-- ---------Which of the customer types brings the most revenue?------- --
select customer_type,sum(total) as total_revenue from w_sales group by customer_type order by total_revenue desc;
-- ---------Which city has the largest tax percent/ VAT (Value Added Tax)?------- --
select city,round(avg(tax_pct),2) as avg_tax_pct from w_sales group by city order by avg_tax_pct desc;
-- ---------Which customer type pays the most in VAT?------- --
select customer_type ,avg(tax_pct) as total_tax from w_sales group by customer_type order by total_tax desc;


										-- -----------------Customer---------------------- --


-- ---------How many unique customer types does the data have?------- --
select distinct customer_type from w_sales;
-- ---------How many unique payment methods does the data have?------- --
select distinct payment from w_sales;
-- ---------What is the most common customer type?--------- --
select customer_type,count(*) as count from w_sales group by customer_type order by count desc;
-- ---------Which customer type buys the most?------- --
select customer_type ,count(*) from w_sales group by customer_type;
-- ---------What is the gender of most of the customers?------- --
select gender,count(*) as gender_cnt from w_sales group by gender order by gender_cnt desc;
-- ---------What is the gender distribution per branch?------- --
select gender,count(*) as gender_cnt from w_sales where branch="C" group by gender order by gender_cnt desc;
-- ---------Which time of the day do customers give most ratings?------- --
select time_of_day,avg(rating) as avg_rating from w_sales group by time_of_day order by avg_rating desc;
-- ---------Which time of the day do customers give most ratings per branch?------- --
select time_of_day,avg(rating) as avg_rating from w_sales where branch="A" group by time_of_day order by avg_rating desc;
-- ---------Which day of the week has the best avg ratings?------- --
select day_name,avg(rating) as avg_rating from w_sales group by day_name order by avg_rating desc;
-- ---------Which day of the week has the best average ratings per branch?-------- --
select day_name,avg(rating) as avg_rating from w_sales where branch="A" group by day_name order by avg_rating desc;
