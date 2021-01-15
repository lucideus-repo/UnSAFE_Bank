import { Dispatch } from "redux";
import axios from "axios";
import routes from "../../routes";
import { toast } from "react-toastify";
import bankTransferSlice from "../../slices/BankTransferSlice";
import { getHeaders } from "../configHelper";
const handleBankFundTransfer = (
  token: string,
  alias: string,
  amount: string,
  remarks: string,
  otpRespose: string
) => (dispatch: Dispatch) => {
  axios
    .post(routes.api.fundTransfer.payBankTransfer, {
      requestBody: {
        timestamp: "325553",
        device: {
          deviceid: "UHDGGF735SVHFVSX",
          os: "ios",
          host: "lucideustech.com"
        },
        data: {
          alias: alias,
          amount: amount,
          remarks: remarks,
          otp_response: otpRespose
        }
      }
    },getHeaders(token))
    .then((response) => {
      if (response.data.status !== "Failed") {
        dispatch(
          bankTransferSlice.actions.setReferenceNumber(
            response.data.data.transaction_id
          )
        );
        dispatch(bankTransferSlice.actions.setModal());
        let userData = JSON.parse(localStorage.getItem("userData")!);
        userData.acctBalance = response.data.data.updated_balance;
        localStorage.setItem("userData", JSON.stringify(userData));
      } else {
        toast.error(response.data.message, {
          position: "top-center" 
        });
      }
    }).catch(res=>(toast.error("Backend Server is unresponsive.",{position: "top-center"})));
};

export default handleBankFundTransfer;
