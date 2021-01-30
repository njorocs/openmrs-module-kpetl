DROP PROCEDURE IF EXISTS create_etl_tables$$
CREATE PROCEDURE create_etl_tables()
  BEGIN
    DECLARE script_id INT(11);

    -- create/recreate database kp_etl
    drop database if exists kp_etl;
    create database kp_etl;

    drop database if exists kp_datatools;
    create database kp_datatools;

    DROP TABLE IF EXISTS kp_etl.etl_script_status;
    CREATE TABLE kp_etl.etl_script_status(
      id INT(11) NOT NULL AUTO_INCREMENT PRIMARY KEY,
      script_name VARCHAR(50) DEFAULT null,
      start_time DATETIME DEFAULT NULL,
      stop_time DATETIME DEFAULT NULL,
      error VARCHAR(255) DEFAULT NULL
    );

    -- Log start time
    INSERT INTO kp_etl.etl_script_status(script_name, start_time) VALUES('initial_creation_of_tables', NOW());
    SET script_id = LAST_INSERT_ID();

    DROP TABLE IF EXISTS kp_etl.etl_client_registration;
    DROP TABLE IF EXISTS kp_etl.etl_contact;
    DROP TABLE IF EXISTS kp_etl.etl_client_enrollment;
    DROP TABLE IF EXISTS kp_etl.etl_clinical_visit;
    DROP TABLE IF EXISTS kp_etl.etl_peer_calendar;
    DROP TABLE IF EXISTS kp_etl.etl_sti_treatment;
    DROP TABLE IF EXISTS kp_etl.etl_violence_screening;
    DROP TABLE IF EXISTS kp_etl.etl_program_discontinuation;

    -- create table etl_client_registration
    create table kp_etl.etl_client_registration (
      client_id INT(11) not null primary key,
      registration_date DATE,
      given_name VARCHAR(255),
      middle_name VARCHAR(255),
      family_name VARCHAR(255),
      Gender VARCHAR(10),
      DOB DATE,
      alias_name VARCHAR(255),
      postal_address VARCHAR (255),
      county VARCHAR (255),
      sub_county VARCHAR (255),
      location VARCHAR (255),
      sub_location VARCHAR (255),
      village VARCHAR (255),
      phone_number VARCHAR (255)  DEFAULT NULL,
      alt_phone_number VARCHAR (255)  DEFAULT NULL,
      email_address VARCHAR (255)  DEFAULT NULL,
      national_id_number VARCHAR(50),
      passport_number VARCHAR(50)  DEFAULT NULL,
      dead INT(11),
      death_date DATE DEFAULT NULL,
      voided INT(11),
      index(client_id),
      index(Gender),
      index(registration_date),
      index(DOB)
    );

    SELECT "Successfully created etl_client_registration table";

    -- create table etl_contact
    create table kp_etl.etl_contact (
      uuid char(38) ,
      unique_identifier VARCHAR(50),
      client_id INT(11) NOT NULL,
      visit_id INT(11) DEFAULT NULL,
      visit_date DATE,
      location_id INT(11) DEFAULT NULL,
      encounter_id INT(11) NOT NULL PRIMARY KEY,
      encounter_provider INT(11),
      date_created DATE,
      key_population_type VARCHAR(255),
      contacted_by_peducator VARCHAR(10),
      program_name VARCHAR(255),
      frequent_hotspot_name VARCHAR(255),
      frequent_hotspot_type VARCHAR(255),
      year_started_sex_work VARCHAR(10),
      year_started_sex_with_men VARCHAR(10),
      year_started_drugs VARCHAR(10),
      avg_weekly_sex_acts int(11),
      avg_weekly_anal_sex_acts int(11),
      avg_daily_drug_injections int(11),
      contact_person_name VARCHAR(255),
      contact_person_alias VARCHAR(255),
      contact_person_phone VARCHAR(255),
      voided INT(11),
      constraint foreign key(client_id) references kp_etl.etl_client_registration(client_id),
      CONSTRAINT unique_uuid UNIQUE(uuid),
      index(client_id),
      index(unique_identifier),
      index(key_population_type)
    );

    SELECT "Successfully created etl_contact table";

    -- create table etl_client_enrollment

    create table kp_etl.etl_client_enrollment (
      uuid char(38) ,
      client_id INT(11) NOT NULL,
      visit_id INT(11) DEFAULT NULL,
      visit_date DATE,
      location_id INT(11) DEFAULT NULL,
      encounter_id INT(11) NOT NULL PRIMARY KEY,
      encounter_provider INT(11),
      date_created DATE,
      contacted_for_prevention VARCHAR(10),
      has_regular_free_sex_partner VARCHAR(10),
      year_started_sex_work VARCHAR(10),
      year_started_sex_with_men VARCHAR(10),
      year_started_drugs VARCHAR(10),
      has_expereienced_sexual_violence VARCHAR(10),
      has_expereienced_physical_violence VARCHAR(10),
      ever_tested_for_hiv VARCHAR(10),
      test_type VARCHAR(255),
      share_test_results VARCHAR(100),
      willing_to_test VARCHAR(10),
      test_decline_reason VARCHAR(255),
      receiving_hiv_care VARCHAR(10),
      care_facility_name VARCHAR(100),
      ccc_number VARCHAR(100),
      vl_test_done VARCHAR(10),
      vl_results_date DATE,
      contact_for_appointment VARCHAR(10),
      contact_method VARCHAR(255),
      buddy_name VARCHAR(255),
      buddy_phone_number VARCHAR(255),
      voided INT(11),
      constraint foreign key(client_id) references kp_etl.etl_client_registration(client_id),
      CONSTRAINT unique_uuid UNIQUE(uuid),
      index(client_id)
    );
    SELECT "Successfully created etl_client_enrollment table";

    -- create table etl_clinical_visit

    create table kp_etl.etl_clinical_visit (
      uuid char(38) ,
      client_id INT(11) NOT NULL,
      visit_id INT(11) DEFAULT NULL,
      visit_date DATE,
      location_id INT(11) DEFAULT NULL,
      encounter_id INT(11) NOT NULL PRIMARY KEY,
      encounter_provider INT(11),
      date_created DATE,
      implementing_partner VARCHAR(255),
      type_of_visit VARCHAR(255),
      visit_reason VARCHAR(255),
      service_delivery_model VARCHAR(255),
      sti_screened VARCHAR(50),
      sti_results VARCHAR(255),
      sti_treated VARCHAR(50),
      sti_referred VARCHAR(50),
      sti_referred_text VARCHAR(255),
      tb_screened VARCHAR(50),
      tb_results VARCHAR(255),
      tb_treated VARCHAR(50),
      tb_referred VARCHAR(50),
      tb_referred_text VARCHAR(255),
      hepatitisB_screened VARCHAR(50),
      hepatitisB_results VARCHAR(255),
      hepatitisB_treated VARCHAR(50),
      hepatitisB_referred VARCHAR(50),
      hepatitisB_text VARCHAR(255),
      hepatitisC_screened VARCHAR(50),
      hepatitisC_results VARCHAR(255),
      hepatitisC_treated VARCHAR(50),
      hepatitisC_referred VARCHAR(50),
      hepatitisC_text VARCHAR(255),
      overdose_screened VARCHAR(50),
      overdose_results VARCHAR(50),
      overdose_treated VARCHAR(50),
      received_naloxone VARCHAR(50),
      overdose_referred VARCHAR(50),
      overdose_text VARCHAR(255),
      abscess_screened VARCHAR(50),
      abscess_results VARCHAR(255),
      abscess_treated VARCHAR(50),
      abscess_referred VARCHAR(50),
      abscess_text VARCHAR(255),
      alcohol_screened VARCHAR(50),
      alcohol_results VARCHAR(255),
      alcohol_treated VARCHAR(50),
      alcohol_referred VARCHAR(50),
      alcohol_text VARCHAR(255),
      cerv_cancer_screened VARCHAR(50),
      cerv_cancer_results VARCHAR(255),
      cerv_cancer_treated VARCHAR(50),
      cerv_cancer_referred VARCHAR(50),
      cerv_cancer_text VARCHAR(255),
      prep_screened VARCHAR(50),
      prep_results VARCHAR(255),
      prep_treated VARCHAR(50),
      prep_referred VARCHAR(50),
      prep_text VARCHAR(255),
      violence_screened VARCHAR(50),
      violence_results VARCHAR(255),
      violence_treated VARCHAR(100),
      violence_referred VARCHAR(50),
      violence_text VARCHAR(255),
      risk_red_counselling_screened VARCHAR(50),
      risk_red_counselling_eligibility VARCHAR(255),
      risk_red_counselling_support VARCHAR(50),
      risk_red_counselling_ebi_provided VARCHAR(50),
      risk_red_counselling_text VARCHAR(255),
      fp_screened VARCHAR(50),
      fp_eligibility VARCHAR(255),
      fp_treated VARCHAR(50),
      fp_referred VARCHAR(50),
      fp_text VARCHAR(255),
      mental_health_screened VARCHAR(50),
      mental_health_results VARCHAR(255),
      mental_health_support VARCHAR(100),
      mental_health_referred VARCHAR(50),
      mental_health_text VARCHAR(255),
      hiv_self_rep_status VARCHAR(50),
      last_hiv_test_setting VARCHAR(100),
      counselled_for_hiv VARCHAR(50),
      hiv_tested VARCHAR(50),
      test_frequency VARCHAR(100),
      received_results VARCHAR(50),
      test_results VARCHAR(100),
      linked_to_art VARCHAR(50),
      facility_linked_to VARCHAR(100),
      self_test_education VARCHAR(50),
      self_test_kits_given VARCHAR(100),
      self_use_kits VARCHAR(50),
      distribution_kits VARCHAR(50),
      self_tested VARCHAR(50),
      self_test_date DATE,
      self_test_frequency VARCHAR(100),
      self_test_results VARCHAR(100),
      test_confirmatory_results VARCHAR(100),
      confirmatory_facility VARCHAR(100),
      offsite_confirmatory_facility VARCHAR(100),
      self_test_linked_art VARCHAR(50),
      self_test_link_facility VARCHAR(255),
      hiv_care_facility VARCHAR(255),
      other_hiv_care_facility VARCHAR(255),
      initiated_art_this_month VARCHAR(50),
      active_art VARCHAR(50),
      eligible_vl VARCHAR(50),
      vl_test_done VARCHAR(100),
      vl_results VARCHAR(100),
      received_vl_results VARCHAR(100),
      condom_use_education VARCHAR(50),
      post_abortal_care VARCHAR(50),
      linked_to_psychosocial VARCHAR(50),
      male_condoms_no VARCHAR(50),
      female_condoms_no VARCHAR(50),
      lubes_no VARCHAR(50),
      syringes_needles_no VARCHAR(50),
      pep_eligible VARCHAR(50),
      exposure_type VARCHAR(100),
      other_exposure_type VARCHAR(100),
      clinical_notes VARCHAR(255),
      appointment_date DATE,
      voided INT(11),
      constraint foreign key(client_id) references kp_etl.etl_client_registration(client_id),
      CONSTRAINT unique_uuid UNIQUE(uuid),
      index(client_id),
      index(client_id,visit_date)
    );
    SELECT "Successfully created etl_clinical_visit table";

    -- ------------ create table etl_peer_calendar-----------------------
    CREATE TABLE kp_etl.etl_peer_calendar (
      uuid CHAR(38),
      encounter_id INT(11) NOT NULL PRIMARY KEY,
      client_id INT(11) NOT NULL ,
      location_id INT(11) DEFAULT NULL,
      visit_date DATE,
      visit_id INT(11),
      encounter_provider INT(11),
      date_created DATE,
      hotspot_name VARCHAR(255),
      typology VARCHAR(255),
      other_hotspots VARCHAR(255),
      weekly_sex_acts INT(10),
      monthly_condoms_required INT(10),
      weekly_anal_sex_acts INT(10),
      monthly_lubes_required INT(10),
      daily_injections INT(10),
      monthly_syringes_required INT(10),
      years_in_sexwork_drugs INT(10),
      experienced_violence VARCHAR(50),
      service_provided_within_last_month VARCHAR(255),
      monthly_n_and_s_distributed  INT(10),
      monthly_male_condoms_distributed  INT(10),
      monthly_lubes_distributed  INT(10),
      monthly_female_condoms_distributed  INT(10),
      monthly_self_test_kits_distributed INT(10),
      received_clinical_service VARCHAR(50),
      violence_reported VARCHAR(50),
      referred  VARCHAR(50),
      health_edu VARCHAR(50),
      remarks VARCHAR(255),
      voided INT(11),
      CONSTRAINT FOREIGN KEY (client_id) REFERENCES kp_etl.etl_client_registration(client_id),
      CONSTRAINT unique_uuid UNIQUE(uuid),
      INDEX(visit_date),
      INDEX(client_id, visit_date)
    );

    SELECT "Successfully created etl_peer_calendar table";

        -- ------------ create table etl_sti_treatment-----------------------
    CREATE TABLE kp_etl.etl_sti_treatment (
      uuid CHAR(38),
      encounter_id INT(11) NOT NULL PRIMARY KEY,
      client_id INT(11) NOT NULL ,
      location_id INT(11) DEFAULT NULL,
      visit_date DATE,
      visit_id INT(11),
      encounter_provider INT(11),
      date_created DATE,
      visit_reason VARCHAR(255),
      syndrome VARCHAR(10),
      other_syndrome VARCHAR(255),
      drug_prescription VARCHAR(10),
      other_drug_prescription VARCHAR(255),
      genital_exam_done VARCHAR(10),
      lab_referral VARCHAR(10),
      lab_form_number VARCHAR(100),
      referred_to_facility VARCHAR(10),
      facility_name VARCHAR(255),
      partner_referral_done VARCHAR(10),
      given_lubes VARCHAR(10),
      no_of_lubes INT(10),
      given_condoms VARCHAR(10),
      no_of_condoms INT(10),
      provider_comments VARCHAR(255),
      provider_name VARCHAR(255),
      appointment_date DATE,
      voided INT(11),
      CONSTRAINT FOREIGN KEY (client_id) REFERENCES kp_etl.etl_client_registration(client_id),
      CONSTRAINT unique_uuid UNIQUE(uuid),
      INDEX(visit_date),
      INDEX(encounter_id),
      INDEX(client_id),
      INDEX(visit_reason),
      INDEX(given_lubes),
      INDEX(given_condoms)
    );


-- -------------------------- CREATE hts_test table ---------------------------------

create table kp_etl.etl_hts_test (
client_id INT(11) not null,
visit_id INT(11) DEFAULT NULL,
encounter_id INT(11) NOT NULL primary key,
encounter_uuid CHAR(38) NOT NULL,
encounter_location INT(11) NOT NULL,
creator INT(11) NOT NULL,
date_created DATE NOT NULL,
visit_date DATE,
test_type INT(11) DEFAULT NULL,
population_type VARCHAR(50),
key_population_type VARCHAR(50),
ever_tested_for_hiv VARCHAR(10),
months_since_last_test INT(11),
patient_disabled VARCHAR(50),
disability_type VARCHAR(50),
patient_consented VARCHAR(50) DEFAULT NULL,
client_tested_as VARCHAR(50),
test_strategy VARCHAR(50),
hts_entry_point VARCHAR(50),
test_1_kit_name VARCHAR(50),
test_1_kit_lot_no VARCHAR(50) DEFAULT NULL,
test_1_kit_expiry DATE DEFAULT NULL,
test_1_result VARCHAR(50) DEFAULT NULL,
test_2_kit_name VARCHAR(50),
test_2_kit_lot_no VARCHAR(50) DEFAULT NULL,
test_2_kit_expiry DATE DEFAULT NULL,
test_2_result VARCHAR(50) DEFAULT NULL,
final_test_result VARCHAR(50) DEFAULT NULL,
patient_given_result VARCHAR(50) DEFAULT NULL,
couple_discordant VARCHAR(100) DEFAULT NULL,
tb_screening VARCHAR(20) DEFAULT NULL,
patient_had_hiv_self_test VARCHAR(50) DEFAULT NULL,
remarks VARCHAR(255) DEFAULT NULL,
voided INT(11),
index(client_id),
index(visit_id),
index(tb_screening),
index(visit_date),
index(population_type),
index(test_type),
index(final_test_result),
index(couple_discordant),
index(test_1_kit_name),
index(test_2_kit_name)
);

 CREATE TABLE kp_etl.etl_violence_screening (
      encounter_id INT(11) NOT NULL PRIMARY KEY,
      client_id INT(11) NOT NULL ,
      location_id INT(11) DEFAULT NULL,
      visit_date DATE,
      visit_id INT(11),
      encounter_provider INT(11),
      date_created DATE,
      incident_place VARCHAR(100),
      incident_date DATE,
      person_abused VARCHAR(100),
      verbal_abuse VARCHAR(100),
      physical_abuse VARCHAR(100),
      discrimination VARCHAR(100),
      sexual_abuse VARCHAR(100),
      illegal_arrest VARCHAR(100),
      harrassment VARCHAR(100),
      local_gang_perpetrator VARCHAR(100),
      police_perpetrator VARCHAR(100),
      general_public_perpetrator VARCHAR(100),
      client_perpetrator VARCHAR(100),
      community_member_perpetrator VARCHAR(100),
      local_authority_perpetrator VARCHAR(100),
      health_care_provider_perpetrator VARCHAR(100),
      education_institution_perpetrator VARCHAR(100),
      religious_group_perpetrator VARCHAR(100),
      drug_peddler_perpetrator VARCHAR(100),
      pimp_perpetrator VARCHAR(100),
      bar_owner_manager_perpetrator VARCHAR(100),
      family_perpetrator VARCHAR(100),
      partner_perpetrator VARCHAR(100),
      neighbour_perpetrator VARCHAR(100),
      employer_perpetrator VARCHAR(100),
      other_perpetrator VARCHAR(100),
      other_specified_perpetrator VARCHAR(100),
      first_response_date DATE,
      violence_support_given INT(11),
      prc_hts INT(11),
      prc_hts_within_5_days INT(11),
      prc_emergency_contraception INT(11),
      prc_emergency_contraception_within_5_days INT(11),
      prc_complaint_reg_at_police_stn INT(11),
      prc_complaint_reg_at_police_stn_within_5_days INT(11),
      prc_psychological_trauma_counselling INT(11),
      prc_psychological_trauma_counselling_within_5_days INT(11),
      prc_pep_duration INT(11),
      prc_pep_within_5_days INT(11),
      prc_sti_screening_treatment INT(11),
      prc_sti_screening_treatment_within_5_days INT(11),
      prc_legal_support INT(11),
      prc_legal_support_within_5_days INT(11),
      prc_medical_examination INT(11),
      prc_medical_examination_within_5_days INT(11),
      prc_form_file INT(11),
      prc_form_file_within_5_days INT(11),
      prc_other_services_given VARCHAR(100),
      non_sexual_medical_services_and_care INT(11),
      non_sexual_medical_services_and_care_within_5_days INT(11),
      non_sexual_psychological_counselling INT(11),
      non_sexual_psychological_counselling_within_5_days INT(11),
      non_sexual_complaint_reg_at_police_stn INT(11),
      non_sexual_complaint_reg_at_police_stn_within_5_days INT(11),
      non_sexual_legal_support INT(11),
      non_sexual_legal_support_within_5_days INT(11),
      current_state_of_victim VARCHAR(100),
      follow_up_plan VARCHAR(250),
      issue_resolution_date DATE,
      voided INT(11),
      CONSTRAINT FOREIGN KEY (client_id) REFERENCES kp_etl.etl_client_registration(client_id),
      INDEX(visit_date),
      INDEX(encounter_id),
      INDEX(client_id)
    );

CREATE TABLE kp_etl.etl_program_discontinuation (
encounter_id INT(11) NOT NULL PRIMARY KEY,
client_id INT(11) NOT NULL ,
location_id INT(11) DEFAULT NULL,
visit_date DATE,
visit_id INT(11),
encounter_provider INT(11),
date_created DATE,
reason VARCHAR(100),
date_of_death DATE,
transfer_facility VARCHAR(100),
date_transferred_out DATE,
voided INT(11),
CONSTRAINT FOREIGN KEY (client_id) REFERENCES kp_etl.etl_client_registration(client_id),
INDEX(visit_date),
INDEX(encounter_id),
INDEX(client_id)
);

END$$