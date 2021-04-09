<%-- 
    Document   : Repot
    Created on : Feb 24, 2020, 5:27:19 PM
    Author     : aris
--%>

<%@page import="java.util.Calendar"%>
<%@page import="java.util.Locale"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="javax.xml.bind.DatatypeConverter"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import ="Conection.MyConection" %>
<% 
Object id = session.getAttribute("username");
Object Cread = session.getAttribute("Cred");
Object bidang = session.getAttribute("bidang");
Object jabatan = session.getAttribute("jabatan");
Object level = session.getAttribute("level");
if (id == null || id.toString().trim().equals("") || level == null || level.toString().trim().equals("") || !level.toString().equals("a")) {
%>
<script type="text/javascript">
    alert('Access Denied!');
    window.location.href = "login";
</script>
<%
} else {
String urlLoc = "report";
%>
<!DOCTYPE html>
<html>
    <head>
        <%@include file = "../../Header/Header.jsp" %>
        <style> 
        img {
                max-width: 100%;
                height: auto;
                width: auto\9; /* ie8 */
            }
        </style>
    </head>
    <body id="page-top">
        <!-- Page Wrapper -->
        <div id="wrapper">
            <!-- Sidebar -->
            <%@include file = "../../Sidebar/Sidebar.jsp" %>
            <!-- End of Sidebar -->
            <!-- Content Wrapper -->
            <div id="content-wrapper" class="d-flex flex-column">
                <!-- Main Content -->
                <div id="content">
                    <!-- Topbar -->
                    <!-- Topbar Navbar -->
                    <%@include  file = "../../Navbar/Navbar.jsp" %>
                    <!-- End of Topbar -->

                    <!-- Begin Page Content -->
                    <div class="container-fluid">

                        <!-- Content Row -->
                        <div class="d-sm-flex align-items-center justify-content-between mb-4">
                            <h1 class="h3 mb-0 text-gray-800">Report</h1>
                        </div>
                        <!-- <div class="card shadow mb-4"> -->
                        <!-- aris -->     
                        <div class="col-lg-12 mb-3">
                                <!-- Illustrations -->
                                <!-- Form Add-->
                                <!-- form -->
                                <div class="card mb-3">
                                    <div class="card-header">
                                        <a href="home" class="back"><i class="fas fa-arrow-left"></i> Back</a>
                                    </div>

                                    <div class="card-body">                                        
                                        <form action="reportcapaian" method="post">
                                            <!-- enctype="multipart/form-data" -->
                                            
                                          <div class="form-group">
                                                 <label class="col-lg-4 control-label">Nama Pegawai: </label>
                                                 <div class="col-lg-12">
                                                     <select style = "border: 1px solid #d1d3e2; border-radius: .35rem;" class="selectpicker form-control formq" name="user" data-live-search="true" required>
                                                            <option value=""> No Selected </option>
                                                            <%
                                                                MyConection conn = new MyConection();
                                                                Connection conn1 = conn.getKoneksi();
                                                                Statement user = conn1.createStatement();
                                                                String users = "select * from public.login where kode_credential !='P' and kode_credential !='a' ";                                                               
                                                                ResultSet myuser = user.executeQuery(users);
                                                                while (myuser.next()) {                                                                   
                                                            %>
                                                            <option value="<%= myuser.getString("username")%>"><%= myuser.getString("alias")%></option>
                                                            <% } %>
                                                        </select>
                                                 </div>
                                             </div>
                                            <div class="form-group">
                                                 <label class="col-lg-4 control-label">Bulan: </label>
                                                 <div class="col-lg-12">
                                                     <select style = "border: 1px solid #d1d3e2; border-radius: .35rem;" class="selectpicker form-control formq" name="month" data-live-search="true" required>
                                                            <option value=""> No Selected </option>
                                                            <%
                                                                int i = 0;
                                                                String[] monthNames = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"};
                                                                for(i=0;i<monthNames.length;i++) {                                                                   
                                                            %>
                                                            <option value="<%out.print(i+1);%>"><%out.print(monthNames[i]);%></option>
                                                            <% }
                                                            %>
                                                        </select>
                                                 </div>
                                             </div>
                                            <div class="form-group">                                                
                                                 <div class="col-lg-12">
                                                     <div >
                                                          <button type="submit" class="btn btn-primary col-md-offset-5" id="btn-submit" name="ss" value ="true"> SUBMIT </button>
                                                     </div>
                                                 </div>
                                             </div> 
                                           
                                        </form>	

                                    </div>

                                    <div class="card-footer small text-muted">
                                        * required fields
                                    </div>
                                </div>
                                <!-- end form 
                                <!--end Form Add-->
                            </div>
                        <!-- aris -->
                        <!-- Show -->     
                        <div class="col-lg-12 mb-3">                                
                                <!-- Form Add-->
                                <!-- form -->
                                <div class="card mb-3">
<!--                                    <div class="card-header">
                                        <a href="home" class="back"><i class="fas fa-arrow-left"></i> Cetak</a>
                                    </div>-->
                                    <div class="card-body">                                        
                                        <%
                                            Calendar now = Calendar.getInstance();
                                                int year = now.get(Calendar.YEAR);
                                                int month = now.get(Calendar.MONTH) + 1; // Note: zero based!
                                                int day = now.get(Calendar.DAY_OF_MONTH);
                                                int hour = now.get(Calendar.HOUR_OF_DAY);
                                                int minute = now.get(Calendar.MINUTE);
                                                int millis = now.get(Calendar.MILLISECOND);
                                                int second = now.get(Calendar.SECOND);
                                            boolean ss = Boolean.parseBoolean(request.getParameter("ss"));
                                           System.err.println("ss "+ss);
                                            if (ss){
                                            String first = request.getParameter("user");
                                            System.out.println("First "+first);
                                            String last = request.getParameter("month");
                                            System.out.println("last "+last);
                                            
                                                Statement com1 = conn1.createStatement();
                                                String Report = "Select a.aktivitas, a.tanggal_aktivitas, a.note, sum(a.durasi) as counter, a.durasi, a.approve, a.detail, a.nip, a.berkas_pendukung, "
                                                        + "t.nama_aktifitas as tupoksi, k.nama_aktifitas as kegiatan, "
                                                        + "b.nama, k.kode as kodekegiatan, t.kode as kodetupoksi from employee.aktivitas as a "
                                                        + "Join employee.biodata as b on a.nik_employee = b.nik "
                                                        + "Join master.kegiatan as k on a.tugas = k.kode "
                                                        + "Join master.tupoksi as t on a.kegiatan = t.kode "
//                                                        + "WHERE a.nip = '" + id + "' and nik_employee ='"+first+"' and EXTRACT(MONTH FROM a.tanggal_aktivitas) ='"+last+"' group by a.aktivitas, "
//                                                        + "WHERE a.nik_employee ='"+first+"' and a.approve = 'Disetujui' and EXTRACT(MONTH FROM a.tanggal_aktivitas) ='"+last+"' group by a.aktivitas, "
                                                        + "WHERE a.nik_employee ='"+first+"' and a.approve = 'Disetujui' and EXTRACT(MONTH FROM a.tanggal_aktivitas) ='"+last+"' and EXTRACT(Year FROM a.tanggal_aktivitas) ='"+year+"' group by a.aktivitas, "
                                                        + "a.tanggal_aktivitas, a.note, a.durasi, a.approve, a.detail, a.nip, a.berkas_pendukung, t.nama_aktifitas, k.nama_aktifitas, b.nama, k.kode , t.kode";
                                                ResultSet report = com1.executeQuery(Report);
                                                System.out.println("Activitas Report " + Report);                                                
                                        %>
                                        <div class="table-responsive">
                                            <table class="table table-hover" id="dataTable" width="100%" cellspacing="0">
                                                <thead>
                                                    <tr>
                                                        <th>Nama</th>
                                                        <th>Bulan</th>
                                                        <th>Target</th>
                                                        <th>Disetujui</th>
                                                        <th>Belum Disetujui</th>
                                                        <th>Capaian ss</th>                                                        
                                                    </tr>
                                                </thead>
                                                <tbody>  
                                                    <% String tgl = "";
                                                       String tupoksi = "";
                                                       String detail = "";
                                                       Integer durasi = 0;
                                                       Integer counter = 0;
                                                       String nama = "";
                                                       String approve = "";                                                       
                                                        while (report.next()) {
                                                        tgl = monthNames.toString();
                                                        tupoksi = report.getString("tupoksi");
                                                        detail = report.getString("detail");
                                                        durasi = Integer.parseInt(report.getString(5));
                                                        nama = report.getString("nama");
                                                        approve =report.getString("approve");                                                       
                                                   
                                                        counter = counter + durasi;
                                                        }
                                                    %>
                                                    <tr>
                                                        <td><% if(nama == null || nama.isEmpty()) {
                                                            
                                                            Statement usr = conn1.createStatement();
                                                            String namauser = "SELECT nama from employee.biodata where nik = '"+first+"'";
                                                            System.out.println("namauser "+ namauser);
                                                            ResultSet namauser1 = usr.executeQuery(namauser);
                                                            while (namauser1.next()) {
                                                                nama = namauser1.getString("nama");
                                                            }
                                                            out.print(nama);
                                                        } else {
                                                             out.print(nama);} %></td>
                                                         <td><%
                                                             switch(Integer.parseInt(last)) {
                                                                case 1:
                                                                   out.println("Januari");
                                                                   break;
                                                                 case 2:
                                                                   out.println("Pebruari");
                                                                   break;
                                                                case 3:
                                                                   out.println("Maret");
                                                                   break;
                                                                case 4:
                                                                   out.println("April");
                                                                   break;
                                                                case 5:
                                                                   out.println("Mei");
                                                                   break;
                                                                case 6:
                                                                   out.println("Juni");
                                                                   break;
                                                                case 7:
                                                                   out.println("Juli");
                                                                   break;
                                                                case 8:
                                                                   out.println("Agustus");
                                                                   break;
                                                                case 9:
                                                                   out.println("September");
                                                                   break;
                                                                case 10:
                                                                   out.println("Oktober");
                                                                   break;
                                                                case 11:
                                                                   out.println("November");
                                                                   break;
                                                                default:
                                                                   out.println("Desember");
                                                             }
                                                             %></td>
                                                          <td><% 
                                                              int time = 8;
                                                              int second = 60;
                                                            switch(Integer.parseInt(last)) {
                                                                case 1:
                                                                   int efective = 22;
                                                                   int jan = time*second*efective;
//                                                                   capaian = (jan * counter)/100;
                                                                   out.println(jan);
                                                                   break;
                                                                 case 2:
                                                                   efective = 20;
                                                                   int feb = time*second*efective;
//                                                                   capaian = (feb * counter)/100;
                                                                   out.println(feb);
                                                                   break;
                                                                case 3:
                                                                   efective = 21;
                                                                   int mar = time*second*efective; 
//                                                                   capaian = (mar * counter)/100;
                                                                   out.println(mar);
                                                                   break;
                                                                case 4:
                                                                   efective = 22;
                                                                   int apr = time*second*efective;
//                                                                   capaian = (apr * counter)/100;
                                                                   out.println(apr);
                                                                   break;
                                                                case 5:
                                                                   efective = 12;
                                                                   int mei = time*second*efective;
//                                                                   capaian = (mei * counter)/100;
                                                                   out.println(mei);
                                                                   break;
                                                                case 6:
                                                                   efective = 21;
                                                                   int juni = time*second*efective;
//                                                                   capaian = (juni * counter)/100;
                                                                   out.println(juni);
                                                                   break;
                                                                case 7:
                                                                   efective = 22;
                                                                   int juli = time*second*efective;
//                                                                   capaian = (juli * counter)/100;
                                                                   out.println(juli);
                                                                   break;
                                                                case 8:
                                                                   efective = 18;
                                                                   int ags = time*second*efective;
//                                                                   capaian = (ags * counter)/100;
                                                                   out.println(ags);
                                                                   break;
                                                                case 9:
                                                                   efective = 22;
                                                                   int sept = time*second*efective;
//                                                                   capaian = (sept * counter)/100;
                                                                   out.println(sept);
                                                                   break;
                                                                case 10:
                                                                   efective = 20;
                                                                   int okt = time*second*efective;
//                                                                   capaian = (okt * counter)/100;
                                                                   out.println(okt);
                                                                   break;
                                                                case 11:
                                                                   efective = 21;
                                                                   int nov = time*second*efective;
//                                                                   capaian = (nov * counter)/100;
                                                                   out.println(nov);
                                                                   break;
                                                                default:
                                                                   efective = 21;
                                                                   int des = time*second*efective;
//                                                                   capaian = (des * counter)/100;
                                                                   out.println(des);
                                                             }
                                                              %></td>
                                                        <td><% out.print(counter); %></td>
                                                        <td><%
                                                            String count = " ";
                                                            Statement appr = conn1.createStatement();
                                                            String notapprove = "SELECT SUM(durasi) as notapproved from employee.aktivitas Where approve = 'Belum Disetujui' and nik_employee = '"+first+"' "
                                                                    + "and EXTRACT(MONTH FROM tanggal_aktivitas) ='"+last+"'"; 
                                                            System.out.println("notapprove "+notapprove);
                                                            ResultSet notapprove1 = appr.executeQuery(notapprove);
                                                            while (notapprove1.next()) {
                                                                count = notapprove1.getString("notapproved");
                                                            }
                                                            if(count == null){
                                                                out.print("0");
                                                            } else {
                                                            out.print(count); } %></td>
                                                        <td><%
                                                            double capaian;
                                                            switch(Integer.parseInt(last)) {
                                                                case 1:
                                                                   int efective = 22;
                                                                   double jan = time*second*efective;
                                                                   capaian = (counter/jan)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                 case 2:
                                                                   efective = 20;
                                                                   double feb = time*second*efective;
                                                                   capaian = (counter/feb)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 3:
                                                                   efective = 21;
                                                                   double mar = time*second*efective; 
                                                                   capaian = (counter/mar)*100;
//                                                                   capaian = Double.parseDouble(new DecimalFormat("##.##").format(capaian));
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   System.out.println(" Capaian "+capaian);
                                                                   break;
                                                                case 4:
                                                                   efective = 22;
                                                                   double apr = time*second*efective;
                                                                   capaian = (counter/apr)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 5:
                                                                   efective = 12;
                                                                   double mei = time*second*efective;
                                                                   capaian = (counter/mei)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 6:
                                                                   efective = 21;
                                                                   double juni = time*second*efective;
                                                                   capaian = (counter/juni)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 7:
                                                                   efective = 22;
                                                                   double juli = time*second*efective;
                                                                   capaian = (counter/juli)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 8:
                                                                   efective = 18;
                                                                   double ags = time*second*efective;
                                                                   capaian = (counter/ags)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 9:
                                                                   efective = 22;
                                                                   double sept = time*second*efective;
                                                                   capaian = (counter/sept)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 10:
                                                                   efective = 20;
                                                                   double okt = time*second*efective;
                                                                   capaian = (counter/okt)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                case 11:
                                                                   efective = 21;
                                                                   double nov = time*second*efective;
                                                                   capaian = (counter/nov)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                                   break;
                                                                default:
                                                                   efective = 21;
                                                                   double des = time*second*efective;
                                                                   capaian = (counter/des)*100;
                                                                   out.println(String.format(Locale.US,"%.2f",capaian)+" %");
                                                             } %></td>
                                                    </tr>
                                                </tbody>
                                            </table>                                       
                                        </div>
                                    </div>
                                    <%  }
                                    %>
                                </div>
                                <!-- end form 
                                <!--end Form Add-->
                            </div>
                        <!-- Show -->
                        <!-- End Content Row -->
                    </div>
                   
                    <!-- /.container-fluid -->

                </div>
                <!-- End of Main Content -->
                <%@include file = "../../Footer/Footer.jsp" %>
                <script>
                    $(document).ready(function() {
                        var table = $('#dataTable').DataTable( {
                            lengthChange: false,
                            buttons: [ 'copy', 'excel', 'pdf', 'colvis' ]
                        } );

                        table.buttons().container()
                            .appendTo( '#example_wrapper .col-md-6:eq(0)' );
                    } );
                    </script>
            </div>
    </body>
</html>

<% } %>