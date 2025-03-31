-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Nov 20, 2024 at 08:03 AM
-- Server version: 8.2.0
-- PHP Version: 8.3.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ap2`
--

-- --------------------------------------------------------

--
-- Table structure for table `cake_d_c_users_phinxlog`
--

CREATE TABLE `cake_d_c_users_phinxlog` (
  `version` bigint NOT NULL,
  `migration_name` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `start_time` timestamp NULL DEFAULT NULL,
  `end_time` timestamp NULL DEFAULT NULL,
  `breakpoint` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `cake_d_c_users_phinxlog`
--

INSERT INTO `cake_d_c_users_phinxlog` (`version`, `migration_name`, `start_time`, `end_time`, `breakpoint`) VALUES
(20150513201111, 'Initial', '2024-11-14 11:48:28', '2024-11-14 11:48:28', 0),
(20161031101316, 'AddSecretToUsers', '2024-11-14 11:48:28', '2024-11-14 11:48:28', 0),
(20190208174112, 'AddAdditionalDataToUsers', '2024-11-14 11:48:28', '2024-11-14 11:48:28', 0),
(20210929202041, 'AddLastLoginToUsers', '2024-11-14 11:48:28', '2024-11-14 11:48:28', 0);

-- --------------------------------------------------------

--
-- Table structure for table `machines`
--

CREATE TABLE `machines` (
  `id` int NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `cpu` varchar(50) DEFAULT NULL,
  `memoire` varchar(50) DEFAULT NULL,
  `os` varchar(50) DEFAULT NULL,
  `jeu` varchar(50) DEFAULT NULL,
  `date_achat` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `machines`
--

INSERT INTO `machines` (`id`, `nom`, `cpu`, `memoire`, `os`, `jeu`, `date_achat`) VALUES
(3, 'MSI', 'i7', '16 go ram', 'windows', 'lol, gta v , fifa 25', '2020-06-10');

-- --------------------------------------------------------

--
-- Table structure for table `maintenances`
--

CREATE TABLE `maintenances` (
  `id` int NOT NULL,
  `description` varchar(255) DEFAULT NULL,
  `date_maintenance` date DEFAULT NULL,
  `machine_id` int NOT NULL,
  `statut` enum('En attente','En cours','Terminée','Annulée') NOT NULL DEFAULT 'En attente'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `maintenances`
--

INSERT INTO `maintenances` (`id`, `description`, `date_maintenance`, `machine_id`, `statut`) VALUES
(2, 'maintenance systeme', '2024-11-15', 3, 'En attente');

-- --------------------------------------------------------

--
-- Table structure for table `packages`
--

CREATE TABLE `packages` (
  `id` int NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `prix` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `packages`
--

INSERT INTO `packages` (`id`, `nom`, `description`, `prix`) VALUES
(10, 'forfait basic', '1h', '10$'),
(11, 'forfait premium', '2h', '20$'),
(12, 'forfait basic', '1h', '10$');

-- --------------------------------------------------------

--
-- Table structure for table `packages_users`
--

CREATE TABLE `packages_users` (
  `user_id` char(36) NOT NULL,
  `package_id` int NOT NULL,
  `date_achat` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `packages_users`
--

INSERT INTO `packages_users` (`user_id`, `package_id`, `date_achat`) VALUES
('aa79d7bd-af7e-4151-84da-2b571db42c08', 12, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `id` int NOT NULL,
  `nom` varchar(50) DEFAULT NULL,
  `description` varchar(100) DEFAULT NULL,
  `date_reservation` date DEFAULT NULL,
  `debut` datetime DEFAULT NULL,
  `fin` datetime DEFAULT NULL,
  `user_id` char(36) NOT NULL,
  `machine_id` int NOT NULL,
  `package_id` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`id`, `nom`, `description`, `date_reservation`, `debut`, `fin`, `user_id`, `machine_id`, `package_id`) VALUES
(3, 'reservation de session', '1h', '2024-11-18', '2024-11-20 19:00:00', '2024-11-20 21:00:00', 'aa79d7bd-af7e-4151-84da-2b571db42c08', 3, 10);

-- --------------------------------------------------------

--
-- Table structure for table `social_accounts`
--

CREATE TABLE `social_accounts` (
  `id` char(36) NOT NULL,
  `user_id` char(36) NOT NULL,
  `provider` varchar(255) NOT NULL,
  `username` varchar(255) DEFAULT NULL,
  `reference` varchar(255) NOT NULL,
  `avatar` varchar(255) DEFAULT NULL,
  `description` text,
  `link` varchar(255) NOT NULL,
  `token` varchar(500) NOT NULL,
  `token_secret` varchar(500) DEFAULT NULL,
  `token_expires` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `data` text NOT NULL,
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` char(36) NOT NULL,
  `username` varchar(255) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `first_name` varchar(50) DEFAULT NULL,
  `last_name` varchar(50) DEFAULT NULL,
  `token` varchar(255) DEFAULT NULL,
  `token_expires` datetime DEFAULT NULL,
  `api_token` varchar(255) DEFAULT NULL,
  `activation_date` datetime DEFAULT NULL,
  `secret` varchar(32) DEFAULT NULL,
  `secret_verified` tinyint(1) DEFAULT NULL,
  `tos_date` datetime DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '0',
  `is_superuser` tinyint(1) NOT NULL DEFAULT '0',
  `role` varchar(255) DEFAULT 'user',
  `created` datetime NOT NULL,
  `modified` datetime NOT NULL,
  `additional_data` text,
  `last_login` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `email`, `password`, `first_name`, `last_name`, `token`, `token_expires`, `api_token`, `activation_date`, `secret`, `secret_verified`, `tos_date`, `active`, `is_superuser`, `role`, `created`, `modified`, `additional_data`, `last_login`) VALUES
('43a0b033-f4c4-4be7-bdb9-0a6226c9958b', 'superadmin', 'superadmin@example.com', '$2y$10$lp4hmOe4b3KZNBwS0e0gi.M8GlmHDI9VmyqIsDRHMfwWREWWVlnli', NULL, NULL, NULL, NULL, NULL, NULL, 'VKLXAMPKQEBJW64F', NULL, NULL, 1, 1, 'superuser', '2024-11-14 12:57:18', '2024-11-20 07:58:26', NULL, '2024-11-20 07:56:44'),
('45ab8ef0-c8c6-4015-b6f7-1642ee5fa20e', 'zaki', 'fewfew@gmail.com', '$2y$10$Sk9AJIi2tjzD/s9AhuHy3.QwXB9egIkRs2vmUq6trzttv5Z7u0aDy', 'zaki', 'ziko', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 'user', '2024-11-18 13:52:23', '2024-11-18 13:52:23', NULL, NULL),
('aa79d7bd-af7e-4151-84da-2b571db42c08', 'z3kk0', 'mhoudarbach@gmail.com', '$2y$10$kRLjLj9viLrSx/N20N1AmOg7r16FRM/1vDsgmBb1Uw4IWB2p33gsm', 'Zakariae', 'Houdarbach', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 1, 0, 'user', '2024-11-14 13:27:32', '2024-11-14 13:27:32', NULL, '2024-11-20 07:36:08');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cake_d_c_users_phinxlog`
--
ALTER TABLE `cake_d_c_users_phinxlog`
  ADD PRIMARY KEY (`version`);

--
-- Indexes for table `machines`
--
ALTER TABLE `machines`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `maintenances`
--
ALTER TABLE `maintenances`
  ADD PRIMARY KEY (`id`),
  ADD KEY `machine_id` (`machine_id`);

--
-- Indexes for table `packages`
--
ALTER TABLE `packages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `packages_users`
--
ALTER TABLE `packages_users`
  ADD PRIMARY KEY (`user_id`,`package_id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `machine_id` (`machine_id`),
  ADD KEY `package_id` (`package_id`);

--
-- Indexes for table `social_accounts`
--
ALTER TABLE `social_accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `machines`
--
ALTER TABLE `machines`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `maintenances`
--
ALTER TABLE `maintenances`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `packages`
--
ALTER TABLE `packages`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `maintenances`
--
ALTER TABLE `maintenances`
  ADD CONSTRAINT `maintenances_ibfk_1` FOREIGN KEY (`machine_id`) REFERENCES `machines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `packages_users`
--
ALTER TABLE `packages_users`
  ADD CONSTRAINT `packages_users_ibfk_2` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`),
  ADD CONSTRAINT `packages_users_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `reservations`
--
ALTER TABLE `reservations`
  ADD CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`machine_id`) REFERENCES `machines` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  ADD CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`package_id`) REFERENCES `packages` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `social_accounts`
--
ALTER TABLE `social_accounts`
  ADD CONSTRAINT `social_accounts_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
