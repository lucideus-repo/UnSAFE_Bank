import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../../routes";
import { toast } from "react-toastify";
import forgotpasswordSlice from "../../../slices/ForgotPasswordSlice";

const handleForgotPasswordVerifyOTP = (userid: string, otp: string) => (dispatch: Dispatch) => {
  axios
    .post(routes.api.forgotPassword.verifyUser, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          userid: userid,
          otp: otp
        }
      }
    })
    .then(response => {
      if (response.data.status !== "Failed") {
        var encryptedMessage = response.data.data.response;
        dispatch(forgotpasswordSlice.actions.setOTPResponse(encryptedMessage));
      } else {
        toast.error("OTP is invalid", { position: "top-center" });
      }
    }).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleForgotPasswordVerifyOTP;
