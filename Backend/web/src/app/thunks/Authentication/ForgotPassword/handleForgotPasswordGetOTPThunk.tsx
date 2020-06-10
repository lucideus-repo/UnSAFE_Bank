import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../../routes";
import crypto from "crypto";
import { toast } from "react-toastify";
import forgotpasswordSlice from "../../../slices/ForgotPasswordSlice";
import React from "react";
toast.clearWaitingQueue({ containerId: "anId" });

const handleForgotPasswordGetOTP = (username: string) => (
  dispatch: Dispatch
) => {
  axios
    .post(routes.api.forgotPassword.forgotPassword, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          userid: username,
          otp_type: "4"
        }
      }
    })
    .then(response => {
      if (response.data.status !== "Failed") {
        var encryptionMethod = "AES-256-CBC";
        var encryptedMessage = response.data.data.response;
        var secret = "9bbc0d79e686e847bc305c9bd4cc2ea6";
        var iv = "0123456789abcdef";

        var decrypt = function(
          encryptedMessage: string,
          encryptionMethod: string,
          secret: string,
          iv: string
        ) {
          var decryptor = crypto.createDecipheriv(encryptionMethod, secret, iv);
          return (
            decryptor.update(encryptedMessage, "base64", "utf8") +
            decryptor.final("utf8")
          );
        };
        var decryptedMessage = decrypt(
          encryptedMessage,
          encryptionMethod,
          secret,
          iv
        );

        setTimeout(() => {
          toast.info(()=> <div>Your One Time Password is <b>{decryptedMessage}</b>. Do not share this OTP for security reasons.</div>, {
            position: "top-center" ,
            autoClose: 10000
          });
        }, Math.random() * 15 * 1000);
        
        dispatch(forgotpasswordSlice.actions.setOTPDecoded(decryptedMessage));
      } else {
        toast.clearWaitingQueue();
        toast.error("Customer ID is invalid");
      }
    }).catch(res=>(toast.error("Backend Server is unresponsive.")));
};

export default handleForgotPasswordGetOTP;
