import config from "./config/config";

const get = (route: string) => route;
const BASE_URL = config.api.URL;

const routes = {
  api: {
    authentication: {
      login: get(BASE_URL + "/login"),
      logout: get(BASE_URL + "/logout"),
      signup: get(BASE_URL + "/signup")
    },
    beneficiary: {
      allBeneficiary: get(BASE_URL + "/beneficiary/list"),
      beneficiaryDetails: get(BASE_URL + "/beneficiary/fetch"),
      addBeneficiary: get(BASE_URL + "/beneficiary/add"),
      deleteBeneficiary: get(BASE_URL + "/beneficiary/delete")
    },

    otp: {
      getOTP: get(BASE_URL + "/otp/get"),
      verifyOTP: get(BASE_URL + "/otp/verify")
    },
    forgotPassword: {
      forgotPassword: get(BASE_URL + "/password/forgot"),
      verifyUser: get(BASE_URL + "/password/verifyuser"),
      resetUser: get(BASE_URL + "/password/reset")
    },
    fundTransfer: {
      getAliasBankTransfer: get(BASE_URL + "/beneficiary/get"),
      payBankTransfer: get(BASE_URL + "/beneficiary/pay")
    },
    user: {
      userProfile: get(BASE_URL + "/account/details"),
      editProfile: get(BASE_URL + "/editUser/editUserDetails")
    },
    loan:{
      apply:get(BASE_URL + "/loan/apply"),
      appliedLoan:get(BASE_URL + "/loan"),
    },
    accountStatement: get(BASE_URL + "/account/statement"),
    changePassword: get(BASE_URL + "/password/change"),
    about: get(BASE_URL + "/show?file=about.html"),
    contactUs: get(BASE_URL + "/contactUs"),

  },

  app: {
    authentication: {
      login: get("/"),
      signup: get("/signup"),
      forgot: get("/forgot")
    },
    beneficiary: {
      viewBeneficiary: get("/beneficiary/view"),
      addBeneficiary: get("/beneficiary/add")
    },
    fundTransfer: {
      bank: get("/transfer/bank"),
      wallet: get("/transfer/wallet")
    },
    user: {
      userProfile: get("/profile"),
      editUser: get("/profile/edit")
    },
    loan:{
      apply:get("/loan/apply"),
      appliedLoans:get("/loan"),
    },
    dashboard: get("/dashboard"),
    accountStatement: get("/account"),
    about: get("/about"),
    changePassword: get("/password/change"),
    contactUs:get("/contact-us")
  }
};

export default routes;
