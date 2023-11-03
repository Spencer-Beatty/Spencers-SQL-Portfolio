//NAME: Spencer Beatty
//Id: 260898452
import javax.swing.plaf.nimbus.State;
import java.sql.*;
import java.util.ArrayList;
import java.util.InputMismatchException;
import java.util.Scanner;
import java.time.format.DateTimeFormatter;
import java.time.LocalDateTime;

public class GoBabbyApp {
    static int sqlCode=0;      // Variable to hold SQLCODE
    static String sqlState="00000";  // Variable to hold SQLSTATE
    static ArrayList<Statement>statementList = new ArrayList<Statement>();
    static Connection con;

    public static void main ( String [ ] args ) throws SQLException {
        // Driver set up and database connection


        try {
            DriverManager.registerDriver(new com.ibm.db2.jcc.DB2Driver());
        } catch (Exception cnfe) {
            System.out.println("Class not found");
        }

        String url = "jdbc:db2://winter2022-comp421.cs.mcgill.ca:50000/cs421";

        String your_userid = "";
        String your_password = "";

        if (your_userid == null && (your_userid = System.getenv("SOCSUSER")) == null) {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }
        if (your_password == null && (your_password = System.getenv("SOCSPASSWD")) == null) {
            System.err.println("Error!! do not have a password to connect to the database!");
            System.exit(1);
        }
        con = DriverManager.getConnection(url, your_userid, your_password);
        Statement statement = con.createStatement();
        statementList.add(statement);
        String maxTid = ("SELECT Max(tid) tid FROM Tests");
        PreparedStatement prepmid = con.prepareStatement("SELECT practid FROM " +
                "Midwife" + " WHERE practid = ?");
        statementList.add(prepmid);
        // atime, midpractid, P or B name of mother, qid
        PreparedStatement prepapp = con.prepareStatement("SELECT atime, Pos, mname, Mother.qid qid, moms.pregnum pregNum, moms.cid cid, moms.adate adate, aid\n" +
                        "FROM Mother,(SELECT atime, 'P' Pos, qid, a.pregnum, a.cid, a.adate, aid\n" +
                        "             FROM Couple, (SELECT atime, a.cid, p.pregnum, a.adate, aid\n" +
                        "                           FROM (SELECT *\n" +
                        "                                 FROM Appointment\n" +
                        "                                 WHERE adate = ?)a, Pregnancy p\n" +
                        "                           WHERE practid = ? AND p.pregnum = a.pregnum AND p.cid = a.cid AND practid = ppractid) a\n" +
                        "             WHERE a.cid = Couple.cid\n" +
                        "        UNION\n" +
                        "             SELECT atime, 'B' Pos, qid, a.pregnum, a.cid, a.adate, aid\n" +
                        "             FROM Couple, (SELECT atime, a.cid, p.pregnum,a.adate, aid\n" +
                        "                   FROM (SELECT *\n" +
                        "                         FROM Appointment\n" +
                        "                         WHERE adate = ?)a, Pregnancy p\n" +
                        "                   WHERE practid = ? AND p.pregnum = a.pregnum AND p.cid = a.cid AND practid = bpractid) a\n" +
                        "             WHERE a.cid = Couple.cid) moms\n" +
                        "WHERE Mother.qid = moms.qid\n" +
                        "ORDER BY atime");
        statementList.add(prepapp);
        PreparedStatement prepRevNotes = con.prepareStatement("SELECT adate, ntime, note\n" +
                "from Appointment a, Notes\n" +
                "WHERE a.adate = ? AND a.cid = ? AND a.pregnum = ? AND a.aid = Notes.aid\n" +
                "ORDER BY adate DESC , ntime ASC;");
        statementList.add(prepRevNotes);

        PreparedStatement prepTestResults = con.prepareStatement("SELECT tDate, testtype, labresult\n" +
                "FROM (SELECT labdate tDate, testtype, labresult, pregnum, cid\n" +
                "FROM Tests\n" +
                "UNION\n" +
                "SELECT prescdate tDate, testtype, labresult, pregnum, cid\n" +
                "FROM Tests\n" +
                "UNION\n" +
                "SELECT sampdate tDate, testtype, labresult, pregnum, cid\n" +
                "FROM Tests" +
                ") allTests\n" +
                "WHERE cid = ? AND pregnum = ? AND tDate is NOT NULL \n" +
                "ORDER BY 1 DESC;\n");
        statementList.add(prepTestResults);

        PreparedStatement prepAddNote = con.prepareStatement("INSERT INTO Notes (ntime, aid, note) VALUES (?, ?, ?)");
        statementList.add(prepAddNote);

        PreparedStatement prepAddTest = con.prepareStatement("INSERT INTO Tests (tid, testtype, prescdate, sampdate, labdate, labresult, practid, pregnum, cid, bid, techid) \n"
                +"VALUES (?,?,?,?,NULL,NULL,?,?,?,NULL,1)");
        statementList.add(prepAddTest);
        //PROGRAM STARTS HERE
        //-----------------
        //-----------------
        //  scanning
        // loop to ensure a practid id is set.
        while(true){
            int inputPractid = applicationStartUp();

            prepmid.setInt(1, inputPractid);
            java.sql.ResultSet rs = prepmid.executeQuery();

            //entering case where practid is valid

            if (checkPractid(inputPractid, rs)) {
                //loop to enter the proper date
                while(true) {

                    Date inputDate = promptInputDate();

                    //prompting midwife for enter date for appointment list
                    prepapp.setDate(1, inputDate);
                    prepapp.setInt(2, inputPractid);
                    prepapp.setDate(3, inputDate);
                    prepapp.setInt(4, inputPractid);
                    rs = prepapp.executeQuery();
                    int counter = displayAppointmentData(rs);
                    boolean dateIsValid = true;
                    while(dateIsValid) {
                        if (counter > 0) {
                            int displayedNumber = enterAppointment(counter);
                            if (displayedNumber == -1) {
                                // this means d was hit
                                dateIsValid = false;
                                continue;
                            }
                            rs = prepapp.executeQuery();
                            RecordHolder selectedRecord = extractRecord(rs, displayedNumber);
                            //enter the while loop for options menu
                            while (true) {
                                int chosenOption = displaySelectedRecordAndScan(selectedRecord);
                                if (chosenOption == -1) {
                                    // this means d was hit
                                    System.out.println("at d");
                                    dateIsValid = false;
                                    break;
                                } else if (chosenOption == 1) {
                                    prepRevNotes.setDate(1, inputDate);
                                    prepRevNotes.setInt(2, selectedRecord.cid);
                                    prepRevNotes.setInt(3, selectedRecord.pregNum);
                                    rs = prepRevNotes.executeQuery();
                                    displayRevNotes(rs);
                                } else if (chosenOption == 2) {
                                    prepTestResults.setInt(1, selectedRecord.cid);
                                    prepTestResults.setInt(2, selectedRecord.pregNum);
                                    rs = prepTestResults.executeQuery();
                                    displayTestResults(rs);
                                } else if (chosenOption == 3) {
                                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("HH:mm");
                                    LocalDateTime now = LocalDateTime.now();
                                    String time = dtf.format(now);
                                    prepAddNote.setString(1,time);
                                    prepAddNote.setInt(2,selectedRecord.aid);
                                    prepAddNote.setString(3,getNote());

                                    prepAddNote.executeUpdate();
                                } else if (chosenOption == 4) {
                                    //tid,testtype,prescdate,sampdate,practid,pregnum,cid
                                    rs = statement.executeQuery(maxTid);
                                    prepAddTest.setInt(1,generateUniqueTestid(rs));
                                    prepAddTest.setString(2,getTestType());

                                    DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd");


                                    LocalDateTime now = LocalDateTime.now();
                                    String stringDate = dtf.format(now);

                                    try {
                                        Date currentDate = java.sql.Date.valueOf(stringDate);

                                        prepAddTest.setDate(3, currentDate);
                                        prepAddTest.setDate(4, currentDate);
                                    }catch(IllegalArgumentException e){
                                        System.out.println(e.getMessage());
                                    }

                                    prepAddTest.setInt(5,inputPractid);
                                    prepAddTest.setInt(6,selectedRecord.pregNum);
                                    prepAddTest.setInt(7,selectedRecord.cid);

                                    try {
                                        prepAddTest.executeUpdate();
                                    }catch(SQLException e){
                                        System.out.println(e.getMessage());
                                    }

                                } else if (chosenOption == 5) {
                                    rs = prepapp.executeQuery();
                                    counter = displayAppointmentData(rs);
                                    break;
                                }

                            }
                        } else {
                            System.out.println("No entries for this date");
                            dateIsValid =false;
                        }
                    }
                }

            }
        }
    }

    private static int applicationStartUp(){
        boolean practidSet = false;
        int inputPractid = -1;
        while(!practidSet){
            try{
                Scanner sc = new Scanner(System.in);
                System.out.print("Please enter your practitioner id [E] to exit: ");
                String input = sc.next();
                if(input.equals("e") || input.equals("E")){
                    System.out.println("exiting program");
                    terminateExecution();
                }

                inputPractid = Integer.parseInt(input);
                practidSet = true;
            }catch(NumberFormatException e){
                System.out.println("input type for practid was incorrect, please try again");
            }
        }
        return inputPractid;
    }
    static int generateUniqueTestid(java.sql.ResultSet rs){
        try{
            while(rs.next()) {
                return rs.getInt("tid") + 1;
            }
        }catch(SQLException e){
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
            //update
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            //some problem
            System.out.println("Problem generating unique test id");
            terminateExecution();

        }
        return -1;
    }

    static String getNote(){
            Scanner sc = new Scanner(System.in);
            System.out.println("Please type your observation: ");
            String input = sc.nextLine();
            return input;
    }

    static String getTestType(){
        Scanner sc = new Scanner(System.in);
        System.out.println("Please enter type of test: ");
        String input = sc.nextLine();
        return input;
    }

    static Date promptInputDate(){
        try {
            Scanner sc = new Scanner(System.in);
            System.out.print("Please enter the date for the appointment you would like to work on, [E] to exit: ");
            String input = sc.next();
            if (input.equals("e") || input.equals("E")) {
                System.out.println("exiting program");
                terminateExecution();
            }

            Date inputDate = java.sql.Date.valueOf(input);
            return inputDate;


        }catch(IllegalArgumentException e){
            System.out.println("the input format for that date was incorrect, please try again");
            System.out.println("Format for appointment (2022-03-19)");
        }

        return null;
    }

    static private int enterAppointment(int counter) {
        while (true) {
            try {
                Scanner sc = new Scanner(System.in);
                System.out.println("Enter the appointment you would like to work on.");
                System.out.println("[E] to exit [D] to go back to another date :");
                String input = sc.next();
                if (input.equals("e") || input.equals("E")) {
                    System.out.println("exiting program");
                    terminateExecution();
                }
                if (input.equals("d") || input.equals("D")) {
                    return -1; // special input case for D
                }
                int inputInt = Integer.parseInt(input);
                if(inputInt>counter || inputInt<1){
                    System.out.println("Appointment number " + inputInt + " not avaliable");
                    System.out.println("Please select another number\n");
                    continue;
                }
                return inputInt;

            } catch (NumberFormatException e) {
                System.out.println("input type for appointment was incorrect, please try again");
            }
        }
    }

    static private void displayRevNotes(java.sql.ResultSet rs)
    {
        try{
            int counter = 0;
            while(rs.next()){
                counter++;
                Date adate = rs.getDate("adate");
                String ntime = rs.getString("ntime");
                if(ntime.length()==4){
                    ntime+=" ";
                }
                String note = rs.getString("note");
                System.out.println(adate+" "+ntime+" "+note);
            }
            if(counter==0){
                System.out.println("no notes to display");
            }
        }catch(SQLException e){
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
            //update
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            //some problem
            System.out.println(e.getMessage());
        }
    }

    static private void displayTestResults(java.sql.ResultSet rs){
        try{
            int counter = 0;
            while(rs.next()){
                counter++;
                Date tdate = rs.getDate("tdate");
                String testtype = rs.getString("testtype");
                String labresult = rs.getString("labresult");
                testtype = "["+testtype+"]";
                if(labresult!=null){
                    if(labresult.length()>50){
                        labresult = labresult.substring(0,49);
                    }
                    System.out.println(tdate+" "+testtype+" "+labresult);
                }else{
                    System.out.println(tdate+" "+testtype+" PENDING");
                }


            }
            if(counter==0){
                System.out.println("no tests to display");
            }
        }catch(SQLException e){
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
            //update
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            //some problem
            System.out.println(e.getMessage());
        }
    }

    static private RecordHolder extractRecord(java.sql.ResultSet rs, int count){
        try{
            int counter = 0;
            while(rs.next()){
                counter++;
                if(counter ==count){
                    String atime = rs.getString("aTime");
                    if(atime.length()==4){
                        atime+=" ";
                    }
                    String midDesignation = rs.getString("pos");
                    String nameOfMother = rs.getString("mname");
                    int qid = rs.getInt("qid");
                    int pregNum = rs.getInt("pregNum");
                    int cid = rs.getInt("cid");
                    Date adate = rs.getDate("adate");
                    int aid = rs.getInt("aid");
                    RecordHolder selectedRecord = new RecordHolder(atime,midDesignation,nameOfMother,qid,pregNum,cid,adate,aid);
                    return selectedRecord;
                }

            }
            return null;
        }catch(SQLException e){
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
            //update
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            //some problem
            System.out.println(e.getMessage());
            return null;
        }
    }

    static private int displaySelectedRecordAndScan(RecordHolder r){
        while(true) {
            try {
                System.out.println("For " + r.mName + " " + r.motherQid + "\n"
                +"\n1. Review notes"
                +"\n2. Review tests"
                +"\n3. Add a note"
                +"\n4. Prescribe a test"
                +"\n5. Go back to appointments. \n");
                Scanner sc = new Scanner(System.in);
                System.out.println("Enter your choice: ");
                String input = sc.next();
                if(input.equals("e")||input.equals("E")){
                    System.out.println("exiting program");
                    terminateExecution();
                }if(input.equals("d")||input.equals(("D"))){
                    return -1;
                }
                int inputInt = Integer.parseInt(input);
                if(inputInt > 5|| inputInt < 1){
                    System.out.println("Number "+inputInt+ " is not a valid option, please try again");
                    continue;
                }
                return inputInt;

            }catch (NumberFormatException e){
                System.out.println("input entered was not a valid number, please try again");
            }
        }

    }

    static private int displayAppointmentData(java.sql.ResultSet rs){
        try{
            int counter = 0;
            while(rs.next()){
                counter++;
                //print (i:     atime   primary or backup   name of mother      qid)
                String atime = rs.getString("aTime");
                if(atime.length()==4){
                    atime+=" ";
                }
                String midDesignation = rs.getString("pos");
                String nameOfMother = rs.getString("mname");
                int qid = rs.getInt("qid");
            System.out.println(counter+":   "+atime+" "+midDesignation+" "
            +nameOfMother+" "+qid);
            }
            System.out.print("\n");
            return counter;
        }catch (SQLException e){
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
            //update
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            //some problem
            System.out.println(e);
            return -1;
        }
    }

    static private boolean checkPractid(int practid, java.sql.ResultSet rs){
        try
        {
            while(rs.next()){
                int tblPractid = rs.getInt("practid");


                if(tblPractid==practid){
                    System.out.println("practid: "+practid+" accepted");
                    return true;
                }
            }
        }catch (SQLException e) {
            sqlCode = e.getErrorCode(); // Get SQLCODE
            sqlState = e.getSQLState(); // Get SQLSTATE
            //update
            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println("Your input practitioners id was not found in the database");
        }
        System.out.println("Your input practitioners id was not found in the database");
        return false;
    }

    static void terminateExecution(){
        try {
            con.close();
            for (Statement s : statementList) {
                s.close();
            }
            System.exit(1);
        }catch (SQLException e)
        {
            sqlState = e.getSQLState();
            sqlCode = e.getErrorCode();

            System.out.println("Code: " + sqlCode + "  sqlState: " + sqlState);
            System.out.println("Connections and statements had trouble closing");
            System.exit(4);
        }
    }

    static class RecordHolder{
        //"SELECT atime, Pos, mname, Mother.qid, moms.pregnum, moms.cid"
        String aTime = "";
        String pos = "";
        String mName = "";
        int motherQid;
        int pregNum;
        int cid;
        Date adate;
        int aid;

        public RecordHolder(String pATime, String pPos, String pMName, int pMotherQid, int pPregNum, int pCid, Date pdate, int paid){
            aTime +=pATime;
            pos +=pPos;
            mName += pMName;
            motherQid = pMotherQid;
            pregNum = pPregNum;
            cid = pCid;
            adate = pdate;
            aid = paid;

        }
    }


}
