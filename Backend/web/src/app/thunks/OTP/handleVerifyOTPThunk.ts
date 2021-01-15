import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../routes";
import { toast } from "react-toastify";
import addBeneficiarySlice from "../../slices/AddBeneficiarySlice";
import bankTransferSlice from "../../slices/BankTransferSlice";
import deleteBeneficiarySlice from "../../slices/DeleteBeneficiarySlice";
import { getHeaders } from "../configHelper";

const handleVerifyOTP = (token: string, OTP: string, type: string) => (dispatch: Dispatch) => {
  toast.clearWaitingQueue();
  axios
    .post(routes.api.otp.verifyOTP, {
      requestBody: {
        timestamp: "1542359523",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          otp: OTP
        }
      }
    },getHeaders(token))
    .then(response => {
      if (response.data.status !== "Failed") {
        if (type === "1") dispatch(addBeneficiarySlice.actions.setOTPResponse(response.data.data.response));
        if (type === "2") dispatch(deleteBeneficiarySlice.actions.setOTPResponse(response.data.data.response));
        if (type === "3") dispatch(bankTransferSlice.actions.setOTPResponse(response.data.data.response));
      } else {
        toast.error("OTP is invalid");
      }
    }).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleVerifyOTP;
