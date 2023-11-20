final String _baseUrl = 'https://ismartlogin.cityvariety.com/';

class Server {
  static String url = _baseUrl;
  //------------
  //
  //--- OTP-----
  String postOtp = _baseUrl + 'member/setOtp';
  String getCheckOtp = _baseUrl + 'member/checkOtp';
  //--- Member -----
  String postMember = _baseUrl + 'member/postMember';
  String postAvatarMember = _baseUrl + 'member/uploadAvatarMember';
  String getMember = _baseUrl + 'member/getMember';
  String updateMember = _baseUrl + 'member/updateMember';
  String updateNewMemberInOrg = _baseUrl + 'member/updateMemberToOrg';
  String getCheckMember = _baseUrl + 'member/getCheckMember';
  String updateMemberPassword = _baseUrl + 'member/updateMemberPassword';
  String getMemberByUsername = _baseUrl + 'member/getMemberByUsername';
  // ---องค์กร
  String getOrg = _baseUrl + 'organization/getOrg';

  //---- สรุป  -- การทำงาน
  String getSummaryAllDay = _baseUrl + "summary/attendSummaryList";
  String getSummaryToDay = _baseUrl + "summary/attendDailyList";
  String getSummaryMeList = _baseUrl + "summary/attendList";
  //----- Login Logout
  String getAttandCheck = _baseUrl + "attend";
  String getAttandHistory = _baseUrl + "attend/attendHistory";
  String postAttandStart = _baseUrl + "attend/attendStart";
  String updateAttandStart = _baseUrl + "attend/updateAttendStart";
  String postAttandEnd = _baseUrl + "attend/attendEnd";
  String postAttandUploadImages = _baseUrl + "attend/appUploadFile";
  //---- ทำงานนอกสถานที่
  String getAttandCheckOutside = _baseUrl + "attend/attandCheckOutside";
  String postAttandOutsideStart = _baseUrl + "attend/attendOutsideStart";
  String postAttandOutsideEnd = _baseUrl + "attend/attendOutsideEnd";
  //------ รหัสเชิญ
  String getKeyInvite = _baseUrl + 'protectapp/protect';
  //------ ติดต่อผู้พัฒนา
  String postContact = _baseUrl + 'contactus/postContact';
  //------ Faq
  String getFaq = _baseUrl + 'faq/getFaq';

  //--------------------
  //----สำหรับ ADMIN-----
  //--------------------
  // -- * สมาชิก --------
  String getMemberManage = _baseUrl + 'member/getAllMember';
  String updateMemberStatusManage = _baseUrl + 'member/updateMemberStatus';
  String getMemberRelationship = _baseUrl + 'member/getMemberRelationship';

  String userDelete = _baseUrl + 'member/userDelete';
  // -- * เวลาทำงาน --------
  String getTimeManage = _baseUrl + 'manage/getTime';
  String postTimeManage = _baseUrl + 'manage/postTime';

  // -- * สาขา --------
  String getDepartmentManage = _baseUrl + 'manage/getDepartment';
  String postDepartmentManage = _baseUrl + 'manage/postDepartment';
  String updateSeqOrg = _baseUrl + 'manage/updateSeqOrg';
  String updateHistoryStatus = _baseUrl + 'manage/updateHistoryStatus';
  String updateNotiStatus = _baseUrl + 'manage/updateNotiStatus';

  // -- * องค์กร -------
  String postOrg = _baseUrl + 'manage/postOrg';
  String getOrgAdmin = _baseUrl + 'manage/getOrg';
  String updateOrgSwitch = _baseUrl + 'manage/updateSwitchOrg';
  String updateOrgSuspend = _baseUrl + 'manage/updateSuspendOrg'; // ระงับบริษัท

  // -- * ลางาน -------
  String insertInfoLeave = _baseUrl + 'manage/insertInfoLeave';
  String getCateLeave = _baseUrl + 'manage/getCateLeave';
  String getListLeave = _baseUrl + 'manage/getListLeave';
  String getDetailLeave = _baseUrl + 'manage/getDetailLeave';
  String postupdateStatusLeave = _baseUrl + 'manage/updateStatusLeave';
  String getListLeaveWait = _baseUrl + 'manage/getListLeaveWait';
  String getBadgeLeave = _baseUrl + 'manage/getBadgeLeave';
  String getListHistoryLeave = _baseUrl + 'manage/getListHistoryLeave';
  String getCateLeaveOrg = _baseUrl + 'manage/getCateLeaveOrg';
  String getCateLeaveDetail = _baseUrl + 'manage/getCateLeaveDetail';
  String insertCateLeave = _baseUrl + 'manage/insertCateLeave';
  String updateCateLeave = _baseUrl + 'manage/updateCateLeave';
  String getListNotiLeave = _baseUrl + 'manage/getListNotiLeave';

  // -- * ตั้งค่า -------
  String checkAppVersion = _baseUrl + 'manage/checkAppVersion';
  String getTimeInServer = _baseUrl + 'manage/getTimeInServer';

  //---- *switch protect
  String getProtectSwitch = _baseUrl + 'protectapp/protectSwitch';
  Server() : super();
}
