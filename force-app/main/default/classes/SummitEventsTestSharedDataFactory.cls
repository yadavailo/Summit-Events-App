// Copyright 2019 University of St. Thomas - Minnesota. All rights reserved.
// Use of this source code is governed by a BSD Revised
// license that can be found in the LICENSE file.
// Created by Thaddaeus Dahlberg on 4/2/2019.

@IsTest
public with sharing class SummitEventsTestSharedDataFactory {

    public static Summit_Events_Instance__c createTestEvent(
            String matchingRules,
            String testEventName,
            String audience,
            Boolean includeAppt,
            Boolean includeAddQuestions,
            String registrationEmailRestriction
    ) {

        Summit_Events__c testEvent = new Summit_Events__c();

        //Create event
        testEvent = new Summit_Events__c(
                Name = testEventName,
                Event_Status__c = 'Active',
                Event_Name__c = testEventName,
                Start_Date__c = Date.today().addDays(1),
                End_Date__c = Date.today().addDays(1),
                Template__c = 'CastorTemplate2017',
                Event_Home_Link_Title__c = 'testHome',
                Event_Home_Link_URL__c = '/',
                College_High_School_Ask__c = 'Auto Select on Audience',
                Ask_Gender__c = 'Ask and require',
                Include_Time_frame_List__c = true,
                Allow_Other_Attendees__c = true,
                Ask_Mailing_Address__c = 'Ask',
                Ask_Phone__c = 'Ask home and mobile require one',
                Ask_Date_Of_Birth__c = 'Ask',
                Max_Other_Attendees__c = 5,
                Close_Event_Days_Before__c = 0,
                Audience__c = audience,
                Location_Title__c = 'A location',
                Location_Map_Link__c = 'Map Link 1',
                Location_Address__c = '123 Electric Ave.',
                Location_Type__c = 'On-Site',
                Contact_Matching_Rules__c = matchingRules
        );

        if (String.isNotBlank(registrationEmailRestriction)) {
            testEvent.Registration_Email_Restriction__c = registrationEmailRestriction;
        }

        if (includeAddQuestions) {
            testEvent.Add_Info_Question_Type_1__c = 'Pick-list';
            testEvent.Add_Info_Question_Text_1__c = 'What is your favorite color?';
            testEvent.Add_Info_Question_Pick_List_1__c = 'Red\nGreen\nYellow\nBlue';
            testEvent.Academic_Program_List__c = 'This(THIS_THIS|THAT);That(THAT_THAT|THIS);';
        }

        insert testEvent;

        if (includeAppt) {
            //Create appointment  types
            List<Summit_Events_Appointment_Type__c> newApptTypes = new List<Summit_Events_Appointment_Type__c>();
            newApptTypes.add(new Summit_Events_Appointment_Type__c(
                    Summit_Events__c = testEvent.Id,
                    Title__c = 'Test Appointment',
                    Appointment_Limits__c = '1',
                    Description__c = 'Test description'
            ));

            newApptTypes.add(new Summit_Events_Appointment_Type__c(
                    Summit_Events__c = testEvent.Id,
                    Title__c = 'Test Appointment 2',
                    Appointment_Limits__c = '1',
                    Description__c = 'Test description 2',
                    Appointment_Category__c = 'Faculty Visit'
            ));

            newApptTypes.add(new Summit_Events_Appointment_Type__c(
                    Summit_Events__c = testEvent.Id,
                    Title__c = 'Test Appointment 3',
                    Appointment_Limits__c = '1',
                    Description__c = 'Test description 3',
                    Registrant_Input__c = 'Text box'
            ));

            newApptTypes.add(new Summit_Events_Appointment_Type__c(
                    Summit_Events__c = testEvent.Id,
                    Title__c = 'Test Appointment 4',
                    Appointment_Limits__c = '2',
                    Description__c = 'Test description 4',
                    Registrant_Input__c = 'Required text box'
            ));

            newApptTypes.add(new Summit_Events_Appointment_Type__c(
                    Summit_Events__c = testEvent.Id,
                    Title__c = 'Test Appointment 5',
                    Appointment_Limits__c = '2',
                    Description__c = 'Test description 5',
                    Registrant_Input__c = 'Required custom pick list',
                    Custom_Picklist__c = 'Pick One\n\nPickTwo'
            ));

            newApptTypes.add(new Summit_Events_Appointment_Type__c(
                    Summit_Events__c = testEvent.Id,
                    Title__c = 'Test Appointment 6',
                    Appointment_Limits__c = '1',
                    Description__c = 'Test description 6',
                    Registrant_Input__c = 'Custom pick list',
                    Custom_Picklist__c = 'Pick One\n\nPickTwo'
            ));

            insert newApptTypes;
        }
        //Create event instance
        Summit_Events_Instance__c testInstance = new Summit_Events_Instance__c(
                Event__c = testEvent.Id,
                Instance_Title__c = testEventName + ' Sesssion',
                Instance_Start_Date__c = Date.today().addDays(1),
                Instance_Start_Time__c = Time.newInstance(8,0,0,0),
                Instance_End_Date__c = Date.today().addDays(1),
                Instance_End_Time__c = Time.newInstance(14,0,0,0),
                Active_Status__c = 'Active',
                Capacity__c = 500,
                Location_Title_Override__c = 'A location',
                Location_Map_Link_Override__c = 'Map Link 1',
                Location_Address_Override__c = '123 Electric Ave.',
                Location_Type_Override__c = 'Online'
        );
        insert testInstance;

        Summit_Events_Instance__c testInstance2 = new Summit_Events_Instance__c(
                Event__c = testEvent.Id,
                Instance_Title__c = testEventName + ' Sesssion 2',
                Instance_Start_Date__c = Date.today().addDays(3),
                Instance_Start_Time__c = Time.newInstance(8,0,0,0),
                Instance_End_Date__c = Date.today().addDays(3),
                Instance_End_Time__c = Time.newInstance(14,0,0,0),
                Active_Status__c = 'Active',
                Capacity__c = 500
        );
        insert testInstance2;


        Id classRecType = Schema.SObjectType.Summit_Events_Host__c.getRecordTypeInfosByName().get('Class').getRecordTypeId();
        List<Summit_Events_Host__c> testHosts = new List<Summit_Events_Host__c>();
        testHosts.add(new Summit_Events_Host__c(
                Event_Instance__c = testInstance.Id,
                First_Name__c = 'Host1',
                Last_Name__c = 'Host1',
                RecordTypeId = classRecType,
                Preferred_Title__c = 'Mr.',
                Gender__c = 'M',
                Department__c = 'Host Dept 1',
                Course_Name__c = 'Host 1 Course',
                Max_Available__c = 10,
                Location__c = 'TEST LOCATION 1'
        ));

        testHosts.add(new Summit_Events_Host__c(
                Event_Instance__c = testInstance.Id,
                First_Name__c = 'Host2',
                Last_Name__c = 'Host2',
                RecordTypeId = classRecType,
                Preferred_Title__c = 'Mr.',
                Gender__c = 'M',
                Department__c = 'Host Dept 2',
                Course_Name__c = 'Host 2 Course',
                Max_Available__c = 10,
                Assigned__c = 10,
                Location__c = 'TEST LOCATION 2'
        ));
        insert testHosts;

        return testInstance;

    }

    public static Summit_Events_Email__c createTestTransactionEmail(Summit_Events_Instance__c evtInst, String status, String subStatus) {

        // Add email on requeted status
        Summit_Events_Email__c testEvtEmail = new Summit_Events_Email__c(
                Action_Status__c = status,
                Action_Sub_status__c = subStatus,
                BCC_Email__c = 'thad+test@valleyhill.net,thad+test2@valleyhill.net',
                Email_Subject__c = 'TEST EMAIL',
                Email_Content__c = 'Name: {!Registrant_First_Name__c} {!Registrant_Last_Name__c} Event Date: {!Event_Instance_Date_Time_Formatted__c} Event Session: {!Instance_Title__c} Attendees:{!Total_Number_of_Guests__c} Email: {!Registrant_Email__c} High School: {!Registrant_High_School__c}',
                Letterhead_HTML__c = '<html><style> p { margin-top: 0px; margin-bottom: 0px;} </style><body id="body" style=" background-color:#FFFFFF; color:#FFFFFF; " ><center><table cellpadding="0" width="500" cellspacing="0" height="450">  <tr valign="top">    <td id="header" style=" background-color:#FFFFFF; color:#FFFFFF; height:100px; " ><img src="https://c.cs65.visual.force.com/servlet/servlet.ImageServer?id=0150m000000AN8V&oid=00D0m000000Cra6"/>    </td>  </tr><tr valign="top"><td id="accent1" style=" background-color:#FFFFFF; color:#FFFFFF; height:5px; " ></tr><tr valign="top"><td height="300" style=" background-color:#FFFFFF; font-family:arial; font-size:12pt; color:#000000; " ><table border="0" cellpadding="5" width="550" cellspacing="5" height="400"><tr valign="top" height="400"><td id="main" style=" background-color:#FFFFFF; font-family:arial; font-size:12pt; color:#000000; " >[[DONT_DELETE_CONTENT_HERE]]</td></tr></table></td></tr><tr valign="top"><td id="accent2" style=" background-color:#FFFFFF; color:#FFFFFF; height:5px; " ></tr>  <tr valign="top">    <td id="footer" style=" background-color:#FFFFFF; color:#FFFFFF; height:100px; " >    </td>  </tr><tr valign="top"><td id="accent3" style=" background-color:#FFFFFF; color:#FFFFFF; height:5px; " ></tr></table></center></body>',
                Event__c = evtInst.Event__c
        );

        List<OrgWideEmailAddress> oweList = [SELECT Id, Address,DisplayName, IsAllowAllProfiles FROM OrgWideEmailAddress WHERE IsAllowAllProfiles = TRUE];

        if (oweList.size() > 0) {
            testEvtEmail.Org_Email_Id__c = oweList[0].Id;
        }
/*
        SELECT Action_Status__c, Action_Sub_status__c, Event__r.id, Letterhead_HTML__c, Email_Subject__c,
        Email_Content__c, Letterhead_Id__c, Org_Email_Id__c, BCC_Email__c
        FROM Summit_Events_Email__c
        WHERE Event__r.Id IN :affectedIds.values()
                AND Action_status__c != Null
                AND Action_Status__c != '--Inactive--'

                */
        insert testEvtEmail;

        return testEvtEmail;

    }

    public static Contact createContact(String firstName, String preferredFirst, String lastName, String Email, String Zip, String Phone, String DOB, String ClassYear) {

        Account a = new Account(Name = 'Freddy McFlintstone Account Name');
        insert a;

        //Creating a student contact
        Contact student = new Contact(
                firstName = firstName,
                lastName = lastName,
                Email = Email,
                MailingStreet = '123 Flinstone Ave',
                MailingCity = 'Bedrock',
                MailingState = 'MN',
                MailingPostalCode = Zip,
                Phone = Phone,
                Birthdate = Date.valueOf(DOB),
                AccountId = a.Id
        );
        insert student;

        return student;

    }

    public static Summit_Events_Registration__c createEventRegistration(Summit_Events_Instance__c evtI, String firstName, String lastName, String Email, String Zip, String DOB, String ClassYear, Id optionalContactLinkId) {

        Summit_Events_Registration__c testRegistration = new Summit_Events_Registration__c(
                Event__c = evtI.Event__c,
                Event_Instance__c = evtI.Id,
                Registrant_Email__c = Email,
                Registrant_First_Name__c = firstName,
                Registrant_Last_Name__c = lastname,
                Registrant_Zip__c = Zip,
                Registrant_High_School_Code__c = '000000',
                Registrant_Date_of_Birth__c = Date.valueOf(DOB),
                Preferred_Class_Year__c = ClassYear,
                Status__c = 'Started'
        );

        insert testRegistration;

        if (optionalContactLinkId != null) {
            testRegistration.Contact__c = optionalContactLinkId;
            upsert testRegistration;
        }

        List<Summit_Events_Appointments__c> addToRegAppt = new List<Summit_Events_Appointments__c>();
        Integer aptNum = 0;

        //Add athletic appointment
        addToRegAppt.add(new Summit_Events_Appointments__c(
                Event_Registration__c = testRegistration.Id,
                Description__c = 'Athletic Appointment',
                Appointment_Category__c = 'Athletic Visit',
                Appointment_Type__c = 'Men\'s Golf',
                Appointment_Status__c = 'Registered'
        ));

        //Represent all other appointment types
        List<Summit_Events_Appointment_Type__c> newApptTypes = [SELECT Id FROM Summit_Events_Appointment_Type__c WHERE Summit_Events__c = :evtI.Event__c];

        for (Summit_Events_Appointment_Type__c nat : newApptTypes) {
            Summit_Events_Appointments__c addThisAppt = new Summit_Events_Appointments__c (
                    Event_Appointment_Type__c = nat.Id,
                    Event_Registration__c = testRegistration.Id,
                    Client_Created_Appointment__c = true,
                    Room__c = 'TEST ROOM'
            );
            if (math.mod(aptNum, 2) == 0) {
                addThisAppt.Appointment_Status__c = 'Registered';
            } else {
                addThisAppt.Appointment_Status__c = 'Confirmed';
            }

            addToRegAppt.add(addThisAppt);
            aptNum++;
        }
        insert addToRegAppt;

        return testRegistration;

    }

    static Integer s_num = 1;

    public static String getFakeId(Schema.SObjectType sot) {
        String result = String.valueOf(s_num++);
        return sot.getDescribe().getKeyPrefix() +
                '0'.repeat(12 - result.length()) + result;
    }

    public static Summit_Events_Registration__c createEventRegistrationObj(String firstName, String preferredFirst, String lastName, String Email, String Zip, String Phone, String DOB, String ClassYear) {
        Summit_Events_Registration__c eReg = new Summit_Events_Registration__c(
                Registrant_First_Name__c = firstName,
                Registrant_Preferred_First_Name__c = preferredFirst,
                Registrant_Last_Name__c = lastName,
                Registrant_Email__c = Email,
                Registrant_Zip__c = Zip,
                Registrant_Phone__c = Phone,
                Preferred_Class_Year__c = ClassYear
        );
        if (String.isNotBlank(DOB)) {
            eReg.Registrant_Date_of_Birth__c = Date.valueOf(DOB);
        }
        return eReg;
    }

}