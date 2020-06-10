import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../../routes";
import { toast } from "react-toastify";
const handleForgotPasswordChangePassword = (
  userid: string,
  otpRespose: string,
  password: string
) => (dispatch: Dispatch) => {
  axios
    .post(routes.api.forgotPassword.resetUser, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          userid: userid,
          otp_response: otpRespose,
          new_pass: password
        }
      }
    })
    .then(response => {
      if (response.data.status !== "Failed") {
        toast.info(
          "Password Reset Successful. \n Taking you back to Login Page.",
          {
            position: "top-center" 
          }
        );

        window.setInterval(() => window.location.assign("/"), 5000);
      } else {
        toast.error("Password Validation Failed", {
          position: "top-center" 
        });
      }
    }).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleForgotPasswordChangePassword;
