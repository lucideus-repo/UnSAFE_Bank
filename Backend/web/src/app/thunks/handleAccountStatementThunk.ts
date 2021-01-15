import { Dispatch } from "redux";
import axios from "axios";
import routes from "../routes";
import accountStatementSlice from "../slices/AccountStatementSlice";
import { toast } from "react-toastify";
import { getHeaders } from "./configHelper";

const handleAccountStatement = ({ token }: { token: string }) => (
  dispatch: Dispatch
) => {
  dispatch(accountStatementSlice.actions.setLoading);
  axios
    .post(
      routes.api.accountStatement,
      {
        requestBody: {
          timestamp: "325553",
          device: {
            deviceid: "UHDGGF735SVHFVSX",
            os: "ios",
            host: "lucideustech.com"
          },
          data: {}
        }
      }
      ,getHeaders(token)
    )
    .then((response) => {
      if (response.data.status !== "Failed") {
        dispatch(accountStatementSlice.actions.setLoaded());
        dispatch(
          accountStatementSlice.actions.setAccountStatement(
            response.data.data.statement
          )
        );
      }
    })
    .catch((res) =>
      toast.error("Backend Server is unresponsive.", { position: "top-center" })
    );
};

export default handleAccountStatement;
