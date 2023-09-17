# README

## Doctor-Patient Appointment System

This is an API for managing appointments between doctors and patients.

## Models

### Doctor

A healthcare professional who can have multiple patients through appointments.

### Patient

Individuals seeking medical care from doctors. 

### Appointment

A scheduled meeting between a doctor and a patient.

### DoctorAvailability

Indicates the time slots when a doctor is available.

## Services

### DoctorSchedule

Provides available time slots for a given doctor on a specific date. This schedule takes into account the doctor's general availability and any existing appointments to provide a list of free time slots.


## Things you may want to cover:

* Setup
  - install rbenv (https://github.com/rbenv/rbenv)
  - `rbenv install 3.2.2` to install ruby 3.2.2
  - `rbenv global 3.2.2` to set default to 3.2.2
  - Install bundler `bundle _2.4.19_ install`
  - Install rails `gem install rails -v 7.0.8`
  - Bundle install the gems for the project
  - Install Postgresql for your operating system (https://gorails.com/setup/macos/13-ventura)
  - Postgresql Database (please remove .sample from database.yml)
  - `bundle exec rails db:setup` to create the database and seed it.
  - `bundle exec rspec spec` to run suite

## Approach

In the beginning that were made is if we're are dealing with a clinic in one location with multiple doctors in different timezones. That did get out of hand. To simplify it I changed the assumption to only account for one location one timezone. A doctor had multiple availabilities where the doctor could create a schedule each day with chunks of time. Most of the validations are surrounded around appointments and doctor availabilities.


## Tasks I wish I had more time to do:
 - Authorization and Authentication
 - Timezones around Doctor or introduce an Office Model
 - More could be done around database constraints






