final String _baseUrl = 'http://ismartlogin.cityvariety.com/';

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
  // -- * เวลาทำงาน --------
  String getTimeManage = _baseUrl + 'manage/getTime';
  String postTimeManage = _baseUrl + 'manage/postTime';
  // -- * สาขา --------
  String getDepartmentManage = _baseUrl + 'manage/getDepartment';
  String postDepartmentManage = _baseUrl + 'manage/postDepartment';
  // -- * องค์กร -------
  String postOrg = _baseUrl + 'manage/postOrg';
  String getOrgAdmin = _baseUrl + 'manage/getOrg';
  String updateOrgSwitch = _baseUrl + 'manage/updateSwitchOrg';
  String updateOrgSuspend = _baseUrl + 'manage/updateSuspendOrg'; // ระงับบริษัท

  //---- *switch protect
  String getProtectSwitch = _baseUrl + 'protectapp/protectSwitch';
  Server() : super();
}
