-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema movie_rating
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema movie_rating
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `movie_rating` DEFAULT CHARACTER SET utf8 ;
USE `movie_rating` ;

-- -----------------------------------------------------
-- Table `movie_rating`.`rating`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `movie_rating`.`rating` ;

CREATE TABLE IF NOT EXISTS `movie_rating`.`rating` (
  `MovieID` INT(11) NOT NULL,
  `FriendsID` INT(11) NOT NULL,
  `FriendsRating` INT(11) NOT NULL,
  PRIMARY KEY (`MovieID`, `FriendsID`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `movie_rating`.`friends`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `movie_rating`.`friends` ;

CREATE TABLE IF NOT EXISTS `movie_rating`.`friends` (
  `FriendsID` INT(11) NOT NULL AUTO_INCREMENT,
  `FriendsName` VARCHAR(45) NOT NULL,
  `rating_MovieID` INT(11) NOT NULL,
  `rating_FriendsID` INT(11) NOT NULL,
  PRIMARY KEY (`FriendsID`),
  INDEX `fk_friends_rating1_idx` (`rating_MovieID` ASC, `rating_FriendsID` ASC),
  CONSTRAINT `fk_friends_rating1`
    FOREIGN KEY (`rating_MovieID` , `rating_FriendsID`)
    REFERENCES `movie_rating`.`rating` (`MovieID` , `FriendsID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


-- -----------------------------------------------------
-- Table `movie_rating`.`movie`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `movie_rating`.`movie` ;

CREATE TABLE IF NOT EXISTS `movie_rating`.`movie` (
  `YearRelease` INT(11) NOT NULL,
  `Title` VARCHAR(45) NOT NULL,
  `IMDb.Rating` FLOAT NULL DEFAULT NULL,
  `MovieID` INT(11) NOT NULL AUTO_INCREMENT,
  `friends_FriendsID` INT(11) NOT NULL,
  PRIMARY KEY (`MovieID`),
  INDEX `fk_movie_friends_idx` (`friends_FriendsID` ASC),
  CONSTRAINT `fk_movie_friends`
    FOREIGN KEY (`friends_FriendsID`)
    REFERENCES `movie_rating`.`friends` (`FriendsID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
