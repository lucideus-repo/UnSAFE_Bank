-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Feb 17, 2020 at 08:36 AM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.2.27

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `abstractwallet`
--

-- --------------------------------------------------------

--
-- Table structure for table `account_details`
--

CREATE TABLE `account_details` (
  `id_pk` int(10) NOT NULL,
  `user_id_fk` int(10) NOT NULL,
  `user_details_id_fk` int(20) NOT NULL,
  `bank_master_id_fk` int(10) NOT NULL,
  `account_no` char(12) NOT NULL,
  `account_balance` double NOT NULL,
  `income_tax_number` char(10) NOT NULL,
  `account_opening_date` datetime NOT NULL,
  `currency_ticker` varchar(4) NOT NULL,
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `account_details`
--

INSERT INTO `account_details` (`id_pk`, `user_id_fk`, `user_details_id_fk`, `bank_master_id_fk`, `account_no`, `account_balance`, `income_tax_number`, `account_opening_date`, `currency_ticker`, `updated_at`) VALUES
(5, 5, 5, 2, '149812733485', 10500.21, '6542502165', '2018-11-19 00:00:00', 'INR', '2019-03-20 11:42:11'),
(6, 6, 6, 8, '261562410205', 10000, '5395631056', '2018-11-19 00:00:00', 'INR', '2019-03-20 11:43:47'),
(7, 7, 7, 9, '618850572087', 10200.02, '3800485481', '2018-11-19 00:00:00', 'INR', '2020-02-17 12:45:43'),
(8, 8, 8, 10, '263021552894', 9176.32, '0623304234', '2018-11-19 00:00:00', 'INR', '2020-02-17 12:45:43');

-- --------------------------------------------------------

--
-- Table structure for table `bank_master`
--

CREATE TABLE `bank_master` (
  `id_pk` int(20) NOT NULL,
  `bank_code` varchar(10) NOT NULL COMMENT 'Its IFSC/Swift Code',
  `bank_name` varchar(255) NOT NULL,
  `branch` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `bank_master`
--

INSERT INTO `bank_master` (`id_pk`, `bank_code`, `bank_name`, `branch`) VALUES
(1, 'IFSC00001', 'HDFC Bank', 'Delhi'),
(2, 'IFSC00002', 'State Bank of India', 'Mumbai'),
(3, 'IFSC00003', 'ICICI Bank Limited', 'Gurgaon'),
(4, 'IFSC00004', 'Axis Bank ', 'Ghaziabad'),
(5, 'IFSC00005', 'Kotak Mahindra Bank', 'Meerut'),
(6, 'IFSC00006', 'IndusInd Bank ', 'Muzaffarnagar'),
(7, 'IFSC00007', 'Bank of Baroda', 'Bhopal'),
(8, 'IFSC00008', 'Yes Bank', 'Indore'),
(9, 'IFSC00009', 'Punjab National Bank', 'Ahmedabad'),
(10, 'IFSC00010', 'Canara Bank', 'Faridabad');

-- --------------------------------------------------------

--
-- Table structure for table `beneficiary_details`
--

CREATE TABLE `beneficiary_details` (
  `id_pk` int(20) NOT NULL,
  `user_id_fk` int(20) NOT NULL,
  `beneficiary_account_no` char(20) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `bank_code` varchar(10) NOT NULL,
  `beneficiary_alias` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `ci_sessions`
--

CREATE TABLE `ci_sessions` (
  `id` varchar(40) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` int(10) UNSIGNED NOT NULL DEFAULT 0,
  `data` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `country_master`
--

CREATE TABLE `country_master` (
  `id_pk` int(10) NOT NULL,
  `country_id` varchar(10) NOT NULL,
  `country_name` varchar(50) NOT NULL,
  `currency_ticker` varchar(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `country_master`
--

INSERT INTO `country_master` (`id_pk`, `country_id`, `country_name`, `currency_ticker`) VALUES
(1, 'IND', 'india', 'INR'),
(2, 'AUS', 'australia', 'AUD'),
(3, 'CAN', 'canada', 'CAD');

-- --------------------------------------------------------

--
-- Table structure for table `otp_master`
--

CREATE TABLE `otp_master` (
  `id_pk` int(20) NOT NULL,
  `user_details_id_fk` int(20) NOT NULL,
  `otp_no` char(6) NOT NULL,
  `otp_timestamp` int(15) NOT NULL,
  `otp_purpose` char(1) NOT NULL,
  `otp_ref` varchar(15) NOT NULL,
  `remaining_attempts` int(11) NOT NULL DEFAULT 5,
  `verified` tinyint(1) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `session_master`
--

CREATE TABLE `session_master` (
  `id_pk` int(11) NOT NULL,
  `session_id` char(20) NOT NULL,
  `cust_id` char(8) NOT NULL,
  `last_access` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `transaction_master`
--

CREATE TABLE `transaction_master` (
  `id_pk` int(11) NOT NULL,
  `trans_date` date NOT NULL,
  `src_acct` char(15) NOT NULL,
  `dst_acct` char(15) NOT NULL,
  `trans_remark` varchar(30) NOT NULL,
  `trans_amt` double NOT NULL,
  `trans_ref` char(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id_pk` int(20) NOT NULL,
  `password` varchar(100) NOT NULL,
  `account_type` tinyint(4) NOT NULL DEFAULT 0 COMMENT '0=Saving,1=Current',
  `updated_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `created_at` datetime NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '0=inactive,1=active',
  `user_role` varchar(10) NOT NULL,
  `device_os` varchar(10) NOT NULL,
  `host` varchar(50) NOT NULL,
  `cust_id` char(8) NOT NULL,
  `device_id` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id_pk`, `password`, `account_type`, `updated_at`, `created_at`, `is_active`, `user_role`, `device_os`, `host`, `cust_id`, `device_id`) VALUES
(5, 'b337d6517a43790318ab44eb8423e458', 0, '2018-11-19 17:35:10', '2018-11-19 17:35:10', 1, 'USER', 'iOS', 'lucideustech.com', 'BNK56861', 'UHDGGF735SVHFVSX'),
(6, 'b337d6517a43790318ab44eb8423e458', 0, '2018-11-19 17:36:04', '2018-11-19 17:36:04', 1, 'USER', 'iOS', 'lucideustech.com', 'BNK72671', 'UHDGGF735SVHFVSX'),
(7, 'b337d6517a43790318ab44eb8423e458', 0, '2018-11-19 17:37:01', '2018-11-19 17:37:01', 1, 'USER', 'iOS', 'lucideustech.com', 'BNK67830', 'UHDGGF735SVHFVSX'),
(8, 'b337d6517a43790318ab44eb8423e458', 0, '2020-02-16 18:07:19', '2020-02-16 18:07:19', 1, 'USER', 'iOS', 'lucideustech.com', 'BNK45160', 'UHDGGF735SVHFVSX');

-- --------------------------------------------------------

--
-- Table structure for table `user_details`
--

CREATE TABLE `user_details` (
  `id_pk` int(20) NOT NULL,
  `user_id_fk` int(10) NOT NULL,
  `fname` varchar(20) NOT NULL,
  `lname` varchar(20) NOT NULL,
  `address` varchar(50) NOT NULL,
  `dob` date NOT NULL,
  `mobile_no` char(10) NOT NULL,
  `email` varchar(50) NOT NULL,
  `aadhar_id` char(12) NOT NULL,
  `pan_card_id` char(10) NOT NULL,
  `wallet_id` char(10) NOT NULL,
  `gender` int(1) NOT NULL COMMENT 'Male=1,Female=2,Others=3',
  `country_id` char(3) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user_details`
--

INSERT INTO `user_details` (`id_pk`, `user_id_fk`, `fname`, `lname`, `address`, `dob`, `mobile_no`, `email`, `aadhar_id`, `pan_card_id`, `wallet_id`, `gender`, `country_id`) VALUES
(5, 5, 'Rubal', 'Jain', 'Delhi, Delhi', '1990-01-14', '8109623250', 'rubal.j@lucideustech.com', '038564888546', '3354105728', '0206446070', 1, 'IND'),
(6, 6, 'Sahil', 'Pahwa', 'Delhi, Delhi', '1991-10-10', '9899659540', 'sahil.p@lucideustech.com', '335947906653', '9527820134', '8570896514', 1, 'IND'),
(7, 7, 'Chetan', 'Kumar', 'Delhi, Delhi', '1994-04-23', '9971005574', 'chetan.d@lucideustech.com', '408896036805', '8400219063', '6699058502', 1, 'IND'),
(8, 8, 'Vibhav', 'Dudeja', 'Delhi, Delhi', '1995-09-16', '9718429633', 'vibhav.d@lucideustech.com', '980865376738', '1761885579', '8995900011', 1, 'IND');

-- --------------------------------------------------------

--
-- Table structure for table `wallet`
--

CREATE TABLE `wallet` (
  `wallet_id` int(10) NOT NULL,
  `wallet_bal` int(255) NOT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `account_details`
--
ALTER TABLE `account_details`
  ADD PRIMARY KEY (`id_pk`),
  ADD KEY `user_details_pk_fk_const` (`user_details_id_fk`),
  ADD KEY `user_id_pk_fk` (`user_id_fk`);

--
-- Indexes for table `bank_master`
--
ALTER TABLE `bank_master`
  ADD PRIMARY KEY (`id_pk`);

--
-- Indexes for table `beneficiary_details`
--
ALTER TABLE `beneficiary_details`
  ADD PRIMARY KEY (`id_pk`);

--
-- Indexes for table `ci_sessions`
--
ALTER TABLE `ci_sessions`
  ADD PRIMARY KEY (`id`,`ip_address`),
  ADD KEY `ci_sessions_timestamp` (`timestamp`);

--
-- Indexes for table `country_master`
--
ALTER TABLE `country_master`
  ADD PRIMARY KEY (`id_pk`);

--
-- Indexes for table `otp_master`
--
ALTER TABLE `otp_master`
  ADD PRIMARY KEY (`id_pk`);

--
-- Indexes for table `session_master`
--
ALTER TABLE `session_master`
  ADD PRIMARY KEY (`id_pk`);

--
-- Indexes for table `transaction_master`
--
ALTER TABLE `transaction_master`
  ADD PRIMARY KEY (`id_pk`),
  ADD UNIQUE KEY `id_pk` (`id_pk`),
  ADD UNIQUE KEY `id_pk_2` (`id_pk`),
  ADD UNIQUE KEY `id_pk_3` (`id_pk`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id_pk`);

--
-- Indexes for table `user_details`
--
ALTER TABLE `user_details`
  ADD PRIMARY KEY (`id_pk`),
  ADD KEY `user_id_pk_fk_const` (`user_id_fk`);

--
-- Indexes for table `wallet`
--
ALTER TABLE `wallet`
  ADD PRIMARY KEY (`wallet_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `account_details`
--
ALTER TABLE `account_details`
  MODIFY `id_pk` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `bank_master`
--
ALTER TABLE `bank_master`
  MODIFY `id_pk` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `beneficiary_details`
--
ALTER TABLE `beneficiary_details`
  MODIFY `id_pk` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `country_master`
--
ALTER TABLE `country_master`
  MODIFY `id_pk` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `otp_master`
--
ALTER TABLE `otp_master`
  MODIFY `id_pk` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `session_master`
--
ALTER TABLE `session_master`
  MODIFY `id_pk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

--
-- AUTO_INCREMENT for table `transaction_master`
--
ALTER TABLE `transaction_master`
  MODIFY `id_pk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id_pk` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `user_details`
--
ALTER TABLE `user_details`
  MODIFY `id_pk` int(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=32;

--
-- AUTO_INCREMENT for table `wallet`
--
ALTER TABLE `wallet`
  MODIFY `wallet_id` int(10) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
