-- Name: Louis Adams and Gregory Noetzel
-- Date: February 24, 2020
-- Class: CS340-401
-- Assignment: Step 4 Draft DDL Queries

-- phpMyAdmin SQL Dump
-- version 4.9.2
-- https://www.phpmyadmin.net/
--
-- Host: classmysql.engr.oregonstate.edu:3306
-- Generation Time: Feb 25, 2020 at 12:06 AM
-- Server version: 10.4.11-MariaDB-log
-- PHP Version: 7.0.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cs340_adamslou`
--

-- --------------------------------------------------------

--
-- Table structure for table `Customers`
--

DROP TABLE IF EXISTS `Customers`;
CREATE TABLE `Customers` (
  `cust_id` int(6) NOT NULL,
  `email` varchar(255),
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL,
  `phone_number` int(10)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Customers`
--

INSERT INTO `Customers` (`cust_id`, `email`, `first_name`, `last_name`, `phone_number`) VALUES
(1, 'kingoftown@strongbadia.com', 'King', 'Oftown', 2147483647),
(2, 'noetzelg@oregonstate.edu', 'Greg', 'Noetzel', 2147483647),
(3, 'gwashington@gmail.com', 'George', 'Washington', 2147483647);

-- --------------------------------------------------------

--
-- Table structure for table `Employees`
--

DROP TABLE IF EXISTS `Employees`;
CREATE TABLE `Employees` (
  `emp_id` int(6) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Employees`
--

INSERT INTO `Employees` (`emp_id`, `first_name`, `last_name`) VALUES
(1, 'Louis', 'Adams'),
(2, 'Delilah', 'Heythere'),
(3, 'Thomas', 'Jefferson');

-- --------------------------------------------------------

--
-- Table structure for table `Items`
--

DROP TABLE IF EXISTS `Items`;
CREATE TABLE `Items` (
  `item_id` int(6) NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `item_name` varchar(255) NOT NULL,
  `description` text,
  `quantity_available` int(4) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Items`
--

INSERT INTO `Items` (`item_id`, `price`, `item_name`, `description`, `quantity_available`) VALUES
(1, '29.99', 'Risk', 'This is a game where you attempt to dominate the world.', 15),
(2, '25.99', 'Scrabble', 'Use your mastery of the English language to score points.', 21),
(3, '59.99', 'Ticket to Ride Europe', 'Expand your empire of railways while connecting major cities of Europe.', 11);

-- --------------------------------------------------------

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
CREATE TABLE `Orders` (
  `order_id` int(6) NOT NULL,
  `cust_id` int(6) DEFAULT NULL,
  `emp_id` int(6) DEFAULT NULL,
  `date` date NOT NULL,
  `total` decimal(6,2),
  `credit_card_num` bigint(16) NOT NULL,
  `exp_date` date NOT NULL,
  `credit_card_code` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Orders`
--

INSERT INTO `Orders` (`order_id`, `cust_id`, `emp_id`, `date`, `total`, `credit_card_num`, `exp_date`, `credit_card_code`) VALUES
(1, 1, 1, '2020-01-01', '115.97', 1111222233334444, 2022, 123),
(2, 2, 2, '2020-02-01', '103.96', 1111222233334445, 2022, 124),
(3, 3, 3, '2020-02-15', '179.96', 1111222233334446, 2022, 125);

-- --------------------------------------------------------

--
-- Table structure for table `Order_Items`
--

DROP TABLE IF EXISTS `Order_Items`;
CREATE TABLE `Order_Items` (
  `order_id` int(6) NOT NULL,
  `item_id` int(6) NOT NULL,
  `quantity` int(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `Order_Items`
--

INSERT INTO `Order_Items` (`order_id`, `item_id`, `quantity`) VALUES
(1, 1, 1),
(1, 2, 1),
(1, 3, 1),
(2, 2, 4),
(3, 1, 2),
(3, 3, 2);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Customers`
--
ALTER TABLE `Customers`
  ADD PRIMARY KEY (`cust_id`);

--
-- Indexes for table `Employees`
--
ALTER TABLE `Employees`
  ADD PRIMARY KEY (`emp_id`);

--
-- Indexes for table `Items`
--
ALTER TABLE `Items`
  ADD PRIMARY KEY (`item_id`);

--
-- Indexes for table `Orders`
--
ALTER TABLE `Orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `Orders_ibfk_1` (`cust_id`),
  ADD KEY `Orders_ibfk_2` (`emp_id`);

--
-- Indexes for table `Order_Items`
--
ALTER TABLE `Order_Items`
  ADD PRIMARY KEY (`order_id`,`item_id`),
  ADD KEY `item_id` (`item_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `Customers`
--
ALTER TABLE `Customers`
  MODIFY `cust_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `Employees`
--
ALTER TABLE `Employees`
  MODIFY `emp_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `Items`
--
ALTER TABLE `Items`
  MODIFY `item_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- AUTO_INCREMENT for table `Orders`
--
ALTER TABLE `Orders`
  MODIFY `order_id` int(6) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `Orders`
--
ALTER TABLE `Orders`
  ADD CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`cust_id`) REFERENCES `Customers` (`cust_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `Orders_ibfk_2` FOREIGN KEY (`emp_id`) REFERENCES `Employees` (`emp_id`)ON DELETE SET NULL;

--
-- Constraints for table `Order_Items`
--
ALTER TABLE `Order_Items`
  ADD CONSTRAINT `Order_Items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `Orders` (`order_id`),
  ADD CONSTRAINT `Order_Items_ibfk_2` FOREIGN KEY (`item_id`) REFERENCES `Items` (`item_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
