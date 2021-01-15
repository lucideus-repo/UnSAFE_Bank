import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../routes";
import crypto from "crypto";
import { toast } from "react-toastify";
import addBeneficiarySlice from "../../slices/AddBeneficiarySlice";
import bankTransferSlice from "../../slices/BankTransferSlice";
import React from "react";
import deleteBeneficiarySlice from "../../slices/DeleteBeneficiarySlice";
import { getHeaders } from "../configHelper";

const handleGetOTP = (token: string, type: string) => (dispatch: Dispatch) => {
  axios
    .post(routes.api.otp.getOTP, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          otp_type: type
        }
      }
    },getHeaders(token))
    .then(response => {
      if (response.data.status !== "Failed") {
        var encryptionMethod = "AES-256-CBC";
        var encryptedMessage = response.data.data.response;
        var secret = "9bbc0d79e686e847bc305c9bd4cc2ea6";
        var iv = "0123456789abcdef";

        var decrypt = function (encryptedMessage: string, encryptionMethod: string, secret: string, iv: string) {
          var decryptor = crypto.createDecipheriv(encryptionMethod, secret, iv);
          return decryptor.update(encryptedMessage, "base64", "utf8") + decryptor.final("utf8");
        };
        var decryptedMessage = decrypt(encryptedMessage, encryptionMethod, secret, iv);
        setTimeout(() => {
          toast.info(
            () => (
              <div>
                Your One Time Password is <b> {decryptedMessage}</b>. Do not share this OTP for security reasons.
              </div>
            ),
            {
              autoClose: 10000
            }
          );
        }, Math.random() * 15 * 1000);

        if (type === "1") dispatch(addBeneficiarySlice.actions.setOTPDecoded(decryptedMessage));
        if (type === "2") dispatch(deleteBeneficiarySlice.actions.setOTPDecoded(decryptedMessage));
        if (type === "3") dispatch(bankTransferSlice.actions.setOTPDecoded(decryptedMessage));
      } else {
        toast.error(response.data.message);
      }
    })
    .catch(res => toast.error("Backend Server is unresponsive.", { position: "top-center" }));
};

export default handleGetOTP;
