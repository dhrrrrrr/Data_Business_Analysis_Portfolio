# Maven Analytics - Pizza Sales Analysis

#### Business problem:
Plato's Pizza has been collecting transactional data but has yet to effectively utilize it. 
The lack of data analysis has resulted in missed opportunities for increasing sales and operational efficiency. 
To address this issue, we need to analyze the collected data to answer specific questions regarding: 
peak business hours, pizza production during busy periods, best and worst selling pizzas, average order value, and the utilization of seating capacity. 
The objective is to develop a single-page dashboard that provides actionable insights to help drive sales growth and optimize restaurant operations.

#### About the dataset
This dataset contains 4 tables in CSV format
1. The Orders table contains the date & time that all table orders were placed <br />
2. The Order Details table contains the different pizzas served with each order in the Orders table, and their quantities <br />
3. The Pizzas table contains the size and price for each distinct pizza in the Order Details table, as well as its broader pizza type <br />
4. The Pizza Types table contains details on the pizza types in the Pizzas table, including their name as it appears on the menu, the category it falls under, and its list of ingredients <br />

#### Problem approach:
1. Perform data cleaning and ensure that all relevant data from different sources are combined into a single consolidated dataset. Address any inconsistencies or errors in the data during this process.
2. Re-modle the data relationship. Add or modify relationships between tables if neccessary.
3. Aggregate and summarize the data to generate insights related to peak business hours, pizza production, top-selling and underperforming pizzas, average order value, and seating capacity utilization.
Visualize these insights using charts, graphs, and tables.
